//
//  ReportBusinessAnalyticsViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 25/02/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import RxRelay

//MARK: -- CALL API
extension ReportBusinessAnalyticsViewController {
    func getCategoriesManagement(){
        viewModel.getCategories().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let categories = Mapper<Category>().mapArray(JSONObject: response.data) {
                    if(categories.count > 0){
                        self.cates = categories
                        self.viewPager.reloadData()
                        self.viewModel.date_string.accept(self.dateTimeNow)
                        self.checkFilterSelected(view_selected: self.view_filter_today, textTitle: self.lbl_filter_today)
                        // gọi API lấy dữ liệu hôm nay
                        self.viewModel.date_string.accept(self.dateTimeNow)
                        self.viewModel.report_type.accept(REPORT_TYPE_TODAY)
                    }
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}
extension ReportBusinessAnalyticsViewController{
    @IBAction func actionFilterToday(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_today, textTitle: self.lbl_filter_today)
        self.viewModel.date_string.accept(dateTimeNow)
        self.viewModel.report_type.accept(REPORT_TYPE_TODAY)
    }
    
    @IBAction func actionFilterYesterday(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_yesterday, textTitle: self.lbl_filter_yesterday)
       
        self.viewModel.date_string.accept(yesterday)
        self.viewModel.report_type.accept(REPORT_TYPE_YESTERDAY)
    }
    
    @IBAction func actionFilterThisWeek(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_thisweek, textTitle: self.lbl_filter_thisweek)
        self.viewModel.date_string.accept(thisWeek)
        self.viewModel.report_type.accept(REPORT_TYPE_THIS_WEEK)
    }
    
    @IBAction func actionFilterLastMonth(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_last_month, textTitle: self.lbl_filter_last_month)
      
        self.viewModel.date_string.accept(lastMonth)
        self.viewModel.report_type.accept(REPORT_TYPE_LAST_MONTH)
    }
    
    @IBAction func actionFilterThisMonth(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_this_month, textTitle: self.lbl_filter_this_month)
      
        self.viewModel.date_string.accept(currentMonth)
        self.viewModel.report_type.accept(REPORT_TYPE_THIS_MONTH)
    }
    
    @IBAction func actionFilterThreeMonth(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_three_month, textTitle: self.lbl_filter_three_month)
       
        self.viewModel.date_string.accept(lastThreeMonth)
        self.viewModel.report_type.accept(REPORT_TYPE_THREE_MONTHS)
    }
    
    @IBAction func actionFilterThisYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_this_year, textTitle: self.lbl_filter_this_year)
       
        self.viewModel.date_string.accept(currentYear)
        self.viewModel.report_type.accept(REPORT_TYPE_THIS_YEAR)
    }
    
    @IBAction func actionFilterLastYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_last_year, textTitle: self.lbl_filter_last_year)
        self.viewModel.date_string.accept(lastYear)
        self.viewModel.report_type.accept(REPORT_TYPE_LAST_YEAR)
    }
    
    @IBAction func actionFilterThreeYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_three_year, textTitle: self.lbl_filter_three_year)
        self.viewModel.report_type.accept(REPORT_TYPE_THREE_YEAR)
        self.viewModel.date_string.accept(lastThreeYear)
//        self.reportRevenueByTime()
    }
    
    
    @IBAction func actionFilterAllYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_all_year, textTitle: self.lbl_filter_all_year)
        self.viewModel.date_string.accept(currentYear)
        self.viewModel.report_type.accept(REPORT_TYPE_ALL_YEAR)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.viewModel.makePopViewController()
    }
    
    func getCurentTime(){
        yesterday = Utils.getYesterdayString()
        dateTimeNow = Utils.getCurrentDateString()
        thisWeek = Utils.getCurrentWeekString()
        lastThreeMonth = Utils.getLastThreeMonthString()
        lastMonth = Utils.getLastMonthString()
        currentMonth = Utils.getCurrentMonthString()
        lastThreeYear = Utils.getLastThreeYearString()
        lastYear = Utils.getLastYearString()
        currentYear = Utils.getCurrentYearString()
//        let date = Date()
//        let calendar = Calendar.current
//        let month = calendar.component(.month, from: date)
//        let year = calendar.component(.year, from: date)
//        self.Week = calendar.component(.weekOfYear, from: date)
//        //Tuần này
//        self.thisWeek = String(format: "%d/%d", self.Week, year)
//        if self.thisWeek.count == 6 {
//            self.thisWeek = String(format: "0%d/%d", self.Week, year)
//        }
//        //Thang nay
//        self.monthCurrent = String(format: "%d/%d", month, year)
//        //
//        let tm = Calendar.current.date(byAdding: .month, value: 0, to: Date())
//        let tmFormatter : DateFormatter = DateFormatter()
//        tmFormatter.dateFormat = "MM/yyyy"
//        self.thisMonth = tmFormatter.string(from: tm!)
//
//        //Tháng trước
//        let lm = Calendar.current.date(byAdding: .month, value: -1, to: Date())
//        let monthFormatter : DateFormatter = DateFormatter()
//        monthFormatter.dateFormat = "MM/yyyy"
//        self.lastMonth = monthFormatter.string(from: lm!)
//        //Nam nay
//        self.yearCurrent = String(year)
//        //Nam truoc
//        let ly = Calendar.current.date(byAdding: .year, value: -1, to: Date())
//        let yearFormatter : DateFormatter = DateFormatter()
//        yearFormatter.dateFormat = "yyyy"
//        self.lastYear = yearFormatter.string(from: ly!)
//
//        //
//        let format = DateFormatter()
//        format.dateFormat = "dd/MM/YYYY"
//        let formattedDate = format.string(from: date)
//        self.dateTimeNow = formattedDate
//
//        //Hôm nay
//        let formatTime = DateFormatter()
//        formatTime.dateFormat = "HH:mm:ss"
//
//        today = formatTime.string(from: date)
//
//        //        lblCurrentTime.text = formatTime.string(from: date)
//        //Hôm qua
//        let y = Calendar.current.date(byAdding: .day, value: -1, to: Date())
//        let dateFormatter : DateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        self.yesterday = dateFormatter.string(from: y!)
        
    }
    
    func checkFilterSelected(view_selected:UIView, textTitle:UILabel){
        view_filter_today.backgroundColor = .white
        view_filter_yesterday.backgroundColor = .white
        view_filter_thisweek.backgroundColor = .white
        view_filter_last_month.backgroundColor = .white
        view_filter_this_month.backgroundColor = .white
        view_filter_three_month.backgroundColor = .white
        view_filter_this_year.backgroundColor = .white
        view_filter_last_year.backgroundColor = .white
        view_filter_three_year.backgroundColor = .white
        view_filter_all_year.backgroundColor = .white
        
        lbl_filter_today.textColor = ColorUtils.main_color()
        lbl_filter_yesterday.textColor = ColorUtils.main_color()
        lbl_filter_thisweek.textColor = ColorUtils.main_color()
        lbl_filter_last_month.textColor = ColorUtils.main_color()
        lbl_filter_this_month.textColor = ColorUtils.main_color()
        lbl_filter_three_month.textColor = ColorUtils.main_color()
        lbl_filter_this_year.textColor = ColorUtils.main_color()
        lbl_filter_last_year.textColor = ColorUtils.main_color()
        lbl_filter_three_year.textColor = ColorUtils.main_color()
        lbl_filter_all_year.textColor = ColorUtils.main_color()
        textTitle.textColor = ColorUtils.white()
        view_selected.backgroundColor = ColorUtils.main_color()
    }
    
}
