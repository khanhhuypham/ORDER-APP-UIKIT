//
//  SettingPrinter_RebuildViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/09/2023.
//

import UIKit
import RxRelay
import RxSwift
class SettingPrinterViewModel: BaseViewModel {
    private(set) weak var view: SettingPrinterViewController?
    private var router:SettingPrinterRouter?

    //MARK: MÁY IN HOÁ ĐƠN
    public var printersBill : BehaviorRelay<[Printer]> = BehaviorRelay(value: [])
    //MARK: MÁY IN BẾP & BAR
    public var printersChefBar : BehaviorRelay<[Printer]> = BehaviorRelay(value: [])
    //MARK: MÁY IN STAMP
    public var printersStamp : BehaviorRelay<[Printer]> = BehaviorRelay(value: [])
    
    var status = BehaviorRelay<Int>(value: 1)

    
    func bind(view: SettingPrinterViewController, router: SettingPrinterRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    func makeDetailedPrinterViewController(printer:Printer){
        router?.navigateToDetailedPrinterViewController(printer: printer)
    }
    
}


extension SettingPrinterViewModel {
    func kitchens() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.kitchens(branch_id: ManageCacheObject.getCurrentBranch().id, status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

