//
//  ReportViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 28/01/2023.
//

import UIKit
import Charts

class ReportViewController: BaseViewController {
    var viewModel = ReportViewModel()
    
  
    @IBOutlet weak var line_chart_view: LineChartView!
    @IBOutlet weak var lbl_target_amount: UILabel!
    @IBOutlet weak var lbl_target_point: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbl_branch_name: UILabel!
    @IBOutlet weak var lbl_branch_address: UILabel!
    @IBOutlet weak var avatar_branch: UIImageView!
    

    @IBOutlet weak var btnFilterToday: UIButton!
    @IBOutlet weak var btnFilterYesterday: UIButton!
    @IBOutlet weak var btnFilterThisweek: UIButton!
    @IBOutlet weak var btnFilterThismonth: UIButton!
    @IBOutlet weak var btnFilterLastmonth: UIButton!
    @IBOutlet weak var btnFilterThreeMonth: UIButton!
    @IBOutlet weak var btnFilterThisYear: UIButton!
    @IBOutlet weak var btnFilterLastYear: UIButton!
    @IBOutlet weak var btnFilterThreeYear: UIButton!
    
    @IBOutlet weak var btnFilterAllYear: UIButton!
    @IBOutlet weak var lbl_total_revenue: UILabel!
    @IBOutlet weak var root_view_point: UIView!


    @IBOutlet weak var height_of_root_view_point: NSLayoutConstraint!
    
    @IBOutlet weak var view_block: UIView!
    
    var lineChartItems = [ChartDataEntry]()
    var btnArray:[UIButton] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self)
        registerCellAndBindtable()
        
        if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_FIVE){
            self.getCurrentPoint(employee_id: ManageCacheObject.getCurrentUser().id)
        }
        
 
        btnArray = [btnFilterToday, btnFilterYesterday, btnFilterThisweek, btnFilterThismonth, btnFilterLastmonth, btnFilterThreeMonth, btnFilterThisYear, btnFilterLastYear, btnFilterThreeYear,btnFilterAllYear]

        Utils.changeBgBtn(btn: btnFilterToday, btnArray: btnArray)
        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
            }).disposed(by: rxbag)
            
            if btn.tag == viewModel.report.value.reportType{
               Utils.changeBgBtn(btn: btn, btnArray: btnArray)
            }
        }
        
        reportRevenueByTime()
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view_block.isHidden = permissionUtils.GPBH_2_o_3 && Utils.checkRoleOwner(permission: ManageCacheObject.getCurrentUser().permissions) ? false : true
        lbl_target_point.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_target_point))
        lbl_target_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_bonus_salary))
        lbl_branch_name.text = ManageCacheObject.getCurrentBranch().name
        lbl_branch_address.text = ManageCacheObject.getCurrentBranch().address
        
        avatar_branch.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: ManageCacheObject.getSetting().branch_info.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
    }
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        var report = viewModel.report.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.report.accept(report)
        reportRevenueByTime()
    }

}

