//
//  AppDelegate.swift
//  push_notification
//
//  Created by shin seunghyun on 2020/08/19.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //MARK: Firebase Configuration for remote message
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // Override point for customization after application launch.
        regiseterForPushNotification()
        
        ///Reset Application Badge Number whenever user opens an app
        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
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
    
    func regiseterForPushNotification() {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: ", granted)
            guard granted else {
                print("Permission rejected")
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
        }
        
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    //MARK: Firebase Push Message, set device token for firebase
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString: String = deviceToken.map{ String(format: "%02.2hhx", $0) }.joined()
        print("device token: ", deviceTokenString)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    //MARK: Firebase Push Message, Receive Remote Token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
    }
    
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //MARK: Firebase Push Message Set Up
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#function)")
        print("notification: ", notification)
    }
    
    //ios 13 미만
    func applicationDidBecomeActive(_ application: UIApplication) {
        ///Reset Application Badge Number whenever user opens an app
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    //MARK: Firebase 설치하기 전 코드
    //    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //        // 1. Convert device token to string
    //        let tokenParts = deviceToken.map { data -> String in
    //            return String(format: "%02.2hhx", data)
    //        }
    //        let token = tokenParts.joined()
    //        // 2. Print device token to use for PNs payloads
    //        print("Device Token: \(token)")
    //    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    
    /// Handle user actions on Push Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "like" {
            print("Handle like action identifier")
        } else if response.actionIdentifier == "save" {
            print("Handle save action identifier")
        } else {
            print("No custom action identifiers chosen")
        }
        // Make sure completionHandler method is at the bottom of this func
        completionHandler()
    }
    
}
