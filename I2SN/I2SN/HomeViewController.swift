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
    var count = 0
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet var lblRemainTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        setNavigationBar()
        setDatePicker()
        
        lblRemainTime.isHidden = true
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
    
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm:ss"
        
        let settingTime = formatter.string(from: datePickerView.date)
        
        alarmTime = formatter.date(from: settingTime)
    }
    
    @IBAction func btnStartAction(_ sender: UIButton) {
        if(btnStartFlag == true){
            Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
            
            datePicker.isHidden = true
            lblRemainTime.isHidden = false
            
            startButton.setTitle("그만", for: .normal)
            btnStartFlag = false
        }
        else {
            datePicker.isHidden = false
            lblRemainTime.isHidden = true
            btnStartFlag = true
            startButton.setTitle("시작", for: .normal)
        }
    }
    
    @objc func updateTime() {
        let formatter = DateFormatter()
        let date = Date()
        
        formatter.dateFormat = "HH:mm:ss"
        
        let nowTime = formatter.string(from: date as Date)
        let currentTime = formatter.date(from: nowTime)!
        
        var diff = Int(alarmTime?.timeIntervalSince(currentTime) ?? 0)
        
        var Time = ""
        var sec = 0
        var min = 0
        var hour = 0
        
        if(diff < 0) {
            diff = diff + 86400
        }
        
        sec = diff%60
        diff = diff/60
        
        min = diff%60
        diff = diff/60
        
        hour = diff
        
        
        if(hour < 10) {
            Time = "0" + String(hour)
        }
        else{
            Time = String(hour)
        }
        Time = Time + " : "
        
        if(min < 10) {
            Time = Time + "0" + String(min)
        }
        else{
            Time = Time + String(min)
        }
        Time = Time + " : "
        
        if(sec < 10) {
            Time = Time + "0" + String(sec)
        }
        else {
            Time = Time + String(sec)
        }
        
        lblRemainTime.text = Time
        lblRemainTime.textColor = UIColor.white
        lblRemainTime.font = UIFont.systemFont(ofSize: CGFloat(50))
        
    }
}
