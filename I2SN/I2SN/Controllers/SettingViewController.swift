//
//  SettingViewController.swift
//  I2SN
//
//  Created by 손상준 on 2021/01/22.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 5
        tableView.rowHeight = 44
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // default값 30분
        self.timeInterval = userDefaults.integer(forKey: DataKeys.timeInterval) != 0 ? userDefaults.integer(forKey: DataKeys.timeInterval) : 30
    }
    
    let timeIntervalArray = [10, 30, 60]
    // default값 30분
    var timeInterval = 30
    let userDefaults = UserDefaults.standard
    
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

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeIntervalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as? TimeCell else {
            return UITableViewCell()
        }
        
        cell.timeLabel.text = "\(timeIntervalArray[indexPath.row])분"
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    // 셀에 있는 모든 체크마크를 지움
    func resetAccessoryType(){
        for section in 0..<self.tableView.numberOfSections{
            for row in 0..<self.tableView.numberOfRows(inSection: section){
                let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section))
                cell?.accessoryType = .none
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resetAccessoryType()
        guard let cell = tableView.cellForRow(at: indexPath) as? TimeCell else { return }
        // 선택된 셀에 체크마크 표시
        cell.accessoryType = .checkmark
        
        guard let timeString = cell.timeLabel.text else { return }
        let endIdx = timeString.index(timeString.startIndex, offsetBy: 1)
        userDefaults.set(Int(timeString[...endIdx]), forKey: DataKeys.timeInterval)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if timeIntervalArray.firstIndex(of: timeInterval) == indexPath.row {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
    }
}
