//
//  Utitilies_rebuildRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/10/2023.
//



import UIKit
import RxSwift

class UtilitiesRouter {
    
    
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = UtilitiesViewController(nibName: "UtilitiesViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToSettingAccountViewController(){
        let vc = SettingAccountRouter().viewController as! SettingAccountViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToManagementAreaTableViewController(){
        let vc = AreaTableManagementRouter().viewController as! AreaTableManagementViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToManagementCategoryFoodNoteViewController(){
        let vc = ManagerCategoryFoodNoteRouter().viewController as! ManagerCategoryFoodNoteViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSettingPrinterViewController(isFoodApp:Bool){
        let vc = SettingPrinterRouter().viewController as! SettingPrinterViewController
        vc.isFoodApp = isFoodApp
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSettingViewController(){
        let vc = SettingRouter().viewController as! SettingViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToOrderManagementViewController(){
        let vc = OrderManagementRouter().viewController as! OrderManagementViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToMemberRegisterViewController(){
        let vc = MemberRegisterRouter().viewController as! MemberRegisterViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToRevenueDetailViewController(){
        let vc = RevenueDetailRouter().viewController as! RevenueDetailViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToReportBusinessAnalyticsViewController(){
        let vc = ReportBusinessAnalyticsRouter().viewController as! ReportBusinessAnalyticsViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToReportBusinessViewController(){
        let vc = ReportBusinessRouter().viewController as! ReportBusinessViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToEmployeeReportRevenueViewController(){
        let vc = ReportRevenueEmployeeRouter().viewController as! ReportRevenueEmployeeViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigationToUpdateBranchViewController() {
        let vc = UpdateBranchRouter().viewController as! UpdateBranchViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigationToEnvironmentViewController() {
        let vc = EnvironmentModeRouter().viewController as! EnvironmentModeViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func navigationToTechresShop() {
        let vc = TechresShopRouter().viewController as! TechresShopViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func navigationToAppFood() {
        let vc = AppFoodRouter().viewController as! AppFoodViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigationToAssignToAppFood() {
        let vc = AssignAppFoodViewController()
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func navigationToAppFoodDiscount() {
        let vc = FoodAppDiscount2Router().viewController as! FoodAppDiscount2ViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
        
    func navigationToOrderHistoryOfFoodAppViewController() {
        let vc = OrderManagementOfFoodAppRouter().viewController as! OrderManagementOfFoodAppViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigationToFoodAppReportViewController() {
        let vc = FoodAppReportRouter().viewController as! FoodAppReportViewController
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    

}
 
