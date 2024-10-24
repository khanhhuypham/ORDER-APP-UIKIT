//
//  Utilities_rebuildViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/10/2023.
//


import UIKit
import RxRelay
import RxSwift
class UtilitiesViewModel: BaseViewModel {
    private(set) weak var view: UtilitiesViewController?
    private var router: UtilitiesRouter?
   

    func bind(view: UtilitiesViewController, router: UtilitiesRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    func makeSettingAccountViewController(){
        router?.navigateToSettingAccountViewController()
    }
    func makeManagementAreaTableViewController(){
        router?.navigateToManagementAreaTableViewController()
    }
    func makeManagementCategoryFoodNoteViewController(){
        router?.navigateToManagementCategoryFoodNoteViewController()
    }
    
    func makeSettingPrinterViewController(isFoodApp:Bool = false){
        router?.navigateToSettingPrinterViewController(isFoodApp:isFoodApp)
    }
    
    func makeSettingViewController(){
        router?.navigateToSettingViewController()
    }
    
    
    func makeOrderManagementViewController(){
        router?.navigateToOrderManagementViewController()
    }
    
    func makeMemberRegisterViewController(){
        router?.navigateToMemberRegisterViewController()
    }
  
    func makeToRevenueDetailViewController(){
        router?.navigateToRevenueDetailViewController()
    }
    func makeToReportBusinessAnalyticsViewController(){
        router?.navigateToReportBusinessAnalyticsViewController()
    }
    func makeToReportBusinessViewController(){
        router?.navigateToReportBusinessViewController()
    }
    func makeToEmployeeReportRevenueViewController(){
        router?.navigateToEmployeeReportRevenueViewController()
        
    }
    func makeToUpdateBranchViewController() {
        router?.navigationToUpdateBranchViewController()
    }
    
    func makeEnvironmentViewController() {
        router?.navigationToEnvironmentViewController()
    }
    
    func makeWebViewController() {
        router?.navigationToTechresShop()
    }
    
    func makeAppFoodViewController() {
        router?.navigationToAppFood()
    }
    
    func makeFoodAppDiscountViewController() {
        router?.navigationToAppFoodDiscount()
    }
    
  
    
    func makeOrderHistoryOfFoodAppViewController() {
        router?.navigationToOrderHistoryOfFoodAppViewController()
    }
    
    func makeFoodAppReportViewController() {
        router?.navigationToFoodAppReportViewController()
    }
    
    
    func makeAssignToAppFoodViewController() {
        router?.navigationToAssignToAppFood()
    }


  

}
