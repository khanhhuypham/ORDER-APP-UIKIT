//
//  UpdateBranchViewModel.swift
//  TECHRES-ORDER
//
//  Created by macmini_techres_04 on 14/09/2023.
//

import UIKit
import RxSwift
import RxRelay

class UpdateBranchViewModel: BaseViewModel {
    private(set) weak var view: UpdateBranchViewController?
    private var router: UpdateBranchRouter?
    
    public var dataArray : BehaviorRelay<Branch> = BehaviorRelay(value: Branch())
    var selectedArea = BehaviorRelay<[String:Area]>(value:[String:Area]())
    
    func bind(view: UpdateBranchViewController, router: UpdateBranchRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makeToPopViewController() {
        router?.navigationPopToViewController()
    }
    
 
    
}
extension UpdateBranchViewModel {
    func getInfoBranches() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getInfoBranches(IdBranches: dataArray.value.id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func updateBranches() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateBranch(branchRequest: dataArray.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
