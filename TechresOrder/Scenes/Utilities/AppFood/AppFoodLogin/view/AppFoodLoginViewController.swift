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
    var token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiIxMjkyMzgwMTI3IiwicmVnaW9uIjoiVk4iLCJidXNpbmVzc0lkIjoxLCJ0b2tlbiI6IkI6ZWJJTW9yNVN1UFRIY2ZuVVB2dXY5ZlV1VnBGOUZXdThlWkQ2WEhFT1Z2Y2ZIdmZDdFFYLzV6REdldjk4eS8rSmpsaWluSWYvbVFZU1RVc0RJZWMxeUtsckRrcm1lUzdoRTlTLzAvNVNGSnc9IiwiZXJyb3JNc2ciOiIiLCJlcnJvckNvZGUiOjAsImlhdCI6MTcyNDkzODQ3NSwiZXhwIjoxODExMzM4NDc1fQ.VpOrcSwdF5h41Z_KoFK7Idy4C7E4TmCOOawS8C3eMw1CYepGF8Ucl3l4IgFX9jbxZWB0hj5kEnV8ujosca8Q_UypTB2nyA8KCMmvCxNY7SZJMm3li2VGwbsZQtCOZy7ALp9GRjdq1p2BTezR1rbRIz_AUe-2qLGZB6Kf9y_UlqA"
  
    var viewModel = AppFoodLoginViewModel()
    var router = AppFoodLoginRouter()
    var partner:FoodAppAPartner = FoodAppAPartner()
    
    
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
    
    let base64Encoded = "YW55IGNhcm5hbCBwbGVhc3VyZS4="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        dLog(decodeJWT(token))
       
        
        
        
        viewModel.bind(view: self, router: router)
   
        mapDataAndValidate()
        
        let p = self.partner

        viewModel.partner.accept(p)

        switch self.partner.code{
            
            case .shoppee:
                view_of_username.isHidden = true
                view_of_password.isHidden = true
                view_of_token.isHidden = false
                view_of_phone.isHidden = true

                if p.is_connect == DEACTIVE {
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

        if p.channel_order_food_token_id > 0{
            getDetailOfChannelOrderFoodToken(id: p.channel_order_food_token_id)
        }else{
            
            
            viewModel.credential.accept(
                PartnerCredential(
                    id: p.id,
                    restaurant_id: Constants.restaurant_id,
                    restaurant_brand_id: Constants.brand.id,
                    channel_order_food_id: p.channel_order_food_token_id,
                    access_token: "",
                    username: "",
                    password: ""
                )
            )
            
            if self.partner.code == .shoppee{
                WKWebView.clean()
                self.loadWebkit()
            }
            
        }
        
        connection_view.isHidden = p.is_connect == ACTIVE ? false : true
        btn_login.setTitle(p.is_connect == ACTIVE ? "Huỷ Kết nối" : "Kết nối", for: .normal)
        btn_login.tintColor = p.is_connect == ACTIVE ? ColorUtils.red_600() : ColorUtils.orange_brand_900()
        lbl_title.text = String(format: "KẾT NỐI VỚI %@", p.name.uppercased(with: .autoupdatingCurrent))
    }
    

    @IBAction func actionback(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionConnect(_ sender: UIButton) {
        
        sender.preventRepeatedPresses(inNext: 2)

        switch partner.code {
            case .gofood:
                partner.is_connect == DEACTIVE
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
        
        viewModel.getDetailOfChannelOrderFoodToken(id: id).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var cre = Mapper<PartnerCredential>().map(JSONObject: response.data){

                    if self.partner.is_connect == ACTIVE {
                        
                        switch self.partner.code {
                            
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
                        self.viewModel.credential.accept(cre)
                    }else{
                        cre.access_token = self.partner.code == .shoppee ? "" : cre.access_token
                        self.viewModel.credential.accept(cre)
                        WKWebView.clean()
                        self.loadWebkit()
                    }
                    

                }

            }else{
                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
        
    }
    

    
    
    private func createTokenOfChannelFoodOrder(credential:PartnerCredential) {
        viewModel.createTokenOfChannelFoodOrder(infor: credential).subscribe(onNext: { (response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let infor = Mapper<PartnerCredential>().map(JSONObject: response.data){
                    self.changeConnect(credential: infor)
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
                    self.changeConnect(credential: infor)
                }
                
            }else{
        
                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    private func changeConnect(credential:PartnerCredential){
        viewModel.changeConnect(infor: credential).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                self.showSuccessMessage(content: self.partner.is_connect == DEACTIVE ? "Kết nối thành công" : "ngắt kết nối thành công")
                
                let p = self.viewModel.partner.value
                if p.code == .shoppee && p.is_connect == DEACTIVE{
                    WKWebView.clean()
                }

                self.actionback("")
            }else{
                
                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    func connectionToggle(){
    
        var cre = viewModel.credential.value
        
        if partner.code == .gofood {
            cre.username = cre.phoneNumber ?? ""
        }
        
        
        if self.partner.channel_order_food_token_id == 0{
            createTokenOfChannelFoodOrder(credential: cre)
        }else{
            self.partner.is_connect == DEACTIVE
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
    
    
    
  

   
    
  
}
