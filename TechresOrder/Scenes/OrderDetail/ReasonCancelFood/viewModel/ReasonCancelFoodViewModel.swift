//
//  ReasonCancelFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import RxRelay
class ReasonCancelFoodViewModel: BaseViewModel {
   
    public var dataArray = BehaviorRelay<[ReasonCancel]>(value: [])
  
    private(set) weak var view: ReasonCancelFoodViewController?

    func bind(view: ReasonCancelFoodViewController){
        self.view = view
    }

}
extension ReasonCancelFoodViewModel{
    func reasonCancelFoods() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.reasonCancelFoods(branch_id: ManageCacheObject.getCurrentBranch().id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
  
}
