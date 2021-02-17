//
//  HomeViewController.swift
//  I2SN
//
//  Created by 권준원 on 2021/01/23.
//

import UIKit
import AVFoundation
import UserNotifications
import AudioToolbox

class HomeViewController: UIViewController, AVAudioPlayerDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet var lblRemainTime: UILabel!
    
    private var alarmTime: Date?
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
    
    private var vibrationFlag = false
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
        // 알람 시간 설정
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "dd HH:mm"
        var settingTime = formatter.string(from: datePickerView.date)
        alarmTime = formatter.date(from: settingTime)
        
        // 다음날로 알람을 설정할 경우
        let timeDifferent = calculateTimeDifferent()
        if timeDifferent < 0 {
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
            let timeDifferent = calculateTimeDifferent()
            let remainTimeDic = calculateRemainTime(timeDifferent)
            setRemainTimeLabel(remainTimeDic)
            startTimer()
            startNotification(timeDifferent)
            setWarningMessage()
            setAlarm()
        }
        else {
            initializeTimer()
            changeState()
            // 모든 알림 삭제
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            // 알람 소리 종료
            if audioPlayerFlag == true {
                audioPlayer.stop()
                audioPlayerFlag = false
            }
            // 알람 진동 종료
            vibrationFlag = false
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
        self.navigationController?.navigationBar.barStyle = .black
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
    // 타이머 초기화
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
    // 알람 시간과 현재 시간의 차이 계산
    func calculateTimeDifferent() -> Int {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd HH:mm:ss"
        let nowTime = formatter.string(from: date as Date)
        let currentTime = formatter.date(from: nowTime)!
        return Int(alarmTime?.timeIntervalSince(currentTime) ?? 0)
    }
    
    // MARK: 남은 시간 계산
    func calculateRemainTime(_ timeDifferent: Int) -> [String: String] {
        var timeDifferent = timeDifferent
        
        let sec = integerToString(timeDifferent % 60)
        timeDifferent = timeDifferent / 60
        let min = integerToString(timeDifferent % 60)
        timeDifferent = timeDifferent / 60
        let hour = integerToString(timeDifferent)
        
        return ["sec": sec, "min": min, "hour": hour]
    }
    
    func integerToString(_ number: Int) -> String {
        // 10보다 작을 경우 앞에 0을 추가 (eg: 7 -> 07)
        if number < 10 {
            return "0" + String(number)
        } else {
            return String(number)
        }
    }
    // view 설정
    func setRemainTimeLabel(_ remainTimeDic: [String: String]) {
        let hour = remainTimeDic["hour"]
        let min = remainTimeDic["min"]
        let sec = remainTimeDic["sec"]
        let timeString = "\(hour!) : \(min!) : \(sec!)"
        lblRemainTime.text = timeString
        lblRemainTime.textColor = UIColor.white
        lblRemainTime.font = UIFont.systemFont(ofSize: 55, weight: .thin)
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
    
    func startVibration() {
        AudioServicesPlayAlertSoundWithCompletion(kSystemSoundID_Vibrate) {
            if self.vibrationFlag == true {
                self.startVibration()
            }
            else {
                return
            }
        }
    }
}

// MARK: - feature: Notification
extension HomeViewController {
    @objc func updateTime() {
        let timeDifferent = calculateTimeDifferent()
        if timeDifferent <= 0 {
            lblRemainTime.text = "00 : 00 : 00"
            lblRemainTime.textColor = UIColor.white
            lblRemainTime.font = UIFont.systemFont(ofSize: 55, weight: .thin)
            // 알람 소리 설정
            audioPlayerFlag = true
            audioFile = Bundle.main.url(forResource: sound, withExtension: "mp3")
            initSoundPlayer()
            audioPlayer.play()
            // 알람 진동 설정
            vibrationFlag = true
            startVibration()
            // 타이머 초기화
            initializeTimer()
            return
        }

        let remainTimeDic = calculateRemainTime(timeDifferent)
        setRemainTimeLabel(remainTimeDic)
    }
    
    // MARK: 알림 시작
    func startNotification(_ timeDifferent: Int) {
        let countNotification = timeDifferent / (timeInterval * 60)
        let remainNotification = timeDifferent % (timeInterval * 60)
        let remainSecond = countNotification * (timeInterval * 60)
        
        notificateTime(current: 1, countNotification: countNotification, remainNotification: remainNotification, remainSecond: remainSecond, TimeString: "notification")
    }
    
    // MARK: 알림 예약 설정
    func notificateTime(current: Int, countNotification: Int, remainNotification: Int, remainSecond: Int, TimeString: String) {
        if current <= countNotification {
            let contentNotification = UNMutableNotificationContent()
            contentNotification.title = "지금자면 🛌"
            
            if timeInterval == 60 {
                let remainHour = remainSecond / (timeInterval * 60)
                contentNotification.body = "\(remainHour)시간 잘 수 있습니다."
            }
            else {
                let dividedSecond = remainSecond / 60
                let remainMin = dividedSecond % 60
                let remainHour = dividedSecond / 60
                
                if remainMin == 0 {
                    contentNotification.body = "\(remainHour)시간 잘 수 있습니다."
                }
                else {
                    if remainHour == 0 {
                        contentNotification.body = "\(remainMin)분 잘 수 있습니다."
                    }
                    else {
                        contentNotification.body = "\(remainHour)시간\(remainMin)분 잘 수 있습니다."
                    }
                }
            }
            
            let triggerTime = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(remainNotification), repeats: false)
            let requestTime = UNNotificationRequest(identifier: TimeString, content: contentNotification, trigger: triggerTime)
            UNUserNotificationCenter.current().add(requestTime, withCompletionHandler: nil)
            
            self.notificateTime(current: current + 1, countNotification: countNotification, remainNotification: remainNotification + (timeInterval * 60), remainSecond: remainSecond - (timeInterval * 60), TimeString: "\(current)")
        }
    }
    
    func setWarningMessage() {
        let content = UNMutableNotificationContent()
        content.title = "지금자면 🛌"
        content.body = "무음모드 시 알람음이 울리지 않습니다. 소리를 켜주세요."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 90, repeats: false)
        let request = UNNotificationRequest(identifier: "warning", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // MARK: 알람 예약 설정
    func setAlarm() {
        // 일어날 시간
        let formatter = DateFormatter()
        var alarmDate = DateComponents()
        formatter.dateFormat = "HH"
        let alarmHour = formatter.string(from: datePicker.date)
        alarmDate.hour = Int(alarmHour)
        formatter.dateFormat = "mm"
        let alarmMin = formatter.string(from: datePicker.date)
        alarmDate.minute = Int(alarmMin)
        
        // 알람 notification 예약
        let content = UNMutableNotificationContent()
        content.title = "지금자면 🛌"
        content.body = "일어날 시간입니다!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sound).mp3"))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: alarmDate, repeats: false)
        let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
