//
//  ServicePopupViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/11/2023.
//


import UIKit
import RxRelay
import RxSwift

class ServicePopupViewModel: BaseViewModel {
    private(set) weak var view: ServicePopupViewController?
    var dateType = BehaviorRelay<Int>(value: 1)
    var orderItem = BehaviorRelay<OrderItem>(value: OrderItem())
    

    func bind(view: ServicePopupViewController){
        self.view = view
    }
    
 
    
}
extension ServicePopupViewModel{
    func updateService() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postUpdateService(
            order_id: orderItem.value.order_id,
                    branch_id: ManageCacheObject.getCurrentBranch().id,
                    order_detail_id: orderItem.value.id,
                    start_time: orderItem.value.service_start_time,
                    end_time: orderItem.value.service_end_time,
                    note: orderItem.value.note
                ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
