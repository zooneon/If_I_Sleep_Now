//
//  HomeViewController.swift
//  I2SN
//
//  Created by 권준원 on 2021/01/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    var alarmTime : Date?
    var btnStartFlag = true
    let timeSelector: Selector = #selector(HomeViewController.updateTime)
    let interval = 1.0
    // default값 30분
    var timeInterval = 30
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet var lblRemainTime: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let vc: SettingViewController = segue.destination as! SettingViewController
            vc.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        setNavigationBar()
        setDatePicker()
        
        lblRemainTime.isHidden = true
    }
    
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm:ss"
        
        let settingTime = formatter.string(from: datePickerView.date)
        
        alarmTime = formatter.date(from: settingTime)
    }
    
    @IBAction func btnStartAction(_ sender: UIButton) {
        if btnStartFlag == true {
            Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
            
            datePicker.isHidden = true
            lblRemainTime.isHidden = false
            btnStartFlag = false
            btnStart.setTitle("그만", for: .normal)
        }
        else {
            datePicker.isHidden = false
            lblRemainTime.isHidden = true
            btnStartFlag = true
            btnStart.setTitle("시작", for: .normal)
        }
    }
}

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
        
        let sec = integerToString(diff%60)
        diff = diff/60
        let min = integerToString(diff%60)
        diff = diff/60
        let hour = integerToString(diff)
        
        let timeString = "\(hour) : \(min) : \(sec)"
        
        lblRemainTime.text = timeString
        lblRemainTime.textColor = UIColor.white
        lblRemainTime.font = UIFont.systemFont(ofSize: CGFloat(50))
        
        
        if timeInterval == 10 {
            if(min == "00" && sec == "00") {
                setTimeAlert(timeString: timeString)
            }
            if(min == "10" && sec == "00") {
                setTimeAlert(timeString: timeString)
            }
            if(min == "20" && sec == "00") {
                setTimeAlert(timeString: timeString)
            }
            if(min == "30" && sec == "00") {
                setTimeAlert(timeString: timeString)
            }
            if(min == "40" && sec == "00") {
                setTimeAlert(timeString: timeString)
            }
            if(min == "50" && sec == "00") {
                setTimeAlert(timeString: timeString)
            }
        }
        
        if timeInterval == 30 {
            if(min == "30" && sec == "00") {
                setTimeAlert(timeString: timeString)
            }
            if(min == "00" && sec == "00") {
                setTimeAlert(timeString: timeString)
            }
        }
        
        if timeInterval == 60 {
            if(min == "00" && sec == "00") {
                setTimeAlert(timeString: timeString)
            }
        }
        
    }
    
    func integerToString(_ number: Int) -> String {
        if number < 10 {
            return "0" + String(number)
        } else {
            return String(number)
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
    
    func setTimeAlert(timeString: String) {
        let timeAlert = UIAlertController(title: "지금자면..🛌", message: timeString + "잘 수 있습니다.", preferredStyle: UIAlertController.Style.alert)
        let onAction = UIAlertAction(title: "네 알겠습니다!", style: UIAlertAction.Style.default, handler: nil)
        
        timeAlert.addAction(onAction)
        present(timeAlert, animated: true, completion: nil)
    }
    
    
}

extension HomeViewController: TimeIntervalDelegate {
    func setTimeInterval(timeInterval: Int) {
        self.timeInterval = timeInterval
        print(timeInterval)
    }
}
