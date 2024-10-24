//
//  GenerateReportViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
import RxRelay
class GenerateReportViewController: BaseViewController {


    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var avatar_branch: UIImageView!
    @IBOutlet weak var lbl_branch_name: UILabel!
    @IBOutlet weak var view_select_brach: UIView!
    @IBOutlet weak var lbl_branch_address: UILabel!
    
    @IBOutlet weak var btm_constraint_of_stackview: NSLayoutConstraint!
    var viewModel = GenerateReportViewModel()
    var router = GenerateReportRouter()
    let refreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        lbl_branch_name.text = ManageCacheObject.getCurrentUser().branch_name
        lbl_branch_address.text = ManageCacheObject.getCurrentUser().branch_address
        
        if permissionUtils.GPBH_1{
            var dataSection = viewModel.dataSectionArray.value
            dataSection.popLast()
            viewModel.dataSectionArray.accept(dataSection)
        }
        
        registerCell()
        bindTableView()
        
        // Tắt Chọn chi nhánh ở đầu tổng quan ở gpbh leve 1
        
        view_select_brach.isHidden = permissionUtils.GPBH_1_o_1 ? true : false
//        btm_constraint_of_stackview.constant -= Utils.heightOfCustomBar
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableview.addSubview(refreshControl) // not required when using UItableViewController
    }
    
    
    
    @objc func refresh(_ sender: AnyObject) {
        reportRevenueTodayByBranch()
        reportRevenueTodayByTime()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(ManageCacheObject.isLogin()){
            lbl_branch_name.text = ManageCacheObject.getCurrentBranch().name
            lbl_branch_address.text = ManageCacheObject.getCurrentBranch().address
            avatar_branch.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: ManageCacheObject.getCurrentBranch().avatar)), placeholder: UIImage(named: "image_defauft_medium"))
            
            reportRevenueTodayByBranch()
            reportOfFoodApp()
            reportRevenueTodayByTime()
            getSaleReport()//MARK: báo cáo bán hàng
            getRevenueCostProfitReport()//MARK: báo cao doanh thu chi phí lợi nhuận
            getReportRevenueArea()//MARK: báo cáo doanh thu khu vực
            getReportTableRevenue()//MARK: báo cáo doanh thu bàn
            getReportRevenueEmployee()//MARK: báo cáo doanh thu nhân viên
            getRevenueReportByFood() //MARK: báo cáo danh thu bán hàng món ăn
            getRevenueReportCommodity()//MARK: báo cáo danh thu bán hàng hàng hoá
            getCategoryReport()//MARK: báo cáo danh mục
            getGiftedFoodReport()//MARK: báo cáo món tặng
            getReportFoodOther()//MARK: báo cáo doanh thu món ngoài menu
            getReportFoodCancel()//MARK: báo cao doanh thu món huỷ
            getVATReport()//MARK: báo cao doanh thu VAT
            getdiscountReport()//MARK: báo cao doanh thu các món giảm giá
            getReportSurcharge()//MARK: báo cao doanh thu phụ thu
        }
        
    }
    

    
    //MARK: Register Cells as you want
    func registerCell(){
        
        let cellIdentifiers = [
                    "ReportOrderTodayTableViewCell",
                    "ReportTotalAmountTempTodayTableViewCell",
                    "ReportRevenueTempTodayTableViewCell",
                    "ReportRevenueGeneralTableViewCell",
                    "ReportRevenueFeeProfitTableViewCell",
                    "ReportRevenueAreaTableViewCell",
                    "ReportRevenueTableTableViewCell",
                    "ReportRevenueEmployeeTableViewCell",
                    "ReportRevenueByCategoryTableViewCell",
                    "ReportRevenueByFoodTableViewCell",
                    "ReportRevenueCommodityTableViewCell",
                    "ReportCategoryTableViewCell",
                    "ReportGiftFoodTableViewCell",
                    "ReportOtherFoodTableViewCell",
                    "ReportCancelFoodTableViewCell",
                    "ReportTakeAwayFoodTableViewCell",
                    "ReportVATTableViewCell",
                    "ReportDiscountTableViewCell",
                    "ReportSurchargeTableViewCell"
        ]
        
        // Register cells using a for loop
        for identifier in cellIdentifiers {
            let cell = UINib(nibName: identifier, bundle: .main)
            tableview.register(cell, forCellReuseIdentifier: identifier)
        }
        tableview.rowHeight = UITableView.automaticDimension
        
    }
    
}
extension GenerateReportViewController{
    
    func bindTableView(){
        viewModel.dataSectionArray.asObservable().bind(to: tableview.rx.items){ [self] (tableView, index, element) in
            switch(element){
                
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ReportOrderTodayTableViewCell") as! ReportOrderTodayTableViewCell
                    cell.viewModel = viewModel
                    return cell
                
                case 1: let cell = tableView.dequeueReusableCell(withIdentifier:"ReportTotalAmountTempTodayTableViewCell" ) as! ReportTotalAmountTempTodayTableViewCell
                    cell.viewModel = viewModel
                    return cell

                
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ReportRevenueTempTodayTableViewCell") as! ReportRevenueTempTodayTableViewCell
                    cell.viewModel = viewModel
                    return cell
                
                case 3:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportRevenueGeneralTableViewCell" ) as! ReportRevenueGeneralTableViewCell
                    cell.viewModel = viewModel
                    return cell

                case 4:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportRevenueFeeProfitTableViewCell" ) as! ReportRevenueFeeProfitTableViewCell
                    cell.viewModel = viewModel
                    return cell

                case 5:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportRevenueAreaTableViewCell" ) as! ReportRevenueAreaTableViewCell
                    cell.viewModel = viewModel
                    return cell
                    
                case 6:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportRevenueTableTableViewCell" ) as! ReportRevenueTableTableViewCell
                    cell.viewModel = viewModel
                    return cell

                case 7:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportRevenueEmployeeTableViewCell" ) as! ReportRevenueEmployeeTableViewCell
                    cell.viewModel = viewModel
                    return cell

                case 8:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportRevenueByCategoryTableViewCell" ) as! ReportRevenueByCategoryTableViewCell
                    cell.viewModel = viewModel
                    return cell
                
                case 9:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportRevenueByFoodTableViewCell" ) as! ReportRevenueByFoodTableViewCell
                    cell.viewModel = viewModel
                    return cell

                case 10:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportRevenueCommodityTableViewCell" ) as! ReportRevenueCommodityTableViewCell
                    cell.viewModel = viewModel
                    return cell

                case 11:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportGiftFoodTableViewCell" ) as! ReportGiftFoodTableViewCell
                    cell.viewModel = viewModel
                    return cell

                case 12:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportOtherFoodTableViewCell" ) as! ReportOtherFoodTableViewCell
                    cell.viewModel = viewModel
                    return cell

                case 13:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportCancelFoodTableViewCell" ) as! ReportCancelFoodTableViewCell
                    cell.viewModel = viewModel
                    return cell
                
                case 14:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportTakeAwayFoodTableViewCell" ) as! ReportTakeAwayFoodTableViewCell
                    cell.viewModel = viewModel
                    return cell
                
                case 15:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportVATTableViewCell" ) as! ReportVATTableViewCell
                    cell.viewModel = viewModel
                    return cell

                case 16:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportDiscountTableViewCell" ) as! ReportDiscountTableViewCell
                    cell.viewModel = viewModel
                    return cell

                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportSurchargeTableViewCell" ) as! ReportSurchargeTableViewCell
                    cell.viewModel = viewModel
                    return cell

            }
        }
    }
}



