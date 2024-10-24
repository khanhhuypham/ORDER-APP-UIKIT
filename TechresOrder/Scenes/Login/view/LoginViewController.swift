//
//  LoginViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
import LocalAuthentication
import JonAlert

class LoginViewController: BaseViewController{
    
    var viewModel = LoginViewModel()
    var router = LoginRouter()

    // MARK: - IBOutlet -
    @IBOutlet weak var text_field_account: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var text_field_password: UITextField!
    @IBOutlet weak var btn_hide_password: UIButton!
    @IBOutlet weak var image_biometric: UIImageView!
    @IBOutlet weak var btn_forgot_password: UIButton!
    
    @IBOutlet weak var btn_faceid: UIButton!
    @IBOutlet weak var text_field_restaurant: UITextField!
    
    @IBOutlet weak var lbl_account_error: UILabel!
    
    @IBOutlet weak var lbl_error_pwd: UILabel!
    
    @IBOutlet weak var lbl_noti_restaurant: UILabel!
    
    @IBOutlet weak var view_faceid: UIView!
    
    @IBOutlet weak var viewDevMode: UIView!
    
   
    var iconClick = false
    var sessions_str = ""
    // MARK: - Variable - User -
    var context = LAContext()
    var err: NSError?


    override func viewDidLoad() {
        text_field_restaurant.text = ManageCacheObject.getRestaurantName()
        text_field_account.text = ManageCacheObject.getUsername()
        self.navigationController?.isNavigationBarHidden = true
        
        
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        
        var deviceRequest = DeviceRequest(appType: Utils.getAppType(), deviceUID:Utils.getUDID(), pushToken: "")
 
        viewModel.deviceRequest.accept(deviceRequest)

        self.registerDeviceUDID()
        
        self.hideKeyboardWhenTappedAround()

    
        mapDataAndValidate()
        // set layout
        checkBiometricFunctionality()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someActionDevMode(_:)))
        gesture.numberOfTapsRequired = 12
        viewDevMode.addGestureRecognizer(gesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reLogin(_:)), name: Notification.Name("changedPassword"), object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changedPassword"), object: nil)
    }
    
    @objc private func reLogin(_ notification:Notification){
        if let account = notification.object as? Account {
            text_field_restaurant.text = account.restaurant_name
            text_field_account.text = account.username
            text_field_password.text = account.password
            viewModel.username.accept(account.username)
            viewModel.password.accept(account.password)
            Utils.resetConfig()
            self.getSessions()
        }
    }
    
    @objc private func someActionDevMode(_ sender: UITapGestureRecognizer) {
        presentModalDevMode()
    }
    
    private func checkBiometricFunctionality(){
        self.iconClick = false
        view_faceid.isHidden = true
        
        if ManageCacheObject.getBiometric() == "1"{
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){

                if context.biometryType == .faceID{
                    if #available(iOS 13.0, *) {
                        view_faceid.isHidden = false
                        image_biometric.image = UIImage(named: "icon-face-id")
                    } else {
                        // Fallback on earlier versions
                    }
                }else{
                    if #available(iOS 13.0, *) {
                        image_biometric.image = UIImage(systemName: "touchid")
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }else{
//                UIAlertController.showAlert(title: nil, message: "Vân tay/Face ID chưa thiết lập")
            }
        }
    }
    
   

    @IBAction func actionLogin(_ sender: Any) {
//        if(self.isAllowPress){
//            self.isAllowPress = false
//            // call api login here...
//            self.viewModel.isLoginFace.accept(false)
//            self.getSessions()
//        }
        
        self.getSessions()

    }
    @IBAction func actionForgotPassword(_ sender: Any) {
        viewModel.makeResetPasswordViewController()
    }
    
    @IBAction func actionLoginBiometric(_ sender: Any) {
        
        let localString =  "Biometric Authentication"
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
            if ManageCacheObject.getUsername() == "" || ManageCacheObject.getPassword() == "" {
                let alert = UIAlertController(title: "THÔNG BÁO" , message: "Tính năng chỉ có thể sử dụng lần đăng nhập kế tiếp", preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString){ [self]
                    (success, error) in
                    if success{
                        DispatchQueue.main.async {
                            self.viewModel.isLoginFace.accept(true)
                            getSessions()
                        }
                    }
                }
            }

        }
    }
    
    
    @IBAction func actionShowPassword(_ sender: Any) {
        text_field_password.becomeFirstResponder()
        
        if(iconClick == true) {
            text_field_password.isSecureTextEntry = false
            btn_hide_password.setImage(UIImage(named: "eye"), for: .normal)
        } else {
            btn_hide_password.setImage(UIImage(named: "icon_eye_pass"), for: .normal)
            text_field_password.isSecureTextEntry = true
        }
       
        iconClick = !iconClick
    }
    
    @IBAction func actionRegisterAccount(_ sender: Any) {
          presentDialogRegisterAccountViewController()
    }
    

}
