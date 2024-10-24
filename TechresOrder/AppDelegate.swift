//
//  AppDelegate.swift
//  TechresOrder
//
//  Created by kelvin on 18/12/2021.
//

import UIKit
import BackgroundTasks
import Wormholy
import os

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?
    var navigationController:UINavigationController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
//        SocketChatIOManager.shared.initSocketChatInstance()
//        SocketChatIOManager.shared.establishConnection()
        
        performBackgroundTask()
        NotificationService.shared.requestAuthorizationForPushNotifications()
        Wormholy.shakeEnabled = ManageCacheObject.isDevMode()
        Wormholy.limit = 10
        
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = UINavigationController(rootViewController: SplashScreenViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        registerBGTask()
        return true
    }
    

    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }


    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        NotificationCenter.default.post(name: NSNotification.Name("SCENE_CHANGE"),object: UIApplication.State.active)
        performBackgroundTask()
        
        
    }
    
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        NotificationCenter.default.post(name: NSNotification.Name("SCENE_CHANGE"),object: UIApplication.State.background)
        stopBackgroundTask()
    
//        schedule()
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        SocketIOManager.shared().establishConnection()
        
        
        
    }

    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        navigationController?.setViewControllers([vc], animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    
    
    
    private func performBackgroundTask(){
        
       if ManageCacheObject.isLogin(){
            SocketIOManager.shared().establishConnection()
            LocalDataBaseUtils.removeAllQueuedItem()
            PrinterUtils.shared.clearWorkItemUnderBackGround()
            PrinterUtils.shared.getBLEDevice()
            PrinterUtils.shared.performPrintBackGround()
            FoodAppPrintUtils.shared.performPrintOrderForFoodAppOnBackground()
        }
        
    }
    
    private func stopBackgroundTask(){
        LocalDataBaseUtils.removeAllQueuedItem()
        PrinterUtils.shared.clearWorkItemUnderBackGround()
        FoodAppPrintUtils.shared.stopPrintOrderForFoodAppOnBackground()
        SocketIOManager.shared().closeConnection()
    }
    
    
}




//MARK: ===============================================  register background task ===============================================
extension AppDelegate{
    
    private func registerBGTask(){
//        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        //  Register handler for task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "BACKGROUNDTASK",using: nil) { task in
            //  Handle the task when its run
            guard let task = task as? BGProcessingTask else {return}
            self.handleTask(task: task)
        }

    }
    
    private func handleTask(task:BGProcessingTask){
   
        PrinterUtils.shared.workItems.removeAll()
        PrinterUtils.shared.performPrintBackGround()
        
        task.expirationHandler = {
            //Cancel network call
            //submit a task to be scheduled
            let count = UserDefaults.standard.integer(forKey: "task_run_count")
            print("Task run \(count) times!")
        }
        
        task.setTaskCompleted(success: true)
        
        schedule()
    }
    
    private func schedule(){

        let request = BGProcessingTaskRequest(identifier: "BACKGROUNDTASK")
        request.requiresNetworkConnectivity = true // Need to true if your task need to network process. Defaults to false.
        request.requiresExternalPower = true // Need to true if your task requires a device connected to power source. Defaults to false.
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1) // Process after 5 minutes.
        do {
           try BGTaskScheduler.shared.submit(request)
        } catch {
           print("Could not schedule image fetch: (error)")
        }

    }
    
}




//
////===============================================  MARK: register push notification ===============================================
//extension AppDelegate:UNUserNotificationCenterDelegate{
//
//   
//    
//    
//}
//
// 
