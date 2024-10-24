//
//  PraricyPolicyViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit

class WebViewViewModel: BaseViewModel {
    private(set) weak var view: WebViewViewController?
    private var router: WebViewRouter?
    
    
    func bind(view: WebViewViewController, router: WebViewRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
}
