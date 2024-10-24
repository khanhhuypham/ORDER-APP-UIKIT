//
//  OpenWorkingSessionViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit
import RxSwift
import RxRelay

//MARK -- CALL API 
class OpenWorkingSessionViewModel: BaseViewModel {
    private(set) weak var view: OpenWorkingSessionViewController?
    private var router = OpenWorkingSessionRouter()
    
    public var before_cash : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var branch_working_session_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    

    
    func bind(view: OpenWorkingSessionViewController, router: OpenWorkingSessionRouter){
        self.view = view
        self.router = router
        self.router.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router.navigateToPopViewController()
        
    }
    
   

}
extension OpenWorkingSessionViewModel{
    func openSession() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.openSession(
            before_cash: before_cash.value, branch_working_session_id:branch_working_session_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }

}
