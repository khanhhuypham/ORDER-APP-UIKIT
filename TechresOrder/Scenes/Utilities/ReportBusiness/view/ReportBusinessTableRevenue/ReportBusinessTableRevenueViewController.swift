//
//  ReportBusinessTableRevenueViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/08/2023.
//

import UIKit
import Charts
import ObjectMapper
import RxSwift
import RxRelay
class ReportBusinessTableRevenueViewController: BaseViewController {
    
    
    
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
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var view_no_data: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var total_amount: UILabel!
    
    @IBOutlet weak var height_of_pie_chart: NSLayoutConstraint!
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    var colors = [UIColor]()
    var btnArray:[UIButton] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
//        changeBgBtn(btn: btn_this_month)
//        for btn in self.btnArray{
//            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
//                self?.changeBgBtn(btn: btn)
//            }).disposed(by: rxbag)
//            if btn.tag == viewModel?.tableRevenueReport.value.reportType{
//                changeBgBtn(btn: btn)
//            }
//        }
        
        Utils.changeBgBtn(btn: btn_this_month, btnArray: btnArray)
        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
            }).disposed(by: rxbag)
            
            if btn.tag == viewModel?.tableRevenueReport.value.reportType{
                Utils.changeBgBtn(btn: btn, btnArray: btnArray)
            }
        }
        
        registerCell()
        bindTableViewData()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportTableRevenue()
    }
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var report = viewModel.tableRevenueReport.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.tableRevenueReport.accept(report)
        getReportTableRevenue()
    }
    
   
    
    var viewModel: ReportBusinessViewModel?
}


//MARK: -- CALL API
extension ReportBusinessTableRevenueViewController{
  
    private func getReportTableRevenue(){
        guard let viewModel = self.viewModel else {return}
        viewModel.getReportTableRevenue().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<TableRevenueReport>().map(JSONObject: response.data) {
                    report.reportType = viewModel.tableRevenueReport.value.reportType
                    report.dateString = viewModel.tableRevenueReport.value.dateString
                    viewModel.tableRevenueReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
}


extension ReportBusinessTableRevenueViewController{
   
    private func registerCell(){
        let reportBusinessTableRevenueTableViewCell = UINib(nibName: "ReportBusinessTableRevenueTableViewCell", bundle: .main)
        tableView.register(reportBusinessTableRevenueTableViewCell, forCellReuseIdentifier: "ReportBusinessTableRevenueTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        
    }

    private func bindTableViewData() {
        guard let viewModel = self.viewModel else {return}

        viewModel.tableRevenueReport.subscribe(onNext: { [self] report in
            
            colors = report.tableRevenueReportData.enumerated().map{_ in ColorUtils.random()}
            
            setPieChart(piechart:pieChart,report: report)
            setupBarChart(barChart:barChart,data: report.tableRevenueReportData)

            total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue)
            view_no_data.isHidden = report.tableRevenueReportData.count > 0 ? true : false


          }).disposed(by: rxbag)
        
        
        viewModel.tableRevenueReport.map{$0.tableRevenueReportData}.bind(to: tableView.rx.items(cellIdentifier: "ReportBusinessTableRevenueTableViewCell", cellType: ReportBusinessTableRevenueTableViewCell.self))
        {(row, data, cell) in
            cell.data = data
            cell.lbl_percent.textColor = self.colors[row]
            if self.viewModel?.tableRevenueReport.value.total_revenue != 0 && data.revenue != 0 {
                cell.lbl_percent.text = String(format: "%.2f%%", Double(data.revenue)/Double(self.viewModel?.tableRevenueReport.value.total_revenue ?? 1)*100)
            }else {
                cell.lbl_percent.text = String(format: "%.2f", 0.0)
            }
            cell.lbl_number.backgroundColor = self.colors[row]
            cell.lbl_number.text = String(row + 1)
            self.height_of_table.constant = self.tableView.contentSize.height
        }.disposed(by: rxbag)
        
    }
    

    private func setupBarChart(barChart:BarChartView,data:[TableRevenueReportData]){
        
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.revenue))},
            xLabel: data.enumerated().map{(i,_) in String(i+1)},
            color: colors
        )
 

    }
    
    
    
    private func setPieChart(piechart:PieChartView,report: TableRevenueReport) {

        ChartUtils.customPieChart(
            pieChart: pieChart,
            dataEntries: report.tableRevenueReportData.enumerated().map{(i,value) in PieChartDataEntry(value: Double(value.revenue),label: String(i+1))},
            colors: colors,
            holeEnable: true
        )
        

    }
    

    
}


