//
//  ReturnFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class ReturnFoodViewModel: BaseViewModel {
    
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var order_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var order_detail_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var quantity = BehaviorRelay<Int>(value: 1)
    var note = BehaviorRelay<String>(value: "")
//    public var dataArray : BehaviorRelay<[ReasonCancel]> = BehaviorRelay(value: [])
    private(set) weak var view: ReturnFoodViewController?
    private var router: ReturnFoodRouter?
    
    
    func bind(view: ReturnFoodViewController, router: ReturnFoodRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
extension ReturnFoodViewModel{
    func returnBeer() -> Observable<APIResponse> {
        
        return appServiceProvider.rx.request(.returnBeer(
            branch_id: branch_id.value,
            order_id:order_id.value,
            quantity:quantity.value,
            order_detail_id:order_detail_id.value,
            note: note.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
