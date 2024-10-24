//
//  LoginViewController+Extension+API.swift
//  ORDER
//
//  Created by Pham Khanh Huy on 04/07/2023.
//

import UIKit
import JonAlert
import ObjectMapper
extension LoginViewController{

    func registerDeviceUDID(){
        // Get data from Server
        viewModel.registerDeviceUDID().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Register Device UDID Success...")
            }
         
        }).disposed(by: rxbag)
    }
    
    
    func getSessions(){
        viewModel.getSessions().subscribe(onNext: { (response) in
        
            if(response.code == RRHTTPStatusCode.ok.rawValue){
               
                self.sessions_str = response.data as! String
                self.getConfig()
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại")
            }
          
        }).disposed(by: rxbag)
    }
    
    func getConfig(){

        viewModel.getConfig().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let config = Mapper<Config>().map(JSONObject: response.data){
                    var obj_config = config
                    let basic_token = String(format: "%@:%@", self.sessions_str, obj_config.api_key)
                    obj_config.api_key = basic_token
                    ManageCacheObject.setConfig(obj_config)
                    // call api login here...
                    self.login()
                }
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", duration: 2.0)
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
        
    }
    
    
    func login(){
        // Get data from Server
        viewModel.login().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog(response.data)
                if let account = Mapper<Account>().map(JSONObject: response.data){
                    
                    if(!Utils.checkRoleOrderFood(permission: account.permissions)){
                        JonAlert.showError(message: "Bạn chưa có quyền gọi món. Vui lòng liên hệ quản lý để được cấp quyền.", duration: 3.0)
                        return
                    }
                
                    ManageCacheObject.saveCurrentUser(account)
                    ManageCacheObject.setAccessToken(account.access_token)
                    ManageCacheObject.setUsername(account.username)
                    ManageCacheObject.setPassword(self.text_field_password.text!)
                    ManageCacheObject.setRestaurantName(account.restaurant_name)
                    self.viewModel.branch_id.accept(account.branch_id)
                    
                    var brand = Brand.init()
                    brand.id = account.restaurant_brand_id
                    brand.name = account.brand_name
                    brand.restaurant_id = account.restaurant_id
                    ManageCacheObject.saveCurrentBrand(brand)

            
                    SettingUtils.getSetting(
                        brandId: account.restaurant_brand_id,
                        branchId: account.branch_id,
                        closureForFoodCourt: {
                            self.presentModalDialogConfirmViewController()
                        },
                        closureChangePassword: account.is_enable_change_password == DEACTIVE 
                        ? { self.presentDialogRequiredSetPassword(currentPassword: self.viewModel.password.value)}
                        : nil
                        ,
                        completion: {
                            self.loadMainView()
                            JonAlert.showSuccess(message: "Đăng nhập thành công", duration: 2.0)
                            FoodAppPrintUtils.shared.performPrintOrderForFoodAppOnBackground()
                            

                        },
                        incompletion:self.clearCache
                        
                    )
                    
                }

            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", duration: 2.0)
                dLog(response.message ?? "")

            }
        }).disposed(by: rxbag)
    }
    
    
   
    
}

