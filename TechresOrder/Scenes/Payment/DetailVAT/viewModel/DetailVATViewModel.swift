//
//  DetailVATViewModel.swift
//  TECHRES - Bán Hàng
//
//  Created by Kelvin on 19/03/2023.
//

import UIKit
import RxSwift
import RxRelay

class DetailVATViewModel: BaseViewModel {
    private(set) weak var view: DetailVATViewController?

   
    public var brand_id : BehaviorRelay<Int> = BehaviorRelay(value: -1)
    public var order_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : BehaviorRelay<[VATOrder]> = BehaviorRelay(value: [])
    public var detail_vats : BehaviorRelay<[DetailVAT]> = BehaviorRelay(value: [])
    
    func bind(view: DetailVATViewController){
        self.view = view
    }

}
extension DetailVATViewModel{
    func getVATDetails() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getVATDetail( order_id: order_id.value, branch_id: brand_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
