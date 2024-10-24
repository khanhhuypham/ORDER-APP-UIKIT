//
//  CategoryManagementViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import RxRelay
import RxSwift
class CategoryManagementViewModel: BaseViewModel {
    private(set) weak var view: CategoryManagementViewController?
    private var router: CategoryManagementRouter?
    var brand_id = BehaviorRelay<Int>(value: ManageCacheObject.getCurrentBrand().id)
    var status = BehaviorRelay<Int>(value: -1)
    public var dataArray : BehaviorRelay<[Category]> = BehaviorRelay(value: [])
    
    func bind(view: CategoryManagementViewController, router: CategoryManagementRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
extension CategoryManagementViewModel{
    func getCategories() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.categoriesManagement(brand_id:brand_id.value,status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

