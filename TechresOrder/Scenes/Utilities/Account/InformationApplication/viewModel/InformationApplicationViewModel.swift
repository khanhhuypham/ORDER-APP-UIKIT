//
//  InformationApplicationViewModel.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 04/12/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class InformationApplicationViewModel: BaseViewModel {

    private(set) weak var view: InformationApplicationViewController?
    private var router: InformationApplicationRouter?
    
    public var os_name : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var key_search : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var is_require_update : BehaviorRelay<Int> = BehaviorRelay(value: 1)
    public var limit : BehaviorRelay<Int> = BehaviorRelay(value: 20)
    public var page : BehaviorRelay<Int> = BehaviorRelay(value: 1)
    
    public var dataArray : BehaviorRelay<[ResponseInfoApp]> = BehaviorRelay(value: [])
    
    func bind(view: InformationApplicationViewController, router: InformationApplicationRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}

extension InformationApplicationViewModel {
    func infoApp() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getVersionApp(os_name: os_name.value, key_search: key_search.value, is_require_update: is_require_update.value, limit: limit.value, page: page.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
