//
//  BaseViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
import AVFoundation
import JonAlert
class BaseViewController: UIViewController {
    var viewModels = BaseViewModel()
    var window: UIWindow?
//    var mySceneDelegate: RestartApp?
 
 
    
    let rxbag = DisposeBag()
    var working_session = 0
    
    weak var timer: Timer?
    weak var timerForPrinter: Timer?
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    
    override open func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = ColorUtils.white()
                
        setNeedsStatusBarAppearanceUpdate()
        
        modalPresentationStyle = .fullScreen
        
        view.tintAdjustmentMode = .normal
    
        self.navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(self,selector:#selector(sceneChange(_:)),name:NSNotification.Name("SCENE_CHANGE"),object: nil)
    }
    

    

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
   
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            self!.viewModels.isMessageShowing.accept(false)
        }
        setUpPrinterTimer()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
        timerForPrinter?.invalidate()
        timerForPrinter = nil
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.shared().socketRealTimeOfLogin?.disconnect()
    }
    
//    func navigatorToRootViewController(){
//        let viewController = CustomTabBarController()
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
   
    

    // MARK: - Memory Release -
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Memory Release : \(String(describing: self))\n" )
    }
    
    
    
    func showSuccessMessage(content:String){
        if(!viewModels.isMessageShowing.value){
            JonAlert.show(message: content ,
                          andIcon: UIImage(named: "icon-check-success"),
                          duration: 2.0)
            viewModels.isMessageShowing.accept(true)
        }
        
    }

    
    func showWarningMessage(content:String){
        if(!viewModels.isMessageShowing.value){
            JonAlert.show(message: content ,
                          andIcon: UIImage(named: "icon-warning"),
                          duration: 2.0)
            viewModels.isMessageShowing.accept(true)
        }
    }
    
    
    func showErrorMessage(content:String){
        if(!viewModels.isMessageShowing.value){
            JonAlert.showError(message: content, duration: 2.0)
            viewModels.isMessageShowing.accept(true)
        }
        
    }
    
    
}
extension BaseViewController{
    

    
    func getCurrentPoint(employee_id:Int){
        viewModels.getCurrentPoint(employee_id: employee_id).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let currentPoint = Mapper<NextPoint>().map(JSONObject: response.data) {
                    ManageCacheObject.saveCurrentPoint(currentPoint)
                }
            }else if(response.code == RRHTTPStatusCode.unauthorized.rawValue || response.code == RRHTTPStatusCode.forbidden.rawValue){
                dLog(response.message ?? "")
                let loginViewController = LoginRouter().viewController
                self.navigationController?.pushViewController(loginViewController, animated: true)
                
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    
    
    func getLastLoginDevice(){
        viewModels.getLastLoginDevice().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let config = Mapper<KickOutAccountModel>().map(JSONObject: response.data){
                       
                        self.presentDialogKickouts(
                            deviceName:config.device_name,
                            deviceIdString:config.device_uid,
                            LoginAt:config.login_at,
                            ipAddress:config.ip_address)
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    
 
}


extension BaseViewController{
    
    
    func loadMainView() {
        
        let tabbarViewController = TabbarViewController()
//        let viewController = CustomTabBarController()
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(tabbarViewController)
        
   }
    func clearCache(){
        ManageCacheObject.saveCurrentPoint(NextPoint()!)
        ManageCacheObject.saveCurrentBrand(Brand())
        ManageCacheObject.saveCurrentBranch(Branch())
        ManageCacheObject.setSetting(Setting()!)
        ManageCacheObject.saveCurrentUser(Account())
        ManageCacheObject.setConfig(Config()!)
        FoodAppPrintUtils.shared.stopPrintOrderForFoodAppOnBackground()
    }
        
    func logout(){
        
        clearCache()
        let loginViewController = LoginRouter().viewController
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginViewController)
        
    }

    func restart(){

        
        // iOS13 or later
        if #available(iOS 13.0, *) {
            let App = UIApplication.shared.delegate as? AppDelegate
            self.navigationController!.setViewControllers([SplashScreenViewController()], animated: true)
            App?.window?.rootViewController = navigationController
        }
        
    }
    
    func getWindow() -> UIWindow? {
       return UIApplication.shared.keyWindow
   }
    
    
    private func setupSocketIOForKickOutAccount() {
        
        SocketIOManager.shared().initSocketInstanceOfLogin()
        SocketIOManager.shared().socketRealTimeOfLogin?.on("connect") {data, ack in
            SocketIOManager.shared().socketRealTimeOfLogin!.on(String(format: "kick-out.order-%@",Utils.getUDID())) {data, ack in
            
                if let config = Mapper<KickOutAccountModel>().mapArray(JSONObject: data){

                            self.presentDialogKickouts(
                                deviceName:config.first?.device_name ?? "",
                                deviceIdString:config.first?.device_uid ?? "",
                                LoginAt:config.first?.login_at ?? "",
                                ipAddress:config.first?.ip_address ?? "")
                }
               
            }
        }
        SocketIOManager.shared().socketRealTimeOfLogin?.connect()
        // == End socket io
    }
    
    
    @objc func screenDidUnlock() {
        getLastLoginDevice()
    }

    
}

