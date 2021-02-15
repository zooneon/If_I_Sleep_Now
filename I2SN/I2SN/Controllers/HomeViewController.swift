//
//  HomeViewController.swift
//  I2SN
//
//  Created by 권준원 on 2021/01/23.
//

import UIKit
import AVFoundation
import UserNotifications

class HomeViewController: UIViewController, AVAudioPlayerDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet var lblRemainTime: UILabel!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var alarmTime : Date?
    private var timer: Timer?
    private var btnStartFlag = true
    private let timeSelector: Selector = #selector(HomeViewController.updateTime)
    // default값 30분
    private var timeInterval = 30
    // default sound "삐삐"
    private var sound = "삐삐"
    private let userDefaults = UserDefaults.standard
    
    private var audioPlayer : AVAudioPlayer!
    private var audioFile : URL!
    private var audioPlayerFlag = false
    private var diffFlag = false
    
    private var firstFlag = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        setNavigationBar()
        setDatePicker()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, Error in})
        appDelegate.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // default값 30분
        self.timeInterval = userDefaults.integer(forKey: DataKeys.timeInterval) != 0 ? userDefaults.integer(forKey: DataKeys.timeInterval) : 30
        // default sound "삐삐"
        self.sound = userDefaults.string(forKey: DataKeys.alarmSound) ?? "삐삐"
    }
    
    // MARK: - Actions
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let settingTime = formatter.string(from: datePickerView.date)
        alarmTime = formatter.date(from: settingTime)
    }
    
    @IBAction func btnStartAction(_ sender: UIButton) {
        if btnStartFlag == true {
            startTimer()
            let formatter = DateFormatter()
            let content = UNMutableNotificationContent()
            content.title = "지금자면 🛌"
            content.body = "일어날 시간 입니다!"
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sound).mp3"))
            
            var date2 = DateComponents()
            formatter.dateFormat = "HH"
            let alarmHour = formatter.string(from: datePicker.date)
            date2.hour = Int(alarmHour)
            formatter.dateFormat = "mm"
            let alarmMin = formatter.string(from: datePicker.date)
            date2.minute = Int(alarmMin)
            
            //알람 시간 notification 예약
            let trigger = UNCalendarNotificationTrigger(dateMatching: date2, repeats: false)
            let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            
        }
        else {
            initializeTimer()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            if audioPlayerFlag == true {
                audioPlayer.stop()
                audioPlayerFlag = false
            }
            firstFlag = false
            changeState()
        }
    }
    
    // MARK: - Configure UI
    func assignBackground(){
        let background = UIImage(named: "background.jpg")
        var imageView : UIImageView!
        
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }

    func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func setDatePicker() {
        datePicker.setValue(UIColor.white, forKey: "textColor")
    }
    
    // MARK: - Methods
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        datePicker.isHidden = true
        lblRemainTime.isHidden = false
        btnStartFlag = false
        btnStart.setTitle("그만", for: .normal)
    }
    
    func initializeTimer() {
        diffFlag = false
        timer?.invalidate()
        timer = nil
    }
    
    func changeState() {
        datePicker.isHidden = false
        lblRemainTime.isHidden = true
        btnStartFlag = true
        btnStart.setTitle("시작", for: .normal)
    }
    
    func initSoundPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
            audioPlayer.volume = 63.5
            audioPlayer.numberOfLoops = -1
        } catch let error as NSError {
            print("initError : \(error)")
        }
        
    }
}

