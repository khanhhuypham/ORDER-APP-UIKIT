//
//  AppFoodLoginViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/07/2024.
//

import UIKit
import RxSwift
import ObjectMapper
import WebKit
class AppFoodLoginViewController: BaseViewController,WKUIDelegate {

    var viewModel = AppFoodLoginViewModel()
    var router = AppFoodLoginRouter()
    var cre:PartnerCredential = PartnerCredential()
    
    
    @IBOutlet weak var stack_view: UIStackView!
    @IBOutlet weak var connection_view: UIView!
    
    @IBOutlet weak var lbl_title: UILabel!

    
    @IBOutlet weak var view_of_phone: UIView!
    @IBOutlet weak var text_field_phone: UITextField!
    
    @IBOutlet weak var view_of_token: UIView!
    @IBOutlet weak var text_field_token: UITextField!
    
    
    @IBOutlet weak var view_of_username: UIView!
    @IBOutlet weak var text_field_username: UITextField!
    @IBOutlet weak var lbl_error_of_username: UILabel!
    
    @IBOutlet weak var view_of_password: UIView!
    @IBOutlet weak var text_field_password: UITextField!
    @IBOutlet weak var lbl_error_of_password: UILabel!
    
    
    @IBOutlet weak var btn_show_pwd: UIButton!
    
    @IBOutlet weak var btn_login: UIButton!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        viewModel.bind(view: self, router: router)

        mapDataAndValidate()

        viewModel.credential.accept(cre)
      
        
        let credential = viewModel.credential.value

        switch credential.partnerType{
            
            case .shoppee:
                view_of_username.isHidden = true
                view_of_password.isHidden = true
                view_of_token.isHidden = false
                view_of_phone.isHidden = true

                if credential.is_connection == DEACTIVE {
                    stack_view.isHidden = true
                    webView.isHidden = false
                }else{
                    webView.isHidden = true
                    stack_view.isHidden = false
                }
            

            case .gofood:
                stack_view.isHidden = false
                view_of_username.isHidden = true
                view_of_password.isHidden = true
                view_of_token.isHidden = true
                view_of_phone.isHidden = false
                webView.isHidden = true

            default:
                stack_view.isHidden = false
                view_of_username.isHidden = false
                view_of_password.isHidden = false
                view_of_token.isHidden = true
                view_of_phone.isHidden = true
                webView.isHidden = true
        }

        if credential.id > 0{
            getDetailOfChannelOrderFoodToken(id: credential.id)
        }else{
            
//            viewModel.credential.accept(
//                PartnerCredential(
//                    id: p.id,
//                    restaurant_id: Constants.restaurant_id,
//                    restaurant_brand_id: Constants.brand.id,
//                    channel_order_food_id: p.channel_order_food_token_id,
//                    access_token: "",
//                    username: "",
//                    password: ""
//                )
//            )
            
            if credential.partnerType == .shoppee{
                WKWebView.clean()
                self.loadWebkit()
            }
            
        }
        
        connection_view.isHidden = credential.is_connection == ACTIVE ? false : true
        btn_login.setTitle(credential.is_connection == ACTIVE ? "Huỷ Kết nối" : "Kết nối", for: .normal)
        btn_login.tintColor = credential.is_connection == ACTIVE ? ColorUtils.red_600() : ColorUtils.orange_brand_900()
        lbl_title.text = String(format: "KẾT NỐI VỚI %@", (credential.name ?? "").uppercased(with: .autoupdatingCurrent))
    }
    

    @IBAction func actionback(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionConnect(_ sender: UIButton) {
        let credential = viewModel.credential.value

        sender.preventRepeatedPresses(inNext: 2)

        switch credential.partnerType {
            case .gofood:
                credential.is_connection == DEACTIVE
                ? sendRequestLoginToGoFood(phoneNumber: text_field_phone.text ?? "")
                : connectionToggle()
               
            default:
                connectionToggle()
                break
        }
        
    }
    
    
    @IBAction func toggleConfirmPasswordVisibility(_ sender: UIButton) {
        togglePasswordVisibility(text_field_password, button: sender)
    }
    
    func togglePasswordVisibility(_ textField: UITextField, button: UIButton){
        textField.isSecureTextEntry.toggle()
        button.setImage(UIImage(named: textField.isSecureTextEntry ? "icon_eye_pass" : "eye"), for: .normal)
    }
    
}



