//
//  MemberRegisterViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 15/02/2023.
//

import UIKit

class MemberRegisterViewModel: BaseViewModel {
    private(set) weak var view: MemberRegisterViewController?
    private var router: MemberRegisterRouter?
    
    
    func bind(view: MemberRegisterViewController, router: MemberRegisterRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
