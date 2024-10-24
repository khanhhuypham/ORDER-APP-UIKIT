//
//  OrderHistoryViewController + extension + api.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/12/2023.
//

import UIKit
import ObjectMapper
extension OrderHistoryViewController {
    func getOrderHistory(){
        
        viewModel.getActivityLog().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let dataFromServer = Mapper<ActivityLogResponse>().map(JSONObject: response.data) {
                    let data = dataFromServer.data
                    
                    
                    var p = self.viewModel.pagination.value

                    if(data.count > 0 && !p.isGetFullData){
                        var dataArray = self.viewModel.dataArray.value
                        dataArray.append(contentsOf: data)
                        self.viewModel.dataArray.accept(dataArray)
                    }
                    
                    p.isGetFullData = data.count < p.limit ? true: false
                    p.isAPICalling = false
                    self.viewModel.pagination.accept(p)
                    self.view_empty_data.isHidden = self.viewModel.dataArray.value.count > 0 ? true : false
                }
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
         
        }).disposed(by: rxbag)
    }
}
