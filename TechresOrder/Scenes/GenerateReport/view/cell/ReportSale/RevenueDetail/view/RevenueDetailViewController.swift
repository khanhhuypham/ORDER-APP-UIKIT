//
//  RevenueDetailViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 05/02/2023.
//

import UIKit
import Charts
import Kingfisher
class RevenueDetailViewController: BaseViewController {
    var viewModel = RevenueDetailViewModel()
    var router = RevenueDetailRouter()
    var saleReport = SaleReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow)
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_revenue_title: UILabel!
    @IBOutlet weak var lbl_branch_name: UILabel!
    @IBOutlet weak var lbl_branch_address: UILabel!
    @IBOutlet weak var avatar_branch: UIImageView!
    
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
    
    @IBOutlet weak var lbl_total_revenue: UILabel!
    

    var lineChartItems = [ChartDataEntry]()
    var btnArray:[UIButton] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        viewModel.saleReport.accept(saleReport)
    
        
        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
        
        
        for btn in self.btnArray{
            if btn.tag == viewModel.saleReport.value.reportType{
                actionChooseReportType(btn)
            }
        }

        registerCell()
        bindTableView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbl_branch_name.text = ManageCacheObject.getCurrentBranch().name
        lbl_branch_address.text = ManageCacheObject.getCurrentBranch().address

        avatar_branch.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: ManageCacheObject.getCurrentBranch().image_logo )), placeholder: UIImage(named: "image_defauft_medium"))
        
        reportRevenueByTime()
    }
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        var report = viewModel.saleReport.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        report.saleReportData = []
        viewModel.saleReport.accept(report)
        reportRevenueByTime()
       
        if sender.tag == REPORT_TYPE_ALL_YEAR || sender.tag == REPORT_TYPE_THREE_MONTHS || sender.tag == REPORT_TYPE_THREE_YEAR{
            lbl_revenue_title.text = String(format: "DOANH THU %@", sender.titleLabel?.text?.uppercased() ?? "" )
        }else{
            lbl_revenue_title.text = String(format: "DOANH THU %@ | %@", sender.titleLabel?.text?.uppercased() ?? "",report.dateString)
        }
        Utils.changeBgBtn(btn: sender, btnArray: btnArray)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
}
