//
//  ManagementAreaViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
import RxRelay

class AreaManagementViewModel: BaseViewModel {
    private(set) weak var view: AreaManagementViewController?

    public var area_array : BehaviorRelay<[Area]> = BehaviorRelay(value: [])

    func bind(view: AreaManagementViewController){
        self.view = view

    }
    
}
extension AreaManagementViewModel{
    func getAreas() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.areas(branch_id: ManageCacheObject.getCurrentBranch().id, status: ALL))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}
