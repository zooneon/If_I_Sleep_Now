//
//  HomeViewController.swift
//  I2SN
//
//  Created by 권준원 on 2021/01/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet var lblRemainTime: UILabel!
    
    var alarmTime : Date?
    var timer: Timer?
    var btnStartFlag = true
    let timeSelector: Selector = #selector(HomeViewController.updateTime)
    // default값 30분
    var timeInterval = 30
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        setNavigationBar()
        setDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // default값 30분
        self.timeInterval = userDefaults.integer(forKey: DataKeys.timeInterval) != 0 ? userDefaults.integer(forKey: DataKeys.timeInterval) : 30
    }
    
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
        }
        else {
            initializeTimer()
        }
    }
    
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
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        datePicker.isHidden = true
        lblRemainTime.isHidden = false
        btnStartFlag = false
        btnStart.setTitle("그만", for: .normal)
    }
    
    func initializeTimer() {
        timer?.invalidate()
        timer = nil
        datePicker.isHidden = false
        lblRemainTime.isHidden = true
        btnStartFlag = true
        btnStart.setTitle("시작", for: .normal)
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
        // 현재시간이 알람시간을 지났을 경우
        if diff < 0 {
            diff = diff + 86400
        }
        // MARK: 남은 시간 계산
        let sec = integerToString(diff%60)
        diff = diff/60
        let min = integerToString(diff%60)
        diff = diff/60
        let hour = integerToString(diff)
        notifyRemainTime(hour, min, sec)
        
        let timeString = "\(hour) : \(min) : \(sec)"
        lblRemainTime.text = timeString
        lblRemainTime.textColor = UIColor.white
        lblRemainTime.font = UIFont.systemFont(ofSize: 55, weight: .regular)
    }
    
    func integerToString(_ number: Int) -> String {
        if number < 10 {
            return "0" + String(number)
        } else {
            return String(number)
        }
    }
    
    func notifyRemainTime(_ hour: String, _ min: String, _ sec: String) {
        // 남은 시간이 없으면 타이머 종료
        if "\(hour) : \(min) : \(sec)" == "00 : 00 : 00" {
           initializeTimer()
            return
        }
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
