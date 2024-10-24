//
//  UpdateMaterialFee.swift
//  ORDER
//
//  Created by Pham Khanh Huy on 01/07/2023.
//

import UIKit
import JonAlert
import ObjectMapper
extension UpdateMaterialFeeViewController: MaterialDelegate{
    
    
    func presentModalCreateNote() {
        let createNoteViewController = CreateNoteMaterialViewController()
        createNoteViewController.delegate = self
        createNoteViewController.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: createNoteViewController)
        // 1
        nav.modalPresentationStyle = .overCurrentContext


        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {

                // 3
                sheet.detents = [.medium()]

            }
        } else {
            // Fallback on earlier versions
        }
        // 4
        present(nav, animated: true, completion: nil)

    }
    
    
    func callBackNoteDelete(note: String) {
        viewModel.cancel_reason.accept(note)
        viewModel.addition_fee_status.accept(3)
        self.cancelMaterialFee()
        dismiss(animated: true)
        viewModel.makePopViewController()
    }
}
extension UpdateMaterialFeeViewController: DateTimePickerDelegate{
    
    func presentModalCaculatorInputMoneyViewController() {
        let caculatorInputMoneyViewController = CaculatorInputMoneyViewController()
        caculatorInputMoneyViewController.checkMoneyFee = 1000
        caculatorInputMoneyViewController.limitMoneyFee = 1000000000
        caculatorInputMoneyViewController.result = Int(self.viewModel.amount.value)
        caculatorInputMoneyViewController.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: caculatorInputMoneyViewController)
        // 1
        nav.modalPresentationStyle = .overCurrentContext

        
        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                
                // 3
                sheet.detents = [.large()]
                
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
        caculatorInputMoneyViewController.delegate = self

        present(nav, animated: true, completion: nil)

    }
    
    func chooseDate(selectedDate:String){
        
        let selectedDate = convertDateStringToFullDateTime(dateTimeString: selectedDate)
        
        
        let min = selectedDate.addingTimeInterval(-60 * 60 * 24 * 4)
        let max = selectedDate.addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: selectedDate, minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 162.0/255.0, blue: 51.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "CHỌN"
        picker.doneBackgroundColor = UIColor(red: 0.0/255.0, green: 114.0/255.0, blue: 188.0/255.0, alpha: 1)
        picker.locale = Locale(identifier: "vi")

        picker.todayButtonTitle = "Hôm nay"
        picker.is12HourFormat = true
//        picker.dateFormat = "dd/MM/yyyy HH:mm"
//      picker.dateFormat = "dd/MM/YYYY hh:mm"
        picker.dateFormat = "dd/MM/YYYY" //không hiển thị giờ
        picker.isTimePickerOnly = false
        picker.isDatePickerOnly = false
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { [self] date in
            let formatter = DateFormatter()
//            formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            formatter.dateFormat = "dd/MM/yyyy"//không hiển thị giờ
            self.lbl_time.text = formatter.string(from: date)
            viewModel.dateTime.accept(formatter.string(from: date))
        }
        picker.delegate = self
        self.picker = picker
  }
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        dLog(didSelectDate)
    }
    
    private func convertDateStringToFullDateTime(dateTimeString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = dateFormatter.date(from: dateTimeString)
        return date ?? Date()
    }
    
}
extension UpdateMaterialFeeViewController: CalculatorMoneyDelegate{
    func callBackCalculatorMoney(amount: Int, position: Int) {
        self.amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(amount))
        self.viewModel.amount.accept(Int(amount))
        
    }
    
}


//MARK: Call API
extension UpdateMaterialFeeViewController{
    func getMaterialFee(){
        viewModel.getMaterialFee().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                if let fee = Mapper<Fee>().map(JSONObject: response.data) {
                    amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: fee.amount)
                    text_view_note.text = fee.note
                    
                    purpose.text = fee.object_name
                    let feeDate: String = fee.date
                    let feeDateNotHour = feeDate.components(separatedBy: " ")
                    lbl_time.text = feeDateNotHour[0]
                    viewModel.dateTime.accept(fee.date)
                    viewModel.amount.accept(Int(fee.amount))
                    viewModel.note.accept(fee.note)
                    viewModel.type.accept(fee.type)
                    viewModel.is_count_to_revenue.accept(fee.is_count_to_revenue)
                    viewModel.object_name.accept(fee.object_name)
                    viewModel.payment_method_id.accept(fee.payment_method_id)
                    viewModel.addition_fee_status.accept(fee.status)
                    viewModel.addition_fee_reason_type_id.accept(fee.addition_fee_reason_type_id)

                }
            }else{
                JonAlert.showError(message:response.message ?? "Lỗi kết nối server")
            }
            
        })
    }
    
    func cancelMaterialFee(){
        viewModel.cancelMaterialFee().subscribe(onNext: {[self] (response) in

            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Xoá thành công!")
            }else{
                JonAlert.showError(message:response.message ?? "Lỗi kết nối server")
            }
            
        })
    }
    
    func updateMaterialFee(){
        viewModel.updateMaterialFee().subscribe(onNext: {[self] (response) in

            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Lưu thành công")
            }else{
                JonAlert.showError(message:response.message ?? "Lỗi kết nối server")
            }
            
        })
    }
    
}

