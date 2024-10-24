//
//  ReportBusinessFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 07/03/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import Charts
import RxRelay
import RxCocoa
class ReportBusinessDiscountViewController: BaseViewController {
    
    
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
    

    
    @IBOutlet weak var line_chart_view: LineChartView!
    
    @IBOutlet weak var view_no_data: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var total_amount: UILabel!
    
    var lineChartItems = [ChartDataEntry]()
    var btnArray:[UIButton] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view_no_data.isHidden = true
        // Do any additional setup after loading the view.
        registerCell()
        bindTableViewData()
        
        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
        
        Utils.changeBgBtn(btn: btn_this_month, btnArray: btnArray)
        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
            }).disposed(by: rxbag)
            
            if btn.tag == viewModel?.discountReport.value.reportType{
                Utils.changeBgBtn(btn: btn, btnArray: btnArray)
            }
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportDiscountedFood()
    }
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var report = viewModel.discountReport.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        report.discountReportData = []
        viewModel.discountReport.accept(report)
        getReportDiscountedFood()
    }
    
    var viewModel: ReportBusinessViewModel?
}

//MARK: -- CALL API
extension ReportBusinessDiscountViewController{
   
    private func getReportDiscountedFood(){
        guard let viewModel = self.viewModel else {return}
        viewModel.getReportDiscountedFood().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<DiscountReport>().map(JSONObject: response.data) {
                    report.reportType = viewModel.discountReport.value.reportType
                    report.dateString = viewModel.discountReport.value.dateString
                    viewModel.discountReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
}



extension ReportBusinessDiscountViewController:UITableViewDelegate{
   
    private func registerCell(){
        let reportBusinessDiscountTableViewCell = UINib(nibName: "ReportBusinessDiscountTableViewCell", bundle: .main)
        tableView.register(reportBusinessDiscountTableViewCell, forCellReuseIdentifier: "ReportBusinessDiscountTableViewCell")
        tableView.rx.setDelegate(self).disposed(by: rxbag)
    }

    private func bindTableViewData() {
        guard let viewModel = self.viewModel else {return}
        
        viewModel.discountReport.subscribe(onNext: { [self] report in
            total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_amount)
            if report.discountReportData.count > 0{setupLineChart(data: report.discountReportData,reportType: report.reportType)}
            view_no_data.isHidden = report.discountReportData.count > 0 ? true : false
            
        }).disposed(by: rxbag)
        
        viewModel.discountReport.map{$0.discountReportData}.bind(to: tableView.rx.items(cellIdentifier: "ReportBusinessDiscountTableViewCell", cellType: ReportBusinessDiscountTableViewCell.self))
        { [self](row, discount, cell) in
            cell.lbl_name.text = ChartUtils.getXLabel(dateTime: discount.report_time, reportType: viewModel.discountReport.value.reportType, dataPointnth: row)
            cell.data = discount
        }.disposed(by: rxbag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    private func setupLineChart(data:[DiscountReportData],reportType:Int){
        
        lineChartItems.removeAll()
        lineChartItems = data.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.total_amount))}
    
        let x_label:[String] = data.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)}
        ChartUtils.customLineChart(
            chartView: line_chart_view,
            entries: lineChartItems,
            x_label: x_label,
            labelCount: ChartUtils.setLabelCountForChart(reportType: reportType, totalDataPoint: data.count)
        )

    }
    

}

