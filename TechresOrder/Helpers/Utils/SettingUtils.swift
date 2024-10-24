//
//  SettingUtils.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 12/03/2024.
//

import UIKit
import RxSwift
import ObjectMapper
import JonAlert
class SettingUtils {
    static private let rxbag = DisposeBag()
    static private var completion:(()->Void)? = nil
    static private var incompletion:(()->Void)? = nil
    static private var closureForFoodCourt:(()->Void)? = nil
    static private var closureChangePassword:(()->Void)? = nil
    
    
    static func getSetting(brandId:Int, branchId:Int, closureForFoodCourt:(()->Void)? = nil, closureChangePassword:(()->Void)? = nil, completion:(()->Void)? = nil, incompletion:(()->Void)? = nil){
        self.completion = completion
        self.incompletion = incompletion
        self.closureForFoodCourt = closureForFoodCourt
        self.closureChangePassword = closureChangePassword
        self.getEmployeeSetting(step: 1,branchId: branchId)
    }
    
    static func getBranchSetting(branchId:Int, completion:(()->Void)? = nil,incompletion:(()->Void)? = nil){
        self.completion = completion
        self.incompletion = incompletion
        getEmployeeSetting(step: 2, branchId: branchId)
    }
    
    
    static private func getBrands(id:Int) {
        return appServiceProvider.rx.request(.brands(key_search:"", status: ACTIVE))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self).take(1)
               .subscribe(onNext: {(response) in
                   
                   if(response.code == RRHTTPStatusCode.ok.rawValue){
                       if let brands = Mapper<Brand>().mapArray(JSONObject: response.data) {
                           
                                                    
                           if let brand = brands.filter{$0.is_office == DEACTIVE}.first(where:{$0.id == id}){
                                ManageCacheObject.saveCurrentBrand(brand)
                                self.getBrandSetting(brandId: brand.id)
                           }
                       }
                   }else{

                       JonAlert.showError(message: response.message ?? "", duration: 2.0)
                       (self.incompletion ?? {})()
                       
                   }
                
               }).disposed(by: rxbag)
       }
    
    
    
    
    static private func getBrandSetting(brandId:Int) {
        return appServiceProvider.rx.request(.getBrandSetting(brand_id: brandId))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)   
               .take(1)
               .subscribe(onNext: {(response) in
                   if let brandSetting = Mapper<Setting>().map(JSONObject: response.data) {
                       /*
                               note1:
                               ở API này ta dùng ManageCacheObject.setSetting để set setting.
                               vì các API restaurant-brands/${brand_id}/setting,/employees/settings, ${branch_id}/setting/is-apply-only-cash-amount không trả về cùng 1 model
                               
                               nên ta clone biến setting từ cache và thay đổi các trường giá trị của object setting ở những lần gọi API sau
                               example:
                                var setting = ManageCacheObject.getSetting()
                                setting.branch_info = employeeSetting.branch_info
                                setting.is_require_update_customer_slot_in_order = employeeSetting.is_require_update_customer_slot_in_order
                                setting.hour_to_take_report = employeeSetting.hour_to_take_report
                                setting.is_have_take_away = employeeSetting.is_have_take_away
                                setting.is_enable_membership_card = employeeSetting.is_enable_membership_card
                                setting.is_hide_total_amount_before_complete_bill = employeeSetting.is_hide_total_amount_before_complete_bill
                                ManageCacheObject.setSetting(setting)
                               
                               note2:
                               API getEmployeeSetting, từ GPBH_2 trở lên ta cần phải gọi API fetchBranch
                               để lấy chi nhánh đầu tiên không phải là chi nhánh văn phòng và gọi lại API employeeSetting của chỉ nhánh đó, nên mới chia thành 2 bước
                                (bước 1 & 2)
                           */
                       
                       var setting = ManageCacheObject.getSetting()
                       setting.template_bill_printer_type = brandSetting.template_bill_printer_type
                       setting.is_enable_buffet = brandSetting.is_enable_buffet
                       ManageCacheObject.setSetting(setting)
                   }
                   
                   
                   if let brandSetting = Mapper<BrandSetting>().map(JSONObject: response.data) {
                       var brand = Constants.brand
                       brand.setting = brandSetting
                       ManageCacheObject.saveCurrentBrand(brand)
                   }
                   
                   
                   
               }).disposed(by: rxbag)
    }
    
    
    static private func getEmployeeSetting(step:Int,branchId:Int){
        let innerCompletion:((Setting)->Void) = { setting in
       
            var branch = Branch()
            branch.id = setting.branch_info.id
            branch.name = setting.branch_info.name
            branch.phone = setting.branch_info.phone
            branch.address = setting.branch_info.address
            branch.image_logo = setting.branch_info.image_logo_url
            branch.banner = setting.branch_info.banner_image_url
            ManageCacheObject.saveCurrentBranch(branch)
       
   
            
            self.getPrinters(branchId: branchId)
            self.getPrivateBranchSetting(branchId: branchId)
            self.getBrandSetting(brandId: Constants.brand.id)

        }
        
         appServiceProvider.rx.request(.setting(branch_id: branchId))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
            .take(1)
            .subscribe(onNext: { (res) in
                if(res.code == RRHTTPStatusCode.ok.rawValue){
                    if var employeeSeting = Mapper<Setting>().map(JSONObject: res.data) {
                        
                        let setting = ManageCacheObject.getSetting()
                        employeeSeting.template_bill_printer_type = setting.template_bill_printer_type
                        ManageCacheObject.setSetting(employeeSeting)
                        
                        
                        if let closure = self.closureChangePassword{
                            closure()
                        }else{
                            switch step{
                                case 1:
                                    permissionUtils.GPBH_1 ? innerCompletion(employeeSeting) : self.fetBranches()

                                case 2:
                                    innerCompletion(employeeSeting)

                                default:
                                    break
                            }
                        }
                
                    }
                }else{
                    JonAlert.showError(message: res.message ?? "", duration: 2.0)
                    (self.incompletion ?? {})()
                }
               
            }).disposed(by: rxbag)
        
    }
    
    
    static private func fetBranches(){
        appServiceProvider.rx.request(.branches(brand_id: -1, status: 1))
           .filterSuccessfulStatusCodes()
           .mapJSON().asObservable()
           .showAPIErrorToast()
           .mapObject(type: APIResponse.self)
           .take(1)
           .subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                    if var branches = Mapper<Branch>().mapArray(JSONObject: response.data) {

                        branches = branches.filter{$0.is_office == DEACTIVE}
                        
                        if let branch = branches.first{
                            ManageCacheObject.saveCurrentBranch(branch)
                            getBrands(id: branch.restaurant_brand_id)
                            self.getEmployeeSetting(step:2,branchId: branch.id)
                        }else{
                            ManageCacheObject.saveCurrentPoint(NextPoint()!)
                            ManageCacheObject.saveCurrentBrand(Brand())
                            ManageCacheObject.saveCurrentBranch(Branch())
                            ManageCacheObject.setSetting(Setting()!)
                            ManageCacheObject.saveCurrentUser(Account())
                            ManageCacheObject.setConfig(Config()!)
                            JonAlert.showError(message: "Bạn không có quyền truy cập ứng dụng này!", duration: 2.0)
                        }
                    }
                }else{
                    JonAlert.showError(message: response.message ?? "", duration: 2.0)
                    (self.incompletion ?? {})()
                }
           }).disposed(by: rxbag)
    }
    
    
    static private func getPrinters(branchId:Int){
        appServiceProvider.rx.request(.kitchens(branch_id: branchId, status: ACTIVE))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
            .take(1)
            .subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                   if var printers = Mapper<Printer>().mapArray(JSONObject: response.data) {
                       if(printers.count > 0){
                  
//                           let receipt_printer = printers.filter{$0.type == .cashier ||  $0.type == .cashier_of_food_app}
//                           let stamp_printer = printers.filter{$0.type == .stamp || $0.type == .stamp_of_food_app }
//                           let chef_bar_printer = printers.filter{$0.type == .bar || $0.type == .chef}
                           
//                           if permissionUtils.GPBH_1 || permissionUtils.GPBH_2_o_1{
                               
//                               if Constants.foodAppPrinters.isEmpty{
//                                   var foodAppPrinter:[Printer] = []
//                                   foodAppPrinter.append(Printer(id:1, name:"Thu ngân Food App",printerName: "Food App's receipt printer",type:.cashier,isFoodAppPrinter: true))
//                                   foodAppPrinter.append(Printer(id:2, name: "Stamp Food App",printerName: "Food App's stamp printer",type:.stamp,paperSize: 30,isFoodAppPrinter: true))
//                                   ManageCacheObject.SaveAppFoodPrinter(foodAppPrinter, cache_key: KEY_FOOD_APP_PRINTER)
//                               }
//                                
//                           printers += Constants.foodAppPrinters
                           
//                           }
                           
                           ManageCacheObject.setPrinters(printers, cache_key: KEY_CHEF_BARS)
//                           ManageCacheObject.savePrinterBill(receipt_printer.first ?? Printer(), cache_key: KEY_PRINTER_BILL)
                           
                           LocalDataBaseUtils.savePrinters(printersArray: printers)
                       }
                   }
                }else{
                   dLog(response.message ?? "")
                }
            }).disposed(by: rxbag)
    }
    
    
    static private func getPrivateBranchSetting(branchId:Int) {
        appServiceProvider.rx.request(.getApplyOnlyCashAmount(branchId: branchId))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
               .take(1)
               .subscribe(onNext: { (response) in
                   if(response.code == RRHTTPStatusCode.ok.rawValue){
                       
                       
                       if let branchSetting = Mapper<BranchSetting>().map(JSONObject: response.data) {
                           //branch-setting
                           var branch = ManageCacheObject.getCurrentBranch()
                           branch.setting = branchSetting
                           ManageCacheObject.saveCurrentBranch(branch)
                       }
                       
                    
                       if let method = Mapper<PaymentMethod>().map(JSONObject: response.data){
                           //general-setting
                           var setting = ManageCacheObject.getSetting()
                           setting.is_show_vat_on_items_in_bill = method.is_show_vat_on_items_in_bill
                           setting.is_hidden_payment_detail_in_bill = method.is_hidden_payment_detail_in_bill
                           setting.vat_content_on_bill = method.vat_content_on_bill
                           setting.greeting_content_on_bill = method.greeting_content_on_bill
                           ManageCacheObject.setSetting(setting)
               
                           
                           //-----------------------------------------
                           ManageCacheObject.setPaymentMethod(method)
                           
                           if method.is_enable_food_court == ACTIVE {
                               if Utils.checkRoleCancelFoodCompleted(permission: ManageCacheObject.getCurrentUser().permissions) || permissionUtils.Owner{
                                   (self.completion ?? {})()
                               }else{
                                   (self.closureForFoodCourt ?? {})()
                               }
                           }else {
                               (self.completion ?? {})()
                           }
 
                       }
                   }else{
                       dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.")
                       (self.incompletion ?? {})()
                   }
               }).disposed(by: rxbag)
    }
    
}
