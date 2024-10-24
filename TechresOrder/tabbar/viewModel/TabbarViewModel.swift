//
//  TabbarViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 25/07/2024.
//

import UIKit
import RxSwift
import RxRelay

class TabbarViewModel: NSObject {
    private(set) weak var view: TabbarViewController?

    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: Constants.branch.id)
    public var emplpoyee_id : BehaviorRelay<Int> = BehaviorRelay(value: ManageCacheObject.getCurrentUser().id)
    public var order_session_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    func bind(view: TabbarViewController){
        self.view = view
    }
    

    func workingSessions() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.workingSessions(
            branch_id: branch_id.value, empaloyee_id:emplpoyee_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func checkWorkingSessions() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.checkWorkingSessions)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func assignWorkingSessions() -> Observable<APIResponse> {
     
        return appServiceProvider.rx.request(.assignWorkingSession(branch_id: branch_id.value, order_session_id: order_session_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}
