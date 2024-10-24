//
//  NotificationServiceUtils.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 18/09/2024.
//

import UIKit
import UserNotifications
class NotificationService: NSObject,UNUserNotificationCenterDelegate {
    
    static let shared: NotificationService = {
        let service = NotificationService()
        return service
    }()
    

    // Handle successful registration for remote notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device token: \\(token)")

        // Send the device token to your server for push notification handling
    }

    // Handle unsuccessful registration for remote notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \\(error.localizedDescription)")
    }

    

    // Handle receipt of remote notification while the app is in the background
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handle the received remote notification here

        // Print the notification payload
        print("Received remote notification: \\(userInfo)")

        // Process the notification content
        if let aps = userInfo["aps"] as? [String: Any], let alert = aps["alert"] as? String {
            // Extract information from the notification payload
            print("Notification message: \\(alert)")
        }

        // Indicate the result of the background fetch to the system
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    
    //=============================================== local push notification ===============================================
    // Handle notification when the app is in the foreground
    func requestAuthorizationForPushNotifications() {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
        (granted, error) in
            
            if granted {
                print("Notification authorization granted")
                // You can now schedule and send notifications
//                self.scheduleNotification()
                
            } else {
                print("Notification authorization denied")
                // Handle the case where the user denied notification permissions
            }
          
    
        }
    }
    
 
    
    
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: (settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
            
            switch settings.authorizationStatus {
               case .notDetermined:
                   self.requestAuthorizationForPushNotifications()
                
               case .authorized, .provisional:
//                   self.scheduleNotification()
                break
                
               default:
                   break // Do nothing
            }
            
        }
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      // Handle the notification presentation here
      completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let asd = response.notification.request.content.userInfo
            let id = response.notification.request.identifier
            print("Received notification with ID = \(id)")
            print(asd)
            completionHandler()
    }
    
    
    func scheduleNotification(msg:String) {
        let content = UNMutableNotificationContent()
        content.title = "Bạn có đơn hảng mới từ App Food "
        content.body = msg
        content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: "app_food_noti.caf"))
        

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: "foodAppNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
        
    }
    
}
