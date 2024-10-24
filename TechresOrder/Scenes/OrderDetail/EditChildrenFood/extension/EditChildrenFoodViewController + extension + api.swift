//
//  EditChildrenFoodViewController + extension + api.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/04/2024.
//

import UIKit
import RxSwift
import RxRelay
import ObjectMapper
import JonAlert
extension EditChildrenFoodViewController {
    
    
    func updateFoodsToOrder(updateFood: [FoodUpdate]){
        viewModel.updateFoods(updateFood: updateFood).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.dismiss(animated: true, completion: {
                    (self.completetion ?? {})()
                })
            }else {
                JonAlert.showError(message: response.message ?? "", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
   
}

