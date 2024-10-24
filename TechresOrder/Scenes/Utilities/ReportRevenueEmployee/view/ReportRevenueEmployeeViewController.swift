//
//  ReportRevenueEmployeeViewController.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 09/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import Charts
import RxRelay

class ReportRevenueEmployeeViewController: BaseViewController {
    
    var viewModel = ReportRevenueEmployeeViewModel()
    var router = ReportRevenueEmployeeRouter()

    
    @IBOutlet weak var bar_chart: BarChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var root_view_empty_data: UIView!
    
    @IBOutlet weak var lbl_total_amout: UILabel!
    @IBOutlet weak var lbl_title_report: UILabel!
    
    // MARK: Biến của button filter
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet weak var btn_yesterday: UIButton!
    @IBOutlet weak var btn_this_week: UIButton!
    @IBOutlet weak var btn_this_month: UIButton!
    @IBOutlet weak var btn_last_month: UIButton!
    @IBOutlet weak var btn_last_three_month: UIButton!
    @IBOutlet weak var btn_this_year: UIButton!
    @IBOutlet weak var btn_last_year: UIButton!
    @IBOutlet weak var btn_last_three_year: UIButton!
    @IBOutlet weak var btn_all_year: UIButton!
    

    var btnArray:[UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        
        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]

        
        actionChooseReportType(btn_this_month)
        registerCellAndBindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportRevenueEmployee()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        router.navigatePopViewController()
    }
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        var report = viewModel.report.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.report.accept(report)
        self.getReportRevenueEmployee()
        
        Utils.changeBgBtn(btn: sender, btnArray: btnArray)
    }
    
   
}
    
