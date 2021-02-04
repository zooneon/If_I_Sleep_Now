//
//  SettingViewController.swift
//  I2SN
//
//  Created by 손상준 on 2021/01/22.
//

import UIKit
import FirebaseAnalytics

class SettingViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var timeTableView: UITableView!
    @IBOutlet weak var soundTableView: UITableView!
    
    private let timeIntervalArray = [10, 30, 60]
    // default값 30분
    private var timeInterval = 30
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        setNavigationBar()
        setTableViewLayout()
        timeTableView.dataSource = self
        timeTableView.delegate = self
        soundTableView.dataSource = self
        soundTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // default값 30분
        self.timeInterval = userDefaults.integer(forKey: DataKeys.timeInterval) != 0 ? userDefaults.integer(forKey: DataKeys.timeInterval) : 30
    }
    
    // MARK: - Actions
    @IBAction func btnCompleteAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
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
        navigationItem.hidesBackButton = true
    }
    
    func setTableViewLayout() {
        timeTableView.layer.cornerRadius = 5
        timeTableView.rowHeight = 44
        soundTableView.layer.cornerRadius = 5
        soundTableView.rowHeight = 44
    }
}

// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == timeTableView {
            return timeIntervalArray.count
        }
        if tableView == soundTableView {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == timeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath)
            cell.textLabel?.text = "\(timeIntervalArray[indexPath.row])분"
            cell.textLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            return cell
        }
        if tableView == soundTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell", for: indexPath)
            cell.textLabel?.text = "알람음 선택"
            cell.textLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    // 셀에 있는 모든 체크마크를 지움
    func resetAccessoryType(){
        for row in 0..<self.timeTableView.numberOfRows(inSection: 0){
            let cell = self.timeTableView.cellForRow(at: IndexPath(row: row, section: 0))
            cell?.accessoryType = .none
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == timeTableView {
            resetAccessoryType()
            guard let cell = timeTableView.cellForRow(at: indexPath) as? TimeCell else { return }
            // 선택된 셀에 체크마크 표시
            cell.accessoryType = .checkmark
            timeInterval = timeIntervalArray[indexPath.row]
            userDefaults.set(timeInterval, forKey: DataKeys.timeInterval)
            // GA - custom event 추가
            Analytics.logEvent("set_timeInterval", parameters: ["timeInterval": timeInterval as Int])
        }
        if tableView == soundTableView {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SoundViewController") as? SoundViewController else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == timeTableView {
            if timeIntervalArray.firstIndex(of: timeInterval) == indexPath.row {
                timeTableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            }
        }
    }
}
