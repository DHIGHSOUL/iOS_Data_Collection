//
//  AppDelegate.swift
//  iOSDataCollection
//
//  Created by ROLF J. on 2022/07/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.integer(forKey: "appAuthorization") != 1 {
            MainViewController.shared.requestLocationAuthorization()
            NotificationManager.shared.requestNotificationAuthorization()
            HealthDataManager.shared.requestHealthDataAuthorization()
            UserDefaults.standard.setValue(false, forKey: "todayUploadState")
            let appStartTime = Date()
            let appStartDate = String(Int(appStartTime.timeIntervalSince1970))
            UserDefaults.standard.setValue(appStartDate, forKey: "appStartDate")
            print(appStartTime)
            let nextUploadDate = Calendar.current.date(byAdding: .day, value: 1, to: appStartTime)
            let nextUploadUnixTime = String(Int(nextUploadDate?.timeIntervalSince1970 ?? 0.0))
            UserDefaults.standard.setValue(nextUploadUnixTime, forKey: "nextUploadDate")
        } else {
            NotificationManager.shared.notificationCenter.delegate = self
            MenuViewController.shared.checkUploadState()
            MainViewController.shared.makeRealm()
            CSVFileManager.shared.createSensorCSVFolder()
            CSVFileManager.shared.createHealthCSVFolder()
            NotificationManager.shared.setAskSurveyNotification()
            NotificationManager.shared.setAskUploadHealthDataNotification()
            NetWorkManager.shared.startMonitoring()
//            HealthDataManager.shared.setHealthDataLoop()
            DataCollectionManager.shared.dataCollectionManagerMethod()
            DataCollectionManager.shared.checkAndReUploadSensorFiles()
//            HealthDataManager.shared.checkAndReUploadHealthFiles()
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if UserDefaults.standard.integer(forKey: "appAuthorization") == 1 {
            NotificationManager.shared.setTerminateNotification()
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Foreground ???????????? ?????? ????????? ???????????? ?????? ??????
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
    }
    
    // ????????????????????? ????????? ???????????? ????????? ?????? ??????, ?????? ????????? ????????? ?????? ?????????
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NotificationManager.shared.notificationCenter.removeAllPendingNotificationRequests()
        NotificationManager.shared.notificationCenter.removeAllDeliveredNotifications()
        NotificationManager.shared.setAskSurveyNotification()
        NotificationManager.shared.setAskUploadHealthDataNotification()
        
        completionHandler()
    }
    
}
