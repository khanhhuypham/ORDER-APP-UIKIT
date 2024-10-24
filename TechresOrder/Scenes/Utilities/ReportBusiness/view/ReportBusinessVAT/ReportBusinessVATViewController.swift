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
class ReportBusinessVATViewController: BaseViewController {
    

    
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
    
    @IBOutlet weak var view_no_data: UIView!
    @IBOutlet weak var tableView: UITableView!
    var lineChartItems = [ChartDataEntry]()
    @IBOutlet weak var line_chart_view: LineChartView!
    @IBOutlet weak var total_amount: UILabel!
    var reportType = ""
    var btnArray:[UIButton] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view_no_data.isHidden = true // Thêm view no data trong viewDidload()
        // Do any additional setup after loading the view.
        
        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]

                
        Utils.changeBgBtn(btn: btn_this_month, btnArray: btnArray)
        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
            }).disposed(by: rxbag)
            
            if btn.tag == viewModel?.vatReport.value.reportType{
                Utils.changeBgBtn(btn: btn, btnArray: btnArray)
            }
        }
        
        registerCell()
        bindTableViewData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportVAT()
    }
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var report = viewModel.vatReport.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        report.vatReportData = []
        viewModel.vatReport.accept(report)
        getReportVAT()
    }
    
 

    var viewModel: ReportBusinessViewModel?
 
}

//MARK: -- CALL API
extension ReportBusinessVATViewController{
  
    
    private func getReportVAT(){
        guard let viewModel = self.viewModel else {return}
        viewModel.getReportVAT().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<VATReport>().map(JSONObject: response.data) {
                    //lưu lại reportType và dateString
                    report.reportType = viewModel.vatReport.value.reportType
                    report.dateString = viewModel.vatReport.value.dateString
                    viewModel.vatReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
}

extension ReportBusinessVATViewController:UITableViewDelegate{
   
    private func registerCell(){
        let reportBusinessVATTableViewCell = UINib(nibName: "ReportBusinessVATTableViewCell", bundle: .main)
        tableView.register(reportBusinessVATTableViewCell, forCellReuseIdentifier: "ReportBusinessVATTableViewCell")
        tableView.rx.setDelegate(self).disposed(by: rxbag)
    }

    private func bindTableViewData() {
        
        guard let viewModel = self.viewModel else {return}

        viewModel.vatReport.subscribe(onNext: { [self] report in
            total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.vat_amount)
            if report.vatReportData.count > 0{setupLineChart(data: report.vatReportData,reportType: report.reportType)}
            view_no_data.isHidden = report.vatReportData.count > 0 ? true : false
        }).disposed(by: rxbag)
        
        
        viewModel.vatReport.map{$0.vatReportData}.bind(to: tableView.rx.items(cellIdentifier: "ReportBusinessVATTableViewCell", cellType: ReportBusinessVATTableViewCell.self))
        { [self](row, vat, cell) in
            cell.lbl_name.text = ChartUtils.getXLabel(dateTime: vat.report_time, reportType: viewModel.vatReport.value.reportType, dataPointnth: row)
            cell.data = vat
        }.disposed(by: rxbag)
        

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    

    func setupLineChart(data:[VATReportData],reportType:Int) {

        lineChartItems.removeAll()
        lineChartItems = data.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.vat_amount))}

        var x_label:[String] = data.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)}
        
        ChartUtils.customLineChart(
            chartView: line_chart_view,
            entries: lineChartItems,
            x_label: x_label,
            labelCount: ChartUtils.setLabelCountForChart(reportType: reportType, totalDataPoint: data.count))

        // MARK: Handle click show tooltip
        // Set the extraTopOffset property to add padding
        line_chart_view.extraTopOffset = 30.0 // Adjust the value as per your requirement

    }
    

}


