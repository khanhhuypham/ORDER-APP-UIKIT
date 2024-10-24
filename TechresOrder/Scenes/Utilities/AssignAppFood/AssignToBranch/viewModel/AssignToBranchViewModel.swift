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
    
    var channel_order_food_id = BehaviorRelay<Int>(value: 0)
    var restaurant_brand_id = BehaviorRelay<Int>(value: ALL)
    var dataArray = BehaviorRelay<[BranchMapsFoodApp]>(value: [])
    var branch_maps = BehaviorRelay<[BranchMapsFoodApp]>(value: [])

    func bind(view: AssignToBranchViewController, router: AssignToBranchRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController() {
        router?.navigateToPopViewController()
    }
    
    var isValidBranchMaps: Observable<Bool> {
        return branch_maps.map({ [weak self] data in
            if (data.filter({ $0.branch_id > 0 }).count == 0) {
                self?.disableButton(self!.view!.confirmBtn)
                return false
            }
            self?.enableButton(self!.view!.confirmBtn)
            return true
        })
    }
    
    
    // Cho button disable
    func disableButton(_ button: UIButton) {
        button.backgroundColor = ColorUtils.disableGrayColor()
        button.tintColor = ColorUtils.gray_000()
        button.isEnabled = false
    }
    
    // Cho button enable
    func enableButton(_ button: UIButton) {
        button.backgroundColor = ColorUtils.orange_brand_900()
        button.tintColor = ColorUtils.white()
        button.isEnabled = true
    }
}

extension AssignToBranchViewModel {
    func getBranch() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getBranchFoodApp(channel_order_food_id: channel_order_food_id.value, restaurant_brand_id: restaurant_brand_id.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    
    func postAssignBranchFoodApp() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postAssignBranchFoodApp(branch_maps: branch_maps.value, channel_order_food_id: channel_order_food_id.value, restaurant_brand_id: restaurant_brand_id.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
}
