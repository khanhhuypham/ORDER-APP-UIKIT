//
//  TermOfUseViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit

class TermOfUseViewModel: BaseViewModel {
    private(set) weak var view: TermOfUseViewController?
    private var router: TermOfUseRouter?
    
    
    func bind(view: TermOfUseViewController, router: TermOfUseRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    
}
