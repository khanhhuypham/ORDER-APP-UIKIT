//
//  ReportOtherFoodViewController.swift
//  Techres-Seemt
//
//  Created by Nguyen Thanh Vinh on 09/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import Charts
import RxRelay
import ObjectMapper
class ReportOtherFoodViewController: BaseViewController {
    
//    var viewModel = ReportOtherFoodViewModel()
//    var router = ReportOtherFoodRouter()
//    public var report_type_food_select:Int = 0
    
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
    var viewModel: ReportBusinessViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        registerCellAndBindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]

        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
            }).disposed(by: rxbag)
            
            if btn.tag == viewModel?.otherFoodReport.value.reportType{
                Utils.changeBgBtn(btn: btn, btnArray: self.btnArray)
            }
        }
        getReportFoodOther()
    }

    

    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var report = viewModel.otherFoodReport.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.otherFoodReport.accept(report)
        getReportFoodOther()
    }
    
}
 
//MARK: REGISTER CELL TABLE VIEW
extension ReportOtherFoodViewController {
    func registerCellAndBindTableView(){
        registerCell()
        bindTableView()
    }
    
    private func registerCell() {
        let foodItemReportOtherFoodTableViewCell = UINib(nibName: "FoodItemReportOtherFoodTableViewCell", bundle: .main)
        tableView.register(foodItemReportOtherFoodTableViewCell, forCellReuseIdentifier: "FoodItemReportOtherFoodTableViewCell")

        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.rx.setDelegate(self).disposed(by: rxbag)
    }
    
    private func bindTableView() {
        guard let viewModel = self.viewModel else {return}
        viewModel.otherFoodReport.map{$0.foods}.bind(to: tableView.rx.items(cellIdentifier: "FoodItemReportOtherFoodTableViewCell", cellType: FoodItemReportOtherFoodTableViewCell.self))
           {  (row, data, cell) in
               cell.index = row + 1
               cell.data = data
           }.disposed(by: rxbag)
    }
}

extension ReportOtherFoodViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


extension ReportOtherFoodViewController {
    func getReportFoodOther(){
        guard let viewModel = self.viewModel else {return}
        
        viewModel.getReportFoodOther().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {
                    
                    report.reportType = viewModel.otherFoodReport.value.reportType
                    report.dateString = viewModel.otherFoodReport.value.dateString
                    setupBarChart(data: report.foods, barChart: bar_chart)
                    viewModel.otherFoodReport.accept(report)
                    
                    lbl_total_amout.text = report.total_amount.toString
                    root_view_empty_data.isHidden = report.total_amount > 0 ? true : false
                }
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
        }).disposed(by: rxbag)
    }
}

//MARK: CHART HANDLER....
extension ReportOtherFoodViewController {
    func setupBarChart(data:[FoodReport],barChart:BarChartView){
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_amount))},
            xLabel: data.enumerated().map{(i,value) in String(i + 1)}
        )

        barChart.isUserInteractionEnabled = true
        // calculate the required height for the chart based on the number of labels and their rotated height
        let labelHeight = barChart.xAxis.labelRotatedHeight // use the rotated label height
        let labelRotationAngle = CGFloat(barChart.xAxis.labelRotationAngle) * .pi / 180 // convert the rotation angle to radians
        let chartHeight = barChart.frame.origin.y + (CGFloat(barChart.xAxis.labelCount) * labelHeight * abs(cos(labelRotationAngle))) // use the rotated height and the cosine of the rotation angle
        // resize the height of the chart view
        barChart.frame.size.height = chartHeight
    }
}
