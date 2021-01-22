//
//  SettingViewController.swift
//  I2SN
//
//  Created by 손상준 on 2021/01/22.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
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
}
