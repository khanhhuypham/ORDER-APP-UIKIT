//
//  CreateAreaViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class CreateAreaViewModel: BaseViewModel {
    private(set) weak var view: CreateAreaViewController?

    public var area = BehaviorRelay<Area>(value: Area.init()!)
    
    func bind(view: CreateAreaViewController){
        self.view = view
    }

}
// MARK: CALL API HERE...
extension CreateAreaViewModel{
    func createArea(is_confirmed:Int? = nil) -> Observable<APIResponse> {
        
        return appServiceProvider.rx.request(.createArea(
            branch_id: ManageCacheObject.getCurrentBranch().id,
            area: area.value,
            is_confirm: is_confirmed
        ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
