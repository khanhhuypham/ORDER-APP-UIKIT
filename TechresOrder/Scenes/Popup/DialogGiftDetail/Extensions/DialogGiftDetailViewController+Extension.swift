//
//  DialogGiftDetailViewController+Extension.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 09/03/2023.
//

import UIKit
import ObjectMapper
import JonAlert
extension DialogGiftDetailViewController{
    func gift(){
        viewModel.getGift().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("get gift detail Success...")
                if let giftDetail  = Mapper<GiftDetail>().map(JSONObject: response.data){
                    self.viewModel.customer_id.accept(giftDetail.customer_id)
                    self.viewModel.customer_gift_id.accept(giftDetail.id)
                    
                    self.lbl_customer_name.text = giftDetail.customer_name
                    self.lbl_gift_name.text = giftDetail.name
                    self.lbl_gift_exp.text = giftDetail.expire_at
                    self.lbl_gift_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(giftDetail.restaurant_gift_object_value))
                    self.lbl_customer_phone.text = giftDetail.customer_phone
                    self.lbl_gift_quantity.text = String(format: "%d", giftDetail.restaurant_gift_object_quantity)
                    
                    //ẨN CÁC NÚT CHỨC NĂNG ĐI NẾU QUÀ TẶNG ĐÃ ĐƯỢC SỬ DỤNG
                    Utils.isHideAllView(isHide: giftDetail.is_used == ACTIVE, view: self.view_action)
                    
                }
            
                dLog(response)
            }else{
//                Toast.show(message: response.message ?? "Qúa trình kết nối máy chủ gặp sự cố vui lòng thử lại sau.", controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message)
            }
        }).disposed(by: rxbag)
        
    }
    
    func useGift(){
        viewModel.useGift().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("use gift  Success...")
                Toast.show(message: "Thêm quà tặng vào đơn hàng thành công...", controller: self)
                self.delegate?.callBackUsedGift(order_id: self.order_id)
                self.viewModel.makePopViewController()
                dLog(response)
            }else{
//                Toast.show(message: response.message ?? "Qúa trình kết nối máy chủ gặp sự cố vui lòng thử lại sau.", controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message)
            }
        }).disposed(by: rxbag)
        
    }
    
}
