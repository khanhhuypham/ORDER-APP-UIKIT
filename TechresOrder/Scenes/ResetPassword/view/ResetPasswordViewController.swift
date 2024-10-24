//
//  ResetPasswordViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 30/01/2023.
//

import UIKit
import ObjectMapper
import JonAlert
import RxSwift

class ResetPasswordViewController: BaseViewController {
    
    var viewModel = ResetPasswordViewModel()
    var router = ResetPasswordRouter()
    
    // MARK: - IBOutlet -
    @IBOutlet fileprivate weak var text_field_restaurant_name: UITextField!
    @IBOutlet fileprivate weak var btn_submit: UIButton!
    @IBOutlet fileprivate weak var text_field_username: UITextField!

    @IBOutlet weak var lbl_noti_restaurant_name: UILabel!
    
    @IBOutlet weak var lbl_noti_username: UILabel!
    
    @IBOutlet fileprivate weak var btn_back: UIButton!
    
    var sessions_str = ""
    var isCheckSpam = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_noti_restaurant_name.isHidden = true
        lbl_noti_username.isHidden = true
        
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        //bind value of textfield to variable of viewmodel
        _ = text_field_restaurant_name.rx.text.map { $0 ?? "" }.bind(to: viewModel.restaurantNameText)
        _ = text_field_username.rx.text.map { $0 ?? "" }.bind(to: viewModel.usernameText)
        
        
        //  subscribe result of variable isValid in LoginViewModel then handle button login is enable or not?
        _ = viewModel.isValid.subscribe({ [weak self] isValid in
            dLog(isValid)
            guard let strongSelf = self, let isValid = isValid.element else { return }
            strongSelf.btn_submit.isEnabled = isValid
            strongSelf.btn_submit.backgroundColor = isValid ? ColorUtils.orange_brand_900() :ColorUtils.buttonGrayColor()
            
        })
        
        _ = viewModel.isValidRestaurantName.subscribe({ [weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else { return }
            if(!self!.text_field_restaurant_name.text!.isEmpty){
                if isValid{
                    strongSelf.lbl_noti_restaurant_name.isHidden = true
                }else{
                    strongSelf.lbl_noti_restaurant_name.isHidden = false
                }
            }

        })
        
        
        _ = viewModel.isValidUsername.subscribe({ [weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else { return }
            
            if(!self!.text_field_username.text!.isEmpty){
                if isValid{
    //                self!.phone_password.constant = 10
                    strongSelf.lbl_noti_username.isHidden = true
                    
                }else{
    //                self!.phone_password.constant = 30
                    strongSelf.lbl_noti_username.isHidden = false
                }
            }
          

        })
        
        btn_back.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        
        btn_submit.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                          // call api here...
                           if( self?.isCheckSpam == false){
                               self?.getSessions()
                           }
                       }).disposed(by: rxbag)
        
        
    }


}
extension ResetPasswordViewController{
    
    func getSessions(){
        viewModel.getSessions().subscribe(onNext: { (response) in
          
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog(response)
                self.sessions_str = response.data as! String
                self.getConfig()
            }else{
                if self.isCheckSpam == true { return }
                self.isCheckSpam = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
                    self.isCheckSpam = false
                }
                JonAlert.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", andIcon: UIImage(named: "icon-warning"), duration: 2.0)
            }
          
          
        }).disposed(by: rxbag)
        
    }
    
    func getConfig(){
        viewModel.getConfig().subscribe(onNext: { (response) in
            dLog(response.toJSON())
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let config  = Mapper<Config>().map(JSONObject: response.data){
                    dLog(config)
                    
                    var obj_config = config
                    let basic_token = String(format: "%@:%@", self.sessions_str, obj_config.api_key)
                    obj_config.api_key = basic_token
                    ManageCacheObject.setConfig(obj_config)
                    
                    // call api forgot password here...
                    self.forgotPassword()
                }
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
//                Toast.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", controller: self)
                dLog(response.message ?? "")
            }
          
          
        }).disposed(by: rxbag)
        
    }
    
    func forgotPassword(){
            viewModel.forgotPassword().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    self.viewModel.makeNavigatorVerifyOTPViewController()
                }else{
                    if self.isCheckSpam == true { return }
                    self.isCheckSpam = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
                        self.isCheckSpam = false
                    }
                    JonAlert.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", andIcon: UIImage(named: "icon-warning"), duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }
}
