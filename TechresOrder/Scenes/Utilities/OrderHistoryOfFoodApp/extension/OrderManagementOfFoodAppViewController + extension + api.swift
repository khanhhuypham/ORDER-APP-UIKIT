//
//  OrderManagementOfFoodAppViewController + extension + api.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/08/2024.
//

import UIKit
import RxSwift
import RxRelay
import ObjectMapper
extension OrderManagementOfFoodAppViewController {
    
    
    func getOrderHistoryOfFoodApp(){
        
        
        appServiceProvider.rx.request(.getOrderHistoryOfFoodApp(
            restaurant_id: Constants.restaurant_id,
            restaurant_brand_id: Constants.brand.id,
            branch_id: Constants.branch.id,
            food_channel_id: viewModel.history.value.partnerId,
            report_type: viewModel.history.value.reportType,
            date_string: viewModel.history.value.dateString
        ))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { (response) in
        
            if let history = Mapper<OrderHistoryOfFoodApp>().map(JSONObject: response.data){
                self.viewModel.history.accept(history)
                self.lbl_total_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: history.total_revenue)
                self.lbl_GRF_total_revenue.text = String(format: "GrabFood: %@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: history.total_revenue_GRF))
                self.lbl_SHF_total_revenue.text = String(format: "SPFood: %@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: history.total_revenue_SHF))
                self.lbl_GOF_total_revenue.text = String(format: "GojekFood: %@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: history.total_revenue_GOF))
                self.lbl_BEF_total_revenue.text = String(format: "BeFood: %@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: history.total_revenue_BEF))
                self.lbl_total_complete.text = String(history.total_order_completed)
                self.lbl_total_cancel.text = String(history.total_order_cancelled)

                self.view_no_data.isHidden = !history.list.isEmpty
            }
            
        }).disposed(by: rxbag)
    }
}
