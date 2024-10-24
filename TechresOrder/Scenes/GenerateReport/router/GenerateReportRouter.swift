//
//  GenerateReportRouter.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//

import UIKit

class GenerateReportRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = GenerateReportViewController(nibName: "GenerateReportViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }

    
    
    func navigateToRevenueDetailViewController(report:SaleReport){
        let vc = RevenueDetailRouter().viewController as! RevenueDetailViewController
        vc.saleReport = report
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Báo cáo nhân viên
    func navigateToDetailReportRevenueEmployeeViewController(){
        let vc = ReportRevenueEmployeeRouter().viewController as! ReportRevenueEmployeeViewController
//        reportRevenueEmployeeViewController.dataDetail = dataDetail
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
        
    //MARK: Báo cáo món ăn
    func navigateToDetailRevenueByFoodViewController(report:FoodReportData){
        let vc = ReportBusinessRouter().viewController as! ReportBusinessViewController
        vc.foodReport = report
        vc.categoryPresent = 1
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Báo cáo hàng hoá
    func navigateToDetailReportRevenueCommodityViewController(report:FoodReportData){
        let vc = DetailReportRevenueCommodityRouter().viewController as! DetaiRevenueCommodityViewController
        vc.detailedReport = report
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    

    //MARK: Báo cáo danh mục
    func navigateToDetailRevenueByFoodCategoryViewController(report:RevenueCategoryReport){
        let vc = ReportBusinessRouter().viewController as! ReportBusinessViewController
        vc.categoryReport = report
        vc.categoryPresent = 0
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Báo cáo món tặng
    func navigateToDetailReportGiftFoodViewController(report:FoodReportData){
        let vc = ReportBusinessRouter().viewController as! ReportBusinessViewController
        vc.giftReport = report
        vc.categoryPresent = 4
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Báo cáo món NGOÀI MENU
    func navigateToDetailReportOtherFoodViewController(report:FoodReportData){
        let vc = ReportBusinessRouter().viewController as! ReportBusinessViewController
        vc.otherFoodReport = report
        vc.categoryPresent = 2
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Báo cáo món hủy
    func navigateToDetailReportCancelFoodViewController(report:FoodReportData){
        let vc = ReportBusinessRouter().viewController as! ReportBusinessViewController
        vc.cancelFoodReport = report
        vc.categoryPresent = 3
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Báo cáo món mang về
    func navigateToDetailReportTakeAwayFoodViewController(report:FoodReportData){
        let vc = ReportTakeAwayFoodRouter().viewController as! ReportTakeAwayFoodViewController
        vc.detailedReport = report
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Báo cáo VAT
    func navigateToDetailReportVATViewController(report:VATReport){
        let vc = ReportBusinessRouter().viewController as! ReportBusinessViewController
        vc.vatReport = report
        vc.categoryPresent = 6
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Báo cáo giảm giá
    func navigateToDetailReportDiscountViewController(report:DiscountReport){
        let vc = ReportBusinessRouter().viewController as! ReportBusinessViewController
        vc.discountReport = report
        vc.categoryPresent = 5
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }

    
    //MARK: Báo cáo khu vực
    func navigateToDetailReportRevenueAreaViewController(report:AreaRevenueReport){
        let vc = ReportBusinessRouter().viewController as! ReportBusinessViewController
        vc.areaRevenueReport = report
        vc.categoryPresent = 8
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Báo cáo bàn
    func navigateToDetailReportRevenueTableViewController(report:TableRevenueReport){
        let vc = ReportBusinessRouter().viewController as! ReportBusinessViewController
        vc.tableRevenueReport = report
        vc.categoryPresent = 7
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }

}