// MARK: - feature: Notification
extension HomeViewController {
    @objc func updateTime() {
        let formatter = DateFormatter()
        let date = Date()
        formatter.dateFormat = "HH:mm:ss"
        let nowTime = formatter.string(from: date as Date)
        let currentTime = formatter.date(from: nowTime)!
        var diff = Int(alarmTime?.timeIntervalSince(currentTime) ?? 0)
        var fixedTime = 0
        
        
        // 현재시간이 알람시간을 지났을 경우
        if diff <= 0 {
            if firstFlag == false {
                diff = diff + 86400
                firstFlag = true
            }
            else {
                lblRemainTime.text = "00 : 00 : 00"
                lblRemainTime.textColor = UIColor.white
                lblRemainTime.font = UIFont.systemFont(ofSize: 55, weight: .thin)
                audioPlayerFlag = true
                audioFile = Bundle.main.url(forResource: sound, withExtension: "mp3")
                initSoundPlayer()
                audioPlayer.play()
                initializeTimer()
                return
            }
        }
        
        if diffFlag == false {
            diffFlag = true
            
            if timeInterval == 10 {
                fixedTime = diff - 3600
            }
            else if timeInterval == 30 {
                fixedTime = diff - 10800
            }
            else if timeInterval == 60 {
                fixedTime = diff - 14400
            }
        }
        
        var diffTemp = diff
        
        // MARK: 남은 시간 계산
        let sec = integerToString(diffTemp%60)
        diffTemp = diffTemp/60
        let min = integerToString(diffTemp%60)
        diffTemp = diffTemp/60
        let hour = integerToString(diffTemp)
        
        // 알람 횟수 제한
        if diff > fixedTime {
            notifyRemainTime(hour, min, sec)
        }
        
        let timeString = "\(hour) : \(min) : \(sec)"
        lblRemainTime.text = timeString
        lblRemainTime.textColor = UIColor.white
        lblRemainTime.font = UIFont.systemFont(ofSize: 55, weight: .thin)
    }
    
    func integerToString(_ number: Int) -> String {
        if number < 10 {
            return "0" + String(number)
        } else {
            return String(number)
        }
    }
    
    func notifyRemainTime(_ hour: String, _ min: String, _ sec: String) {
        // MARK: 10분마다 알림
        if timeInterval == 10 {
            if min == "00" && sec == "00" {
                setTimeAlert(remainTimeString: remainTimeString(hour, min))
            }
            if min == "10" && sec == "00" {
                setTimeAlert(remainTimeString: remainTimeString(hour, min))
            }
            if min == "20" && sec == "00" {
                setTimeAlert(remainTimeString: remainTimeString(hour, min))
            }
            if min == "30" && sec == "00" {
                setTimeAlert(remainTimeString: remainTimeString(hour, min))
            }
            if min == "40" && sec == "00" {
                setTimeAlert(remainTimeString: remainTimeString(hour, min))
            }
            if min == "50" && sec == "00" {
                setTimeAlert(remainTimeString: remainTimeString(hour, min))
            }
        }
        // MARK: 30분마다 알림
        if timeInterval == 30 {
            if min == "30" && sec == "00" {
                setTimeAlert(remainTimeString: remainTimeString(hour, min))
            }
            if min == "00" && sec == "00" {
                setTimeAlert(remainTimeString: remainTimeString(hour, min))
            }
        }
        // MARK: 1시간마다 알림
        if timeInterval == 60 {
            if min == "00" && sec == "00" {
                setTimeAlert(remainTimeString: "\(Int(hour)!)시간")
            }
        }
        
    }
    
    func remainTimeString(_ hour: String, _ min: String) -> String {
        if hour == "00" {
            return "\(min)분"
        }
        
        if min == "00" {
            return "\(Int(hour)!)시간"
        }
        
        return "\(Int(hour)!)시간 \(min)분"
    }
    
    // TODO: 삭제하고 UserNotification 등록
    func setTimeAlert(remainTimeString: String) {
        let timeAlert = UIAlertController(title: "🛌 지금자면", message: "\(remainTimeString) 잘 수 있습니다!", preferredStyle: UIAlertController.Style.alert)
        let onAction = UIAlertAction(title: "네 알겠습니다!", style: UIAlertAction.Style.default, handler: nil)
        
        timeAlert.addAction(onAction)
        present(timeAlert, animated: true, completion: nil)
    }
}

// MARK: - Background task
extension HomeViewController: BackgroundDelegate {
    func notifyRemainTime() {
        <#code#>
    }
}
