//
//  RevenueReportByTime+Extensions.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 04/02/2023.
//

import UIKit
import ObjectMapper

extension GenerateReportViewController{

    //MARK: TODAY
    func reportRevenueTodayByBranch(){

        viewModel.reportRevenueActivities().subscribe(onNext: { [self] (response) in
       
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<DailyOrderReport>().map(JSONObject: response.data) {
                    report.dateString = viewModel.dailyOrderReport.value.dateString
                    report.reportType = viewModel.dailyOrderReport.value.reportType
                    self.viewModel.dailyOrderReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }

        }).disposed(by: rxbag)
    }
    
    
    
    //MARK: FoodApp
    func reportOfFoodApp(){

        viewModel.reportOfFoodApp().subscribe(onNext: { [self] (response) in
       
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodAppReport>().map(JSONObject: response.data) {
                    report.dateString = viewModel.foodAppReport.value.dateString
                    report.reportType = viewModel.foodAppReport.value.reportType
                    viewModel.foodAppReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }

        }).disposed(by: rxbag)
    }


        
    //MARK: Today
    func reportRevenueTodayByTime(){
        viewModel.reportRevenueByTime().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<RevenueReport>().map(JSONObject: response.data) {
                    report.dateString = viewModel.toDayRenueReport.value.dateString
                    report.reportType = viewModel.toDayRenueReport.value.reportType
                    self.viewModel.toDayRenueReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    //MARK: báo cáo bán hàng
    func getSaleReport(){
        viewModel.getReportRevenueGenral().subscribe(onNext: { [self] (response) in
           if(response.code == RRHTTPStatusCode.ok.rawValue){
               if var reportData = Mapper<SaleReport>().map(JSONObject: response.data) {
                   //lưu lại reportType và dateString
                   reportData.reportType = viewModel.saleReport.value.reportType
                   reportData.dateString = viewModel.saleReport.value.dateString
                   reportData.fromDate = viewModel.saleReport.value.fromDate
                   viewModel.saleReport.accept(reportData)
               }
           }else{
               dLog(response.message ?? "")
           }
           
       }).disposed(by: rxbag)
    }
    
    
    
    //MARK: báo cao doanh thu chi phí lợi nhuận
    func getRevenueCostProfitReport(){
        viewModel.reportRevenueCostProfit().subscribe(onNext: { (response) in
           if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<RevenueFeeProfitReport>().map(JSONObject: response.data) {
//                    //lưu lại reportType và dateString
                    report.reportType = self.viewModel.revenueCostProfitReport.value.reportType
                    report.dateString = self.viewModel.revenueCostProfitReport.value.dateString
                    self.viewModel.revenueCostProfitReport.accept(report)
                }
           }else{
               dLog(response.message ?? "")
           }
        
       }).disposed(by: rxbag)
    }
    

    
    //MARK: báo cáo doanh thu khu vực
    func getReportRevenueArea(){
        viewModel.getReportRevenueArea().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<AreaRevenueReport>().map(JSONObject: response.data) {
                    report.reportType = viewModel.areaRevenueReport.value.reportType
                    report.dateString = viewModel.areaRevenueReport.value.dateString
                    viewModel.areaRevenueReport.accept(report)
                }
            }else{
                Toast.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", controller: self)
            }
        }).disposed(by: rxbag)
    }
    
    //MARK: báo cáo doanh thu Bàn
     func getReportTableRevenue(){
        viewModel.getReportTableRevenue().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<TableRevenueReport>().map(JSONObject: response.data) {
                    
                    report.reportType = viewModel.tableRevenueReport.value.reportType
                    report.dateString = viewModel.tableRevenueReport.value.dateString
                    report.tableRevenueReportData.sort(by: {$0.revenue > $1.revenue})
                    report.tableRevenueReportData = Array(report.tableRevenueReportData.prefix(10))
                    viewModel.tableRevenueReport.accept(report)
                    
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    //MARK: báo cáo doanh thu nhân viên
    func getReportRevenueEmployee(){
        viewModel.getReportEmployee().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<EmployeeRevenueReport>().map(JSONObject: response.data) {
                    report.reportType = viewModel.employeeRevenueReport.value.reportType
                    report.dateString = viewModel.employeeRevenueReport.value.dateString
                    viewModel.employeeRevenueReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    //MARK: báo cáo danh thu bán hàng món ăn
    func getRevenueReportByFood(){
        viewModel.is_goods.accept(0)
        viewModel.food_id.accept(ALL)
        viewModel.category_types.accept("1")
        viewModel.getRevenueReportByFood().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {
                    report.reportType = viewModel.foodReport.value.reportType
                    report.dateString = viewModel.foodReport.value.dateString
                    report.filterType = viewModel.foodReport.value.filterType

                    report.foods.sort{$0.total_amount > $1.total_amount}
                    viewModel.foodReport.accept(report)
                }
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
        }).disposed(by: rxbag)
    }
    
    //MARK: báo cáo danh thu bán hàng hàng hoá
    func getRevenueReportCommodity(){
        viewModel.is_goods.accept(1)
        viewModel.food_id.accept(-1)
        viewModel.getRevenueReportCommodity().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {
                    report.dateString = viewModel.commodityReport.value.dateString
                    report.reportType = viewModel.commodityReport.value.reportType
                    report.filterType = viewModel.commodityReport.value.filterType
                    report.foods.sort{$0.total_amount > $1.total_amount}
                    viewModel.commodityReport.accept(report)
                }
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
        }).disposed(by: rxbag)
    }
    
    
    //MARK: báo cáo danh mục
    func getCategoryReport(){
        viewModel.reportRevenueByCategory().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<RevenueCategoryReport>().map(JSONObject: response.data) {
                    report.dateString = viewModel.categoryRevenueReport.value.dateString
                    report.reportType = viewModel.categoryRevenueReport.value.reportType
                    report.filterType = viewModel.categoryRevenueReport.value.filterType
                    viewModel.categoryRevenueReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    func getGiftedFoodReport(){

        viewModel.getGiftedFoodReport().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {
                    report.dateString = viewModel.giftedFoodReport.value.dateString
                    report.reportType = viewModel.giftedFoodReport.value.reportType
                    report.filterType = viewModel.giftedFoodReport.value.filterType
                    report.foods.sort{$0.total_amount > $1.total_amount}
                    self.viewModel.giftedFoodReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    //MARK: báo cáo doanh thu món ngoài menu
    func getReportFoodOther(){
        viewModel.category_types.accept("1")
        viewModel.is_goods.accept(0)
        viewModel.food_id.accept(0)
        viewModel.getReportFoodOther().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {
                    report.dateString = viewModel.otherFoodReport.value.dateString
                    report.reportType = viewModel.otherFoodReport.value.reportType
                    report.filterType = viewModel.otherFoodReport.value.filterType
                    report.foods.sort{$0.total_amount > $1.total_amount}
                    self.viewModel.otherFoodReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    //MARK: báo cao doanh thu món huỷ
    func getReportFoodCancel(){
        viewModel.getReportFoodCancel().subscribe(onNext: {[self](response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {
                    //lưu lại reportType và dateString
                    report.reportType = viewModel.cancelFoodReport.value.reportType
                    report.dateString = viewModel.cancelFoodReport.value.dateString
                    report.filterType = viewModel.cancelFoodReport.value.filterType
                    report.foods.sort{$0.total_amount > $1.total_amount}
                    viewModel.cancelFoodReport.accept(report)

                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    //MARK: BÁO CÁO MÓN MÓN MANG VỀ
    func getReportTakeAwayFood(){

        viewModel.getReportTakeAwayFood().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {

                    //lưu lại reportType và dateString
                    report.reportType = viewModel.takeAwayFoodReport.value.reportType
                    report.dateString = viewModel.takeAwayFoodReport.value.dateString
                    report.filterType = viewModel.takeAwayFoodReport.value.filterType
                    report.foods.sort{$0.total_amount > $1.total_amount}
                    viewModel.takeAwayFoodReport.accept(report)

                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    //MARK: báo cao doanh thu VAT
    func getVATReport(){
        viewModel.getReportVAT().subscribe(onNext: {[self](response) in
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
    //MARK: báo cao doanh thu các món giảm giá
    func getdiscountReport(){
        viewModel.getdiscountReport().subscribe(onNext: {[self] (response) in
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
    
    //MARK: báo cao doanh thu phụ thu
    func getReportSurcharge(){
        viewModel.getReportSurcharge().subscribe(onNext: {[self](response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<SurchargeReport>().map(JSONObject: response.data) {
                    report.reportType = viewModel.surchargeReport.value.reportType
                    report.dateString = viewModel.surchargeReport.value.dateString
                    viewModel.surchargeReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    

}



