//
//  SplitFood_RebuildViewController + Extension + API.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2023.
//

import UIKit
import ObjectMapper
import JonAlert
//MARK : CALL API
extension SplitFoodViewController{
    func getOrdersNeedMove(){
        viewModel.getOrdersNeedMove().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let orderDetailData = Mapper<OrderDetail>().map(JSONObject: response.data){
               
                    self.viewModel.dataArray.accept(orderDetailData.order_details)
                    self.view_no_data.isHidden = self.viewModel.dataArray.value.count > 0 ? true : false
                }
            }
        }).disposed(by: rxbag)
    }
    
    func moveFoods(){
        viewModel.moveFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.delegate?.callBackReload()
                self.dismiss(animated: true)
                JonAlert.showSuccess(message: "Tách món thành công.", duration: 2.0)
            }else{
                JonAlert.showError(message: "Bàn ở trạng thái setup, vui lòng không thao tác.", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    func moveExtraFoods(){
        viewModel.moveExtraFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
            
                self.delegate?.callBackReload()
                self.dismiss(animated: true)
                JonAlert.showSuccess(message: "Tách món thành công.", duration: 2.0)
                
                
            }else{
                JonAlert.showError(message: response.message ?? "Phụ thu không được chuyển sang bàn chưa có hóa đơn.", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    func moveFoodsAndExtraFoods(){
        viewModel.moveFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Move Success...")
                // khi tạo xong server trả về order_id là target_order_id khi gửi tách món
                if let splitFoodResponse = Mapper<SplitFoodResponse>().map(JSONObject: response.data) {
                    self.viewModel.target_order_id.accept(splitFoodResponse.order_id)
                    self.moveExtraFoods()
                }
            }else{
                JonAlert.showError(message: "Bàn ở trạng thái setup, vui lòng không thao tác.", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
}
