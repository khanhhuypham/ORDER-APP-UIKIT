//
//  EditChildrenFoodViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/03/2024.
//

import UIKit
import RxSwift
import RxRelay
class EditChildrenFoodViewModel: NSObject {
    
    private(set) weak var view: EditChildrenFoodViewController?
    var orderId = BehaviorRelay<Int>(value: 0)
    var orderItem = BehaviorRelay<OrderItem>(value: OrderItem())
    
    func bind(view: EditChildrenFoodViewController){
        self.view = view
    }
    
   
    func updateFoods(updateFood: [FoodUpdate]) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateFoods(
                branch_id: ManageCacheObject.getCurrentBranch().id,
                order_id: orderId.value,
                foods: updateFood))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
}