extension AppFoodLoginViewController{
    func getDetailOfChannelOrderFoodToken(id:Int){
        
        var cre = viewModel.credential.value
        
        if cre.is_connection == ACTIVE {
            
            switch cre.partnerType {
                
                case .shoppee:
                    self.text_field_token.insertText(cre.access_token)
                    self.text_field_token.isEnabled = false
                    cre.x_merchant_token = cre.access_token
                    
                case .gofood:
                    cre.phoneNumber = cre.username
                    self.text_field_phone.insertText(cre.phoneNumber ?? "")
                    self.text_field_phone.isEnabled = false
                  
                
                default:
                    self.text_field_username.insertText(cre.username)
                    self.text_field_password.insertText(cre.password)
                    self.text_field_username.isEnabled = false
                    self.text_field_password.isEnabled = false

            }

        }else{
//            cre.access_token = cre.partnerType == .shoppee ? "" : cre.access_token
            
            switch cre.partnerType{
                case .shoppee:
                    cre.access_token = ""
                    WKWebView.clean()
                    self.loadWebkit()
                    
                default:
                    cre.username = ""
                    cre.password = ""
            }
          
        }
        
        self.viewModel.credential.accept(cre)
    }
    

    
    
    private func createTokenOfChannelFoodOrder(credential:PartnerCredential) {
        viewModel.createTokenOfChannelFoodOrder(infor: credential).subscribe(onNext: { (response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var infor = Mapper<PartnerCredential>().map(JSONObject: response.data){
                    
//                    infor.partnerType = self.viewModel.credential.value.partnerType
//                    self.changeConnect(credential: self.viewModel.credential.value)
                    
                    self.showSuccessMessage(content: "Kết nối thành công")
                    
                    self.actionback("")
                }
     
            }else{
                self.showErrorMessage(content: response.message ?? "")
            }
            
        }).disposed(by: rxbag)
        
    }
    
    
    private func updateTokenOfChannelFoodOrder(credential:PartnerCredential){
        viewModel.updateTokenOfChannelFoodOrder(infor: credential).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                if let infor = Mapper<PartnerCredential>().map(JSONObject: response.data){
                    
                    self.changeConnect(credential: self.viewModel.credential.value)
                }
                
            }else{
        
                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    private func changeConnect(credential:PartnerCredential){
        viewModel.changeConnect(infor: credential).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
               
                let credential = self.viewModel.credential.value
                
                if credential.partnerType == .shoppee && credential.is_connection == DEACTIVE{
                    WKWebView.clean()
                }
                
                self.showSuccessMessage(content: credential.is_connection == DEACTIVE ? "Kết nối thành công" : "ngắt kết nối thành công")
                
                self.actionback("")
            }else{
                
                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    func connectionToggle(){
    
        var cre = viewModel.credential.value
        
        if cre.partnerType == .gofood {
            cre.username = cre.phoneNumber ?? ""
        }
        
              
        if cre.id == 0{
            createTokenOfChannelFoodOrder(credential: cre)
        }else{
            cre.is_connection == DEACTIVE
            ? updateTokenOfChannelFoodOrder(credential: cre)
            : changeConnect(credential: cre)
        }
    }
        
    
}



extension AppFoodLoginViewController{
    private func sendRequestLoginToGoFood(phoneNumber:String){
        
        appServiceProvider.rx.request(.postGoFoodLoginRequest(phoneNumber: phoneNumber)).mapJSON().asObservable().subscribe(onNext:{(response) in
            
            if let res = Mapper<GoFoodAPIResponse>().map(JSON:response as! [String : Any]){
                
                if res.success{
                    self.presentModalOTP(otpToken: res.data["otp_token"] as? String ?? "")
                }else if let error = res.errors.first{
                    self.showErrorMessage(content: error["message"] as? String ?? "")
                }
            }
        }).disposed(by: rxbag)
    }
    
    
    
    func getUserInforOfShopee(token:String){
        
        appServiceProvider.rx.request(.getUserInforOfShopee(token: token)).mapJSON().asObservable().subscribe(onNext:{(response) in
            
            if let res = Mapper<ShopeeFoodAPIResponse>().map(JSON:response as! [String : Any]){
                
            
                if ((res.error_msg?.isEmpty) != nil){


                    var cre = self.viewModel.credential.value
                    
                    cre.access_token = token
                    
                    if cre.partnerType == .shoppee{
                        cre.x_merchant_token = token
                        cre.username = res.data["phone"] as? String ?? ""
                    }

                    dLog(cre.toJSON())
                    self.viewModel.credential.accept(cre)
                    
                    
                    self.connectionToggle()
                  

                }else {
                    self.showErrorMessage(content: res.error_msg ?? "")
                }
            }
        }).disposed(by: rxbag)
    }
  

   
    
  
}
