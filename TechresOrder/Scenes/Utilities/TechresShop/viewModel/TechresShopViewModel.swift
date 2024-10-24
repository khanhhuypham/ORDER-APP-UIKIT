//
//  TechresShopViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit

class TechresShopViewModel: NSObject {
    private(set) weak var view: TechresShopViewController?
    private var router: TechresShopRouter?
    
    func bind(view: TechresShopViewController, router: TechresShopRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
