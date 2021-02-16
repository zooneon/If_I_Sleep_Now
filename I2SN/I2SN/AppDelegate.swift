//
//  AppDelegate.swift
//  I2SN
//
//  Created by 손상준 on 2021/01/22.
//

import UIKit
import Firebase
import AVFoundation
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var alarmTime : Date?
    var timeString = "시간을 계산하는 중입니다."
    var timeInterval = UserDefaults.standard.integer(forKey: DataKeys.timeInterval) != 0 ? UserDefaults.standard.integer(forKey: DataKeys.timeInterval) : 30

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch let error as NSError {
            print("Error : \(error), \(error.userInfo)")
        }
                
        do {
             try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            print("Error: Could not setActive to true: \(error), \(error.userInfo)")
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.hand.I2SN.notifyRemainTime", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        return true
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.hand.I2SN.notifyRemainTime")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60)
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Could not schedule app refresh: \(error.localizedDescription)")
            }
        }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        calculateRemainTime()
        task.setTaskCompleted(success: true)
    }
    
    func calculateRemainTime() {
        let formatter = DateFormatter()
        let date = Date()
        formatter.dateFormat = "dd HH:mm:ss"
        let nowTime = formatter.string(from: date as Date)
        let currentTime = formatter.date(from: nowTime)!
        let diff = Int(alarmTime?.timeIntervalSince(currentTime) ?? 0)
        
        var diffTemp = diff
        
        // MARK: 남은 시간 계산
        diffTemp = diffTemp/60
        let min = diffTemp%60
        diffTemp = diffTemp/60
        let hour = diffTemp
        
        let timeString = "\(hour)시간 \(min)분 잘 수 있습니다."
        self.timeString = timeString
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

