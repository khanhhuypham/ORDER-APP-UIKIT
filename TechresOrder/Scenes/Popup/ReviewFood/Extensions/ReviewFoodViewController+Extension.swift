//
//  ReviewFoodViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 22/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert
//MARK: -- CALL API
extension ReviewFoodViewController {
    func getFoodsNeedReview(){
        viewModel.getFoodsNeedReview().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let reviews = Mapper<OrderItem>().mapArray(JSONObject: response.data) {
                    if(reviews.count > 0){
                       
                        self.viewModel.dataArray.accept(reviews)
                        Utils.isHideAllView(isHide: true, view: self.view_nodata)
                    }else{
                        self.viewModel.dataArray.accept([])
                        Utils.isHideAllView(isHide: false, view: self.view_nodata)
                    }
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    func reviewFood(reViewData:[Review]){
        viewModel.reviewFood(reviewData: reViewData).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
               
                self.dismiss(animated: true, completion: {
                    JonAlert.showSuccess(message: "Đánh giá món ăn thành công...", duration: 2.0)
                    self.delegate?.callBackReload()
                })
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình đánh giá món ăn", duration: 3.0)
            }
         
        }).disposed(by: rxbag)
    }
    
}
