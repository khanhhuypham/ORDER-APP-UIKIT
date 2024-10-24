//
//  ExtraChargeViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 15/11/2023.
//

import UIKit
import RxSwift
import RxRelay
class ExtraChargeViewModel: BaseViewModel {
    private(set) weak var view: ExtraChargeViewController?

    var order_id = BehaviorRelay<Int>(value: 0)
    var total_amount_extra_charge_percent = BehaviorRelay<Int>(value: 0)
    
    
    func bind(view: ExtraChargeViewController){
        self.view = view
    }
    
  
}
extension ExtraChargeViewModel{
     func applyExtraChargeOnTotalBill() -> Observable<APIResponse> {
         return appServiceProvider.rx.request(.postApplyExtraChargeOnTotalBill(
                                    order_id: order_id.value,
                                    branch_id: ManageCacheObject.getCurrentBranch().id,
                                    total_amount_extra_charge_percent: total_amount_extra_charge_percent.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
}
