//
//  ServicePopupViewController + extension + APi.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/11/2023.
//

import UIKit
import JonAlert
extension ServicePopupViewController {
    func updateService(){
        viewModel.updateService().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Cập nhật thành công", duration: 2.0)
//                self.delegate?.callBack()
                self.dismiss(animated: true, completion: {
                    (self.completion ?? {})()
                })
            }else{
                dLog(response.message ?? "")
                self.showErrorMessage(content: response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }

}


extension ServicePopupViewController{
    
    func showCalendar(dateString:String){
        let selectedDate = convertDateStringToDate(dateString: dateString)
        let min = selectedDate.addingTimeInterval(-60 * 60 * 24 * 4)
        let max = selectedDate.addingTimeInterval(60 * 60 * 24 * 4)
        
        let picker = DateTimePicker.show(selected: selectedDate, minimumDate: min, maximumDate: max)

        
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 162.0/255.0, blue: 51.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "CHỌN"
        picker.doneBackgroundColor = UIColor(red: 0.0/255.0, green: 114.0/255.0, blue: 188.0/255.0, alpha: 1)
        picker.locale = Locale(identifier: "vi")
        picker.todayButtonTitle = "Hôm nay"
        picker.is12HourFormat = false
        picker.dateFormat = "dd/MM/yyyy HH:mm:ss"
        picker.isTimePickerOnly = false
        picker.isDatePickerOnly = false
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { date in
            self.setDate(selectedDate: date)
        }

  }
    
    
    private func setDate(selectedDate:Date){
        
        var item = viewModel.orderItem.value
        let result = convertDateToDateString(date: selectedDate)
        dLog(result)

        switch viewModel.dateType.value{
            case 1:
                if isDateValid(fromDateStr: result, toDateStr: item.service_end_time){
                    lbl_start_date.text = formatDateString(dateString: result)
                    item.service_start_time = result
                    viewModel.orderItem.accept(item)
                }else {
                    showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
                    lbl_start_date.text = formatDateString(dateString: item.service_start_time)
                }
                break

            case 2:
                if isDateValid(fromDateStr: item.service_start_time, toDateStr:result) && dateSmallerThanNow(dateString: result) {
                    lbl_end_date.text = formatDateString(dateString: result)
                    item.service_end_time = result
                    viewModel.orderItem.accept(item)
                }else{
                    
                    !isDateValid(fromDateStr: item.service_start_time, toDateStr:result)
                    ? showWarningMessage(content: "Ngày kết thúc không được bé hơn ngày bắt đầu")
                    : showWarningMessage(content: "Ngày kết thúc không được lớn hơn thời gian hiện tại")

                    lbl_end_date.text = formatDateString(dateString: item.service_end_time)
                }
                break

            default:
                break
        }
    }
    
    private func isDateValid(fromDateStr:String, toDateStr:String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let fromDate = dateFormatter.date(from: fromDateStr) ?? Date()
        let toDate = dateFormatter.date(from: toDateStr) ?? Date()
        return fromDate.isSmallerThan(toDate)
    }
    
    private func dateSmallerThanNow(dateString:String) -> Bool{
        let date = convertDateStringToDate(dateString: dateString)
        return date.isSmallerThanOrEqual(convertDateStringToDate(dateString: TimeUtils.getFullCurrentDate()))
    }
    

    
    private func convertDateStringToDate(dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        return date ?? Date()
    }
    
    private func convertDateToDateString(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    
    
    func formatDateString(dateString:String) -> String{
        let date = convertDateStringToDate(dateString: dateString)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.string(from: date)
        
    }
    
}

