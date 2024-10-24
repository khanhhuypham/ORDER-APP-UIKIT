//
//  QRCodeCashbackBillViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit

class QRCodeCashbackBillViewModel: BaseViewModel {

    private(set) weak var view: QRCodeCashbackBillViewController?
    private var router: QRCodeCashbackBillRouter?
    
    func bind(view: QRCodeCashbackBillViewController, router: QRCodeCashbackBillRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
}
