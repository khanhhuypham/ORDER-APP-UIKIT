//
//  VerifyOTPViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 24/02/2023.
//

import UIKit
import RxSwift
import JonAlert
import ObjectMapper
extension VerifyOTPViewController {
    func verifyCode() {
        viewModel.verifyOTP().subscribe(onNext:{[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                viewModel.makeVerifyPasswordViewController()
            }else{
                
                OTP_text_field_view.initializeUI()
                OTP_text_field_view.isUserInteractionEnabled = false
                errorCounter -= 1
                var timeToUnEnableOPTEnterView = viewModel.timeToLockOPTEnterView.value
                timeToUnEnableOPTEnterView += 3*(5 - errorCounter)
                
                viewModel.timeToLockOPTEnterView.accept(timeToUnEnableOPTEnterView)
                if(errorCounter > 0 ){
                    JonAlert.show(message: String(format: "Bạn còn %d lần nhập OTP", errorCounter), andIcon: UIImage(named: "icon-warning"), duration: 2.0)
                }else if(self.OTPCountDown == 0){
                    JonAlert.show(message: response.message ?? "", andIcon: UIImage(named: "icon-warning"), duration: 2.0)
                    viewModel.timeToLockOPTEnterView.accept(0)
                }else{
                    JonAlert.show(message: "Bạn đã gửi quá nhiều lần vui lòng Chọn gửi lại OTP", andIcon: UIImage(named: "icon-warning"), duration: 2.0)
                    viewModel.timeToLockOPTEnterView.accept(0)
                }
                
                
            }
        }).disposed(by: rxbag)
    }
    
    
    
    func getSession(){
        viewModel.getSessions().subscribe(onNext: {[weak self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self!.viewModel.sessionString.accept(response.data as! String)
                self!.getConfig()
            }else{
                JonAlert.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", andIcon: UIImage(named: "icon-warning"), duration: 2.0)
            }
            
        }).disposed(by: rxbag)
    }
    
    
    func getConfig(){
        viewModel.getConfig().subscribe(onNext: {[weak self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let config = Mapper<Config>().map(JSONObject: response.data){
                    var obj_config = config
                    let basic_token = String(format: "%@:%@", self!.viewModel.sessionString.value, obj_config.api_key)
                    obj_config.api_key = basic_token
                    ManageCacheObject.setConfig(obj_config)
                    self!.errorCounter = 5
                    self!.forgotPassword()
                }
            }else {
                JonAlert.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", andIcon: UIImage(named: "icon-warning"), duration: 2.0)
            }
            
        }).disposed(by: rxbag)
    }
    
    
    
    func forgotPassword(){
        viewModel.forgotPassword().subscribe(onNext: {[self] (response) in
            if (response.code == RRHTTPStatusCode.ok.rawValue){
                setOTPCountDown()
                self.isCheckSpam = false
            }else {
                JonAlert.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", andIcon: UIImage(named: "icon-warning"), duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
}
