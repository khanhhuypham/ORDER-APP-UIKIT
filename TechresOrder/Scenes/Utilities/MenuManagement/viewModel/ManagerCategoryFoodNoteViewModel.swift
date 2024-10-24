//
//  ManagerCategoryFoodNoteViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxRelay
import RxSwift
class ManagerCategoryFoodNoteViewModel: BaseViewModel {
    private(set) weak var view: ManagerCategoryFoodNoteViewController?
    private var router: ManagerCategoryFoodNoteRouter?
   
    var branch_id = BehaviorRelay<Int>(value: 0)
    
    func bind(view: ManagerCategoryFoodNoteViewController, router: ManagerCategoryFoodNoteRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
