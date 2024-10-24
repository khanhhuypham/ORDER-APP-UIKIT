//
//  OrderRebuildViewController + extension + API.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/01/2024.
//

import UIKit
import RxSwift
import ObjectMapper
import JonAlert
extension OrderRebuildViewController{
    
    func fetchOrders(){
        viewModel.getOrders().subscribe(onNext: { [self] (response) in  
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let data = Mapper<Order>().mapArray(JSONObject: response.data) {
                    viewModel.dataArray.accept(data)
                    viewModel.fullDataArray.accept(data)
                    view_no_data.isHidden = data.count > 0 ? true : false
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }

    func updateCustomerNumberSlot(order:Order){
        viewModel.updateCustomerNumberSlot(order: order).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("update customer number slote Success...")
                self.fetchOrders()
            }
        }).disposed(by: rxbag)
    }
    
 

    func assignCustomerToBill(orderId:Int,qrValue:String){
        viewModel.assignCustomerToBill(orderId:orderId,qrValue: qrValue).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                self.viewModel.makeOrderDetailViewController()
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình giao tiếp với hệ thống. Vui lòng thử lại sau. ",duration: 2.0)

            }
        }).disposed(by: rxbag)
    }
        
    func closeTable(order:Order){
        viewModel.closeTable(order:order).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Đóng bàn thành công!",duration: 2.0)
                self.fetchOrders()
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình giao tiếp với hệ thống. Vui lòng thử lại sau. ",duration: 2.0)
            }
         
        }).disposed(by: rxbag)
    }

    func checkVersion(){
        viewModel.checkVersion().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                let _version  = Mapper<VersionModel>().map(JSON: response.data as! [String : Any])
                
                let isEqual = (Utils.version() == _version?.version)
                if !isEqual {
                    
                    if(_version!.is_require_update == ACTIVE){
                       //show dialog update version
                        self.presentModalDialogUpdateVersionViewController(is_require_update: (_version?.is_require_update)!, content: (_version?.message)!)
                    }
                }
                
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
            }
         
        }).disposed(by: rxbag)
    }
    
    func clearDataAndCallApi(){
        viewModel.dataArray.accept([])
        fetchOrders()
    }
    
    
    
}
