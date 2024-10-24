//
//  ReportRevenueTableTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/09/2023.
//

import UIKit
import Charts
import RxRelay
import RxSwift
class ReportRevenueTableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pie_chart: PieChartView!
    @IBOutlet weak var bar_chart: BarChartView!
    var pieChartItems = [PieChartDataEntry]()
        
    var colors = ColorUtils.chartColors()
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewArea: UITableView!
    @IBOutlet weak var root_view_empty_data: UIView!
    @IBOutlet weak var height_table_view: NSLayoutConstraint!
    @IBOutlet weak var height_of_view_wrap: NSLayoutConstraint!
    
    // MARK: Biến của button filter
    
    @IBOutlet weak var scroll_view: UIScrollView!
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
    
    @IBOutlet weak var stack_view: UIStackView!
    var btnArray:[UIButton] = []
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let areaItemRevenueTableViewCell = UINib(nibName: "TableItemRevenueTableViewCell", bundle: .main)
        tableView.register(areaItemRevenueTableViewCell, forCellReuseIdentifier: "TableItemRevenueTableViewCell")
        
        
        let cellReportRevenueAreaListItem = UINib(nibName: "CellReportRevenueTableTableViewCell", bundle: .main)
        tableViewArea.register(cellReportRevenueAreaListItem, forCellReuseIdentifier: "CellReportRevenueTableTableViewCell")
        tableViewArea.isScrollEnabled = false
        tableViewArea.rowHeight = 50
        tableViewArea.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        // Configure the view for the selected state
    }
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        
        guard let viewModel = self.viewModel else {return}
        var report = viewModel.tableRevenueReport.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.tableRevenueReport.accept(report)
        self.viewModel?.view?.getReportTableRevenue()
    }
 
    var viewModel: GenerateReportViewModel? {
           didSet {
               guard let viewModel = self.viewModel else {return}
               btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
      
               Utils.changeBgBtn(btn: btn_this_month, btnArray: btnArray)
               for btn in self.btnArray{
                   btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                       Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
                   }).disposed(by: disposeBag)
    
                   if btn.tag == viewModel.tableRevenueReport.value.reportType{
                       Utils.changeBgBtn(btn: btn, btnArray: btnArray)
                   }
               }
               
               var total_revenue_amount = 0
               viewModel.tableRevenueReport.subscribe(onNext: { [self] report in
                   lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue)
                   root_view_empty_data.isHidden = report.tableRevenueReportData.count > 0 ? true : false
                   
                   colors = report.tableRevenueReportData.map{_ in ColorUtils.random()}
                   setupBarChart(data: report.tableRevenueReportData, barChart: bar_chart)
                   setRevenueAreaPieChart(dataChart: report.tableRevenueReportData)
                   total_revenue_amount = report.total_revenue
                   
                   height_table_view.constant = CGFloat(report.tableRevenueReportData.count*50 + 520)
                   height_of_view_wrap.constant = CGFloat(report.tableRevenueReportData.count*50 + 520)
                   
                 }).disposed(by: disposeBag)

               viewModel.tableRevenueReport.map{$0.tableRevenueReportData}.bind(to: tableView.rx.items){ [self] (tableView, index, element) in
                   let cell = tableView.dequeueReusableCell(withIdentifier: "TableItemRevenueTableViewCell") as! TableItemRevenueTableViewCell
                   cell.back_ground_index.backgroundColor = self.colors[index]
                   cell.lbl_index.text = String(index + 1)
                   cell.data = element
                   return cell
               }.disposed(by: disposeBag)
               
               viewModel.tableRevenueReport.map{$0.tableRevenueReportData}.bind(to: tableViewArea.rx.items){ [self] (tableView, index, element) in
                   let cell = tableView.dequeueReusableCell(withIdentifier: "CellReportRevenueTableTableViewCell") as! CellReportRevenueTableTableViewCell
                   cell.view_color_area.backgroundColor = self.colors[index]
                   cell.lbl_percent_area.textColor = self.colors[index]
                   cell.totalAmountRevenueArea = total_revenue_amount
                   cell.lbl_index_area.text = String(index + 1)
                   cell.data = element
                   return cell
               }.disposed(by: disposeBag)
           }
    }
    
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToTableReportViewController()
    }
}

extension ReportRevenueTableTableViewCell {
        
    func setRevenueAreaPieChart(dataChart: [TableRevenueReportData]) {
        
        ChartUtils.customPieChart(
            pieChart: pie_chart,
            dataEntries: dataChart.enumerated().map{(i,value) in PieChartDataEntry(value: Double(value.revenue),label:"")},
            colors: colors,
            holeEnable: true
        )
        pie_chart.legend.enabled = false
        
    }
    
    func setupBarChart(data:[TableRevenueReportData],barChart:BarChartView){
        
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.revenue))},
            xLabel: data.map{$0.table_name},
            color: colors
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
