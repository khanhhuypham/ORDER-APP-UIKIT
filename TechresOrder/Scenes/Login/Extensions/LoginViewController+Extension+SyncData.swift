//
//  LoginViewController+Extension+SyncData.swift
//  TECHRES-ORDER
//
//  Created by Kelvin on 19/09/2023.
//

import UIKit
import ObjectMapper

extension LoginViewController {

//    //MARK: Get all foods from server store local database
//    public func syncDataFoods(){
//        viewModel.branch_id.accept(ManageCacheObject.getCurrentUser().branch_id)
//        viewModel.area_id.accept(-1)
//        viewModel.key_word.accept("")
//        viewModel.foods().subscribe(onNext: { (response) in
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                if let foods = Mapper<Food>().mapArray(JSONObject: response.data) {
//                    // clean all data on local database
//                    ManagerRealmHelper.shareInstance().deleteAllFoods()
//                    
//                    // Save all Food To database local
//                    ManagerRealmHelper.shareInstance().saveFoods(foods: foods)
//                }
//            }else{
//                dLog(response.message ?? "")
//            }
//         
//        }).disposed(by: rxbag)
//    }
    
}
