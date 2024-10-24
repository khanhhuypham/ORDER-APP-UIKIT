//
//  AddressDialogOfAccountInforViewModel.swift
//  SEEMT
//
//  Created by Pham Khanh Huy on 27/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
class AddressDialogOfAccountInforViewModel: BaseViewModel {
    private(set) weak var view: AddressDialogOfAccountInforViewController?
    private var router: AddressDialogOfAccountInforRouter?

    var areaData = BehaviorRelay<[Area]>(value: [])
    var areaDataFilter = BehaviorRelay<[Area]>(value: [])
    var beingSelectedArea = BehaviorRelay<[String:Area]>(value:[String:Area]())
    
    func bind(view: AddressDialogOfAccountInforViewController, router: AddressDialogOfAccountInforRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
        
    }
    
    func makePopViewController(){
        router?.navigatePopView()
    }
    

    func getCitiesList() -> Observable<APIResponse>{
        return appServiceProvider.rx.request(.cities(limit: 200))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    
    func getDistrictsList() -> Observable<APIResponse>{
        return appServiceProvider.rx.request(.districts(city_id: beingSelectedArea.value["CITY"]!.id))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    
    func getWardsList() -> Observable<APIResponse>{
        return appServiceProvider.rx.request(.wards(district_id:  beingSelectedArea.value["DISTRICT"]!.id))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    
    
}
