//
//  ManagementAreaTableManagerViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxRelay


class ManagementAreaTableManagerViewModel: BaseViewModel {
    private(set) weak var view: AreaTableManagementViewController?
    private var router: AreaTableManagementRouter?
   

    
    func bind(view: AreaTableManagementViewController, router: AreaTableManagementRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
