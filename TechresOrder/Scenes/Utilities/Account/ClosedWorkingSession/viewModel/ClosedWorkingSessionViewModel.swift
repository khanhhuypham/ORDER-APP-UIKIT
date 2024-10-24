//
//  ClosedWorkingSessionViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 22/02/2023.
//

import UIKit
import RxSwift
import RxRelay

class ClosedWorkingSessionViewModel: BaseViewModel {
    private(set) weak var view: ClosedWorkingSessionViewController?
    private var router: ClosedWorkingSessionRouter?
    
    // Khai báo biến để hứng dữ liệu từ VC
    public var closeWorkingSessionRequest : BehaviorRelay<CloseWorkingSessionRequest> = BehaviorRelay(value: CloseWorkingSessionRequest.init())
    public var checkWorkingSession = BehaviorRelay<CheckWorkingSession>(value: CheckWorkingSession.init()!)
    
    var money_500 = BehaviorRelay<String>(value: "")
    var money_200 = BehaviorRelay<String>(value: "")
    var money_100 = BehaviorRelay<String>(value: "")
    var money_50 = BehaviorRelay<String>(value: "")
    var money_20 = BehaviorRelay<String>(value: "")
    var money_10 = BehaviorRelay<String>(value: "")
    var money_5 = BehaviorRelay<String>(value: "")
    var money_2 = BehaviorRelay<String>(value: "")
    var money_1 = BehaviorRelay<String>(value: "")
    
    func bind(view: ClosedWorkingSessionViewController, router: ClosedWorkingSessionRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}

extension ClosedWorkingSessionViewModel{
    
    func workingSessionValue() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.workingSessionValue)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func closeWorkingSession() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.closeWorkingSession(closeWorkingSessionRequest: closeWorkingSessionRequest.value))
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
    
}
