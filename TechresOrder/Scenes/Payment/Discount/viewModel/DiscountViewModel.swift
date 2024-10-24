//
//  DiscountViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 20/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class DiscountViewModel: BaseViewModel {
    private(set) weak var view: DiscountViewController?
    
    /*
        loại lý do giảm giá
        type = 1 -> discount trên tổng bill
        type = 2 -> discount theo từng loại món
     */
    var discountReasonType = BehaviorRelay<Int>(value: 1)
    
    var order_id = BehaviorRelay<Int>(value: 0)
    var food_discount_percent = BehaviorRelay<Int>(value: 0)
    var drink_discount_percent = BehaviorRelay<Int>(value: 0)
    var total_bill_discount_percent = BehaviorRelay<Int>(value: 0)
    var note = BehaviorRelay<String>(value: "")

    
    

    func bind(view: DiscountViewController){
        self.view = view

    }

    
}
extension DiscountViewModel{
    func discount() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.discount(
                                                order_id:order_id.value,
                                                branch_id:ManageCacheObject.getCurrentBranch().id,
                                                food_discount_percent:food_discount_percent.value,
                                                drink_discount_percent:drink_discount_percent.value,
                                                total_amount_discount_percent:total_bill_discount_percent.value,
                                                note:note.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
