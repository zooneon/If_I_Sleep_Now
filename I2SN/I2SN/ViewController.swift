//
//  ViewController.swift
//  I2SN
//
//  Created by 손상준 on 2021/01/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var btnStart: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        setNavigationBar()
        setDatePicker()
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
}

