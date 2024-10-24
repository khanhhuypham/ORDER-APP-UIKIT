//
//  StampPrinterViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/09/2023.
//

import UIKit
import RxRelay
import RxSwift
import CoreBluetooth
class DetailedPrinterViewModel: BaseViewModel {
    private(set) weak var view: DetailedPrinterViewController?
    private var router = DetailedPrinterRouter()
    public var printer:BehaviorRelay<Printer> = BehaviorRelay(value: Printer.init())
    

    func bind(view: DetailedPrinterViewController, router: DetailedPrinterRouter){
        self.view = view
        self.router = router
        self.router.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router.navigateToPopViewController()
        
    }
    
}
// CALL API HERE...
extension DetailedPrinterViewModel{
    func updateStampPrinter() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateKitchen(branch_id: 0, kitchen: printer.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
}
