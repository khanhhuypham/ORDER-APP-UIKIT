//
//  AssignToBranchViewModel.swift
//  TECHRES-ORDER
//
//  Created by Huynh Quang Huy on 26/8/24.
//

import UIKit
import RxRelay
import RxSwift

class AssignToBranchViewModel: BaseViewModel {
    private(set) weak var view: AssignToBranchViewController?
    private var router: AssignToBranchRouter?
    
  
    var partner = BehaviorRelay<FoodAppAPartner>(value: FoodAppAPartner())
    var branches = BehaviorRelay<[BranchOfFoodApp]>(value: [])
    
    var slots = BehaviorRelay<[(slotNumber:Int,branch:BranchOfFoodApp?)]>(value:[(1,nil)])
    var selectedslot = BehaviorRelay<Int>(value:0)


    func bind(view: AssignToBranchViewController, router: AssignToBranchRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController() {
        router?.navigateToPopViewController()
    }

}

