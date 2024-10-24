//
//  ReportBusinessAreaRevenueViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/08/2023.
//

import UIKit
import Charts
import ObjectMapper
import RxSwift
class ReportBusinessAreaRevenueViewController: BaseViewController {


    
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
    
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    
    @IBOutlet weak var height_of_pie_chart: NSLayoutConstraint!
    var btnArray:[UIButton] = []
    var colors = [UIColor]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view_no_data.isHidden = true // Thêm view no data trong
       
        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]

        Utils.changeBgBtn(btn: btn_this_month, btnArray: btnArray)
        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
            }).disposed(by: rxbag)
            
            if btn.tag == viewModel?.areaRevenueReport.value.reportType{
                Utils.changeBgBtn(btn: btn, btnArray: btnArray)
            }
        }
        registerCell()
        bindTableViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportAreaRevenue()
    }
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var report = viewModel.areaRevenueReport.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        report.areaRevenueReportData = []
        viewModel.areaRevenueReport.accept(report)
        getReportAreaRevenue()
    }
    
  
    var viewModel: ReportBusinessViewModel?
}


//MARK: -- CALL API
extension ReportBusinessAreaRevenueViewController{
  
    private func getReportAreaRevenue(){
        guard let viewModel = viewModel else {return}
        
        viewModel.getReportAreaRevenue().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<AreaRevenueReport>().map(JSONObject: response.data) {
                    report.reportType = viewModel.areaRevenueReport.value.reportType
                    report.dateString = viewModel.areaRevenueReport.value.dateString
                    viewModel.areaRevenueReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
}


extension ReportBusinessAreaRevenueViewController{
   
    private func registerCell(){
        let reportBusinessAreaRevenueTableViewCell = UINib(nibName: "ReportBusinessAreaRevenueTableViewCell", bundle: .main)
        tableView.register(reportBusinessAreaRevenueTableViewCell, forCellReuseIdentifier: "ReportBusinessAreaRevenueTableViewCell")
        tableView.rowHeight = 50
        tableView.isScrollEnabled = false
        
    }

    private func bindTableViewData() {
        
        guard let viewModel = viewModel else {return}

        viewModel.areaRevenueReport.subscribe(onNext: { [self] report in
            
            colors = report.areaRevenueReportData.enumerated().map{_ in ColorUtils.random()}
            
                total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue)
                
            
                view_no_data.isHidden = report.areaRevenueReportData.count > 0 ? true : false
            
            
                setupBarChart(data: report.areaRevenueReportData, barChart: barChart)
                setPieChart(piechart:pieChart,report: report)
                height_of_table.constant = CGFloat(report.areaRevenueReportData.count*50)

          }).disposed(by: rxbag)
        
        
        viewModel.areaRevenueReport.map{$0.areaRevenueReportData}.bind(to: tableView.rx.items(cellIdentifier: "ReportBusinessAreaRevenueTableViewCell", cellType: ReportBusinessAreaRevenueTableViewCell.self))
        { [self](row, data, cell) in
            cell.data = data
            cell.lbl_percent.textColor = self.colors[row]
       
            if self.viewModel?.areaRevenueReport.value.total_revenue != 0  && data.revenue != 0 {
                cell.lbl_percent.text = String(format: "%.2f%%", Double(data.revenue)/Double(self.viewModel?.areaRevenueReport.value.total_revenue ?? 1)*100)
            }else {
                cell.lbl_percent.text = String(format: "%.2f%%", 0.0)
            }
            cell.lbl_area_number.backgroundColor = self.colors[row]
            cell.lbl_area_number.text = String(row + 1)
            dLog(self.tableView.contentSize.height)
        }.disposed(by: rxbag)
        
    }
    
    
    private func setupBarChart(data:[AreaRevenueReportData],barChart:BarChartView){
        
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.revenue))},
            xLabel: data.map{$0.area_name},
            color: colors
        )
    }
    


    private func setPieChart(piechart:PieChartView,report: AreaRevenueReport) {
        
        ChartUtils.customPieChart(
            pieChart: pieChart,
            dataEntries: report.areaRevenueReportData.enumerated().map{(i,value) in PieChartDataEntry(value: Double(value.revenue),label: value.area_name)},
            colors: colors,
            holeEnable: true
        )
    }
    

    
}




