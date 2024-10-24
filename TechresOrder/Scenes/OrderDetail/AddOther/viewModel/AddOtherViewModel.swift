//
//  ManagerOtherAndExtraFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 21/01/2023.
//

import UIKit

class AddOtherViewModel: BaseViewModel {
    private(set) weak var view: AddOtherViewController?
    private var router: AddOtherRouter?
    
    func bind(view: AddOtherViewController, router: AddOtherRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
