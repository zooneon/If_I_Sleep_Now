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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        setNavigationBar()
        setDatePicker()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, Error in})
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
        formatter.dateFormat = "dd HH:mm"
        var settingTime = formatter.string(from: datePickerView.date)
        alarmTime = formatter.date(from: settingTime)

        let date = Date()
        formatter.dateFormat = "dd HH:mm:ss"
        let nowTime = formatter.string(from: date as Date)
        let currentTime = formatter.date(from: nowTime)!
        let diff = Int(alarmTime?.timeIntervalSince(currentTime) ?? 0)
        
        if diff < 0 {
            formatter.dateFormat = "dd"
            var alarmDay = formatter.string(from: datePicker.date)
            var alarmIntDay = Int(alarmDay)
            alarmIntDay = alarmIntDay! + 1
            
            alarmDay = String(alarmIntDay!)
            
            formatter.dateFormat = "HH:mm"
            settingTime = formatter.string(from: datePicker.date)
            formatter.dateFormat = "dd HH:mm"
            settingTime = "\(alarmDay) \(settingTime)"
            alarmTime = formatter.date(from: settingTime)
        }
        
    }
    
    @IBAction func btnStartAction(_ sender: UIButton) {
        if btnStartFlag == true {
            notifyRemainTime()
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd HH:mm:ss"
            let nowTime = formatter.string(from: date as Date)
            let currentTime = formatter.date(from: nowTime)!
            let diff = Int(alarmTime?.timeIntervalSince(currentTime) ?? 0)
            var diffTemp = diff
            
            // MARK: 남은 시간 계산
            let sec = integerToString(diffTemp%60)
            diffTemp = diffTemp/60
            let min = integerToString(diffTemp%60)
            diffTemp = diffTemp/60
            let hour = integerToString(diffTemp)
            
            let timeString = "\(hour) : \(min) : \(sec)"
            lblRemainTime.text = timeString
            lblRemainTime.textColor = UIColor.white
            lblRemainTime.font = UIFont.systemFont(ofSize: 55, weight: .thin)
            startTimer()
            
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
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: timeSelector, userInfo: nil, repeats: true)
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
        formatter.dateFormat = "dd HH:mm:ss"
        let nowTime = formatter.string(from: date as Date)
        let currentTime = formatter.date(from: nowTime)!
        let diff = Int(alarmTime?.timeIntervalSince(currentTime) ?? 0)
    
        if diff <= 0 {
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

        var diffTemp = diff
        
        // MARK: 남은 시간 계산
        let sec = integerToString(diffTemp%60)
        diffTemp = diffTemp/60
        let min = integerToString(diffTemp%60)
        diffTemp = diffTemp/60
        let hour = integerToString(diffTemp)
        
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
}
