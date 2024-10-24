//
//  UpdateFeedViewModel.swift
//  ORDER
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 16/06/2023.
//

import UIKit

class UpdateFeedMaterialViewModel: BaseViewModel {
    
    private(set) weak var view: UpdateFeedMaterialViewController?
    private var router: UpdateFeedMaterialRouter?
    
    func bind(view: UpdateFeedMaterialViewController, router: UpdateFeedMaterialRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
