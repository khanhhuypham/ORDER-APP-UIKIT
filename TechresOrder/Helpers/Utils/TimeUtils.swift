//
//  TimeUtils.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/12/2023.
//

import UIKit

class TimeUtils: NSObject {
    
    private static let calendar:Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")!
        return calendar
    }()
    
    //lay ngay thang nam
    static func getCurrentDateTime() -> (
        thisWeek: String,
        thisMonth: String,
        lastMonth: String,
        threeLastMonth: String,
        yearCurrent: String,
        lastYear: String,
        threeLastYear: String,
        dateTimeNow: String,
        today: String,
        yesterday: String) {
        

        // Lấy ngày hiện tại
        let date = Date()
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        


        // Lấy số tuần hiện tại
        let currentWeek = calendar.component(.weekOfYear, from: date)
        let thisWeek = String(format: "%02d/%d", currentWeek, year)

        
        // Tháng này
        let tm = Calendar.current.date(byAdding: .month, value: 0, to: Date())
        let tmFormatter : DateFormatter = DateFormatter()
        tmFormatter.dateFormat = "MM/yyyy"
        let thisMonth = tmFormatter.string(from: tm!)
        
        // Tháng trước
        let lm = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let monthFormatter : DateFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM/yyyy"
        let lastMonth = monthFormatter.string(from: lm!)
        
        // 3 Tháng trước
        let tlm = Calendar.current.date(byAdding: .month, value: -3, to: Date())
        let threeLastMonthFormatter : DateFormatter = DateFormatter()
        threeLastMonthFormatter.dateFormat = "MM/yyyy"
        let threeLastMonth = threeLastMonthFormatter.string(from: tlm!)
        
        // Năm nay
        let yearCurrent = String(year)
        
        // Năm trước
        let ly = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        let yearFormatter : DateFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let lastYear = yearFormatter.string(from: ly!)
        
        // 3 năm trước
        let tly = Calendar.current.date(byAdding: .year, value: -3, to: Date())
        let threeLastYearFormatter : DateFormatter = DateFormatter()
        threeLastYearFormatter.dateFormat = "yyyy"
        let threeLastYear = threeLastYearFormatter.string(from: tly!)
        
        // Ngày hôm nay
        let format = DateFormatter()
        format.dateFormat = "dd/MM/YYYY"
        let formattedDate = format.string(from: date)
        var dateTimeNow = formattedDate
        
        // Giờ hôm nay
        let formatTime = DateFormatter()
        formatTime.dateFormat = "HH:mm:ss"
        let today = formatTime.string(from: date)
    
        // Hôm qua
        let y = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var yesterday = dateFormatter.string(from: y!)
        
        
        
        
        let currentHour = calendar.component(.hour, from: date)

        if currentHour < ManageCacheObject.getSetting().hour_to_take_report {
            let yesterdayToday = Calendar.current.date(byAdding: .day, value: -1, to: date)
            let formattedYesterdayToday = format.string(from: yesterdayToday!)
            let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: y ?? Date())
            let formattedYesterday = format.string(from: yesterdayDate!)
            dateTimeNow = formattedYesterdayToday
            yesterday = formattedYesterday
        }
  
        return (thisWeek, thisMonth, lastMonth, threeLastMonth, yearCurrent, lastYear, threeLastYear, dateTimeNow, today, yesterday)
    }
    

    
    
    static func getDateTimeNow() -> String{
        // Lấy ngày hiện tại
        let date = Date()
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        return dateFormatter.hh_mm_ss.value.string(from: date)
    }
    
//    static func getToday() -> String{}
    
    static func getYesterday() -> String{
        return dateFormatter.dd_mm_yyyy.value.string(from: calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date())
    }
    
    static func getThisWeek() -> String{
      
        return String(
            format: "%02d/%d",
            calendar.component(.weekOfYear, from: Date()),
            calendar.component(.year, from: Date())
        )
    }
    
    static func getThisMonth() -> String{
        return dateFormatter.mm_yyyy.value.string(from:calendar.date(byAdding: .month, value: 0, to: Date()) ?? Date())
    }
    static func getLastMonth() -> String {
        return dateFormatter.mm_yyyy.value.string(from:calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date())
    }
    
    
//    static func getThisYear() -> String{
//        
//    }
//    static func getLastYear() -> {}
//    static func getThreeLastYear() -> {}
    
    
    static func ConvertMinutetoHourMinuteFormat(_ timeValue: Int) -> String {
        let timeMeasure = Measurement(value: Double(timeValue), unit: UnitDuration.minutes)
        let hours = timeMeasure.converted(to: .hours)
        if hours.value > 0 {
            let minutes = timeMeasure.value.truncatingRemainder(dividingBy: 60)
          
            return String(format: "%02.f:%02.f", floor(hours.value),minutes)
        }
        return String(format: "00:%02.f", timeMeasure.value)
    }
   
    static func calculateTime(_ timeValue: Int) -> String {
        let timeMeasure = Measurement(value: Double(timeValue), unit: UnitDuration.minutes)
        let hours = timeMeasure.converted(to: .hours)
        if hours.value > 1 {
            let minutes = timeMeasure.value.truncatingRemainder(dividingBy: 60)
          
            return String(format: "%02.f:%02.f", floor(hours.value),minutes)
        }
        return String(format: "00:%02.f", timeMeasure.value)
    }
    
    static func getFullCurrentDate()->String{

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)


        dateFormatter.dateFormat = "MM"
        let monthString = dateFormatter.string(from: date)


        dateFormatter.dateFormat = "dd"
        let dayOfTheWeekString = dateFormatter.string(from: date)


        dateFormatter.dateFormat = "HH:mm"
        let hour_string = dateFormatter.string(from: date)

        return String(format: "%@/%@/%@ %@", dayOfTheWeekString, monthString, yearString, hour_string)
    }
    
    static func getCurrentDatePass() -> String{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyy"
        return dateFormatter.string(from: currentDate)
    }
   
    
    static func isDateValid(fromDateStr:String, toDateStr:String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let fromDate = dateFormatter.date(from: fromDateStr) ?? Date()
        let toDate = dateFormatter.date(from: toDateStr) ?? Date()
        return fromDate.isSmallerThan(toDate)
    }
    
    
    static func dateToString(date : Date)-> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd/MM/yyyy"
        let string = formatter.string(from: date)
        return string
    }
    
    
    static func getSecondSFromDateString(dateString:String) ->Int{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = dateFormatter.date(from: dateString) ?? Date()
        let calendar = Calendar.current
        return calendar.component(.second, from: date)
    }

    
    
    /// Chuyển đổi format hiển thị thời gian trong chat
    static func convertTimeLineForChatChannel(from timeString: String,_ displayCenter:Bool = false) -> String? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        inputDateFormatter.locale = Locale(identifier: "vi_VN")
        inputDateFormatter.timeZone = TimeZone(identifier: "UTC")!
        
        if let inputDate = inputDateFormatter.date(from: timeString) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: inputDate)
            let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            let dateWithoutTime = calendar.date(from: components)!
            let currentDateWithoutTime = calendar.date(from: currentDateComponents)!
            
            let outputDateFormatter = DateFormatter()
            if displayCenter {
                if dateWithoutTime < currentDateWithoutTime {
                    outputDateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
                    return outputDateFormatter.string(from: inputDate)
                } else {
                    outputDateFormatter.dateFormat = "HH:mm"
                    return outputDateFormatter.string(from: inputDate) + " Hôm nay"
                }
            } else {
                outputDateFormatter.dateFormat = "HH:mm"
                return outputDateFormatter.string(from: inputDate)
            }
        }
        return ""
    }
    
    

    static func convertStringToDate(from timeString: String,format:dateFormatter) -> Date{
        return format.value.date(from:timeString) ?? Date()
    }
    
    
    static func convertDateToString(from date: Date,format:dateFormatter) -> String{
        return format.value.string(from: date ?? Date())
    }

}


enum dateFormatter {
    case dd_mm_yyyy
    case yyyy_mm_dd_hh_mm_ss
    case dd_mm_yyyy_hh_mm
    case mm_yyyy
    case yyy
    case hh_mm
    case hh_mm_ss
    case hh_mm_dd_mm_yyyy
    

    var value: DateFormatter {
        let dateFormatter = DateFormatter()
        switch self {
            case .dd_mm_yyyy:
                dateFormatter.dateFormat = "dd/MM/yyyy"
            case .yyyy_mm_dd_hh_mm_ss:
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            
            case .dd_mm_yyyy_hh_mm:
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            case .mm_yyyy:
                dateFormatter.dateFormat = "MM/yyyy"
            case .yyy:
                dateFormatter.dateFormat = "yyyy"
            case .hh_mm:
                dateFormatter.dateFormat = "HH:mm"
            case .hh_mm_ss:
                dateFormatter.dateFormat = "HH:mm:ss"
            case .hh_mm_dd_mm_yyyy:
                dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        }

        dateFormatter.locale = Locale(identifier: "vi_VN")
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")!
        return dateFormatter
    }
    
}









class DatePickerUtils: NSObject,UIGestureRecognizerDelegate {
    
    static let shared: DatePickerUtils = {
        let datePickerUtils = DatePickerUtils()
        return datePickerUtils
    }()

    var delegate: dateTimePickerDelegate?
    var parentView:UIView = UIView()
    
    var datePicker = {
    
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "vi_VN")
        calendar.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")!
        
        let datePicker = UIDatePicker()
        datePicker.calendar = calendar
        datePicker.date = Date()
        datePicker.backgroundColor = .white
//        datePicker.locale = Locale.init(identifier: "vi") //Xem danh sách locale của ngôn ngữ các nước tại https://gist.github.com/jacobbubu/1836273
//        datePicker.locale = Locale(identifier: "vi_VN")
//        datePicker.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")!
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
        datePicker.tintColor = ColorUtils.orange_brand_900()
        datePicker.addTarget(self, action: #selector(handler(sender:)), for: UIControl.Event.valueChanged)
        return datePicker
    }()
    
    func showDatePicker(_ vc:UIViewController,date:Date = Date()) {
    
        
        self.datePicker.setDate(date, animated: true)
        
        self.delegate = vc as? any dateTimePickerDelegate
        if parentView != nil {
            parentView.removeFromSuperview()
        }

        // Give the background Blur Effect
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.cornerRadius = 15
        blurView.clipsToBounds = true
    
    
        
        //Add donebtn
        let doneBtn = UIButton(type: .system)
        doneBtn.configuration = .gray()
        doneBtn.frame.size = CGSize(width: 100, height: 35)
        doneBtn.setAttributedTitle(NSAttributedString(
                string: "Đồng ý",
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                    NSAttributedString.Key.foregroundColor: ColorUtils.black()
                ]
        ),for: .normal)
        doneBtn.titleLabel?.textAlignment = .left
        doneBtn.tintColor = ColorUtils.orange_brand_900()
        doneBtn.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        
        
        
        
        //Add donebtn
        let dateTimeNowBtn = UIButton(type: .system)
        dateTimeNowBtn.configuration = .gray()
        dateTimeNowBtn.frame.size = CGSize(width: 100, height: 35)
        
        dateTimeNowBtn.setAttributedTitle(NSAttributedString(
                string: "Now",
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                    NSAttributedString.Key.foregroundColor: ColorUtils.black()
                ]
        ),for: .normal)

        dateTimeNowBtn.addTarget(self, action: #selector(resetDateTime), for: .touchUpInside)
        

        
    
        let stackViewOfBtn = UIStackView()
        stackViewOfBtn.spacing = 10
        stackViewOfBtn.distribution = .fill
        stackViewOfBtn.axis = .horizontal
        stackViewOfBtn.addArrangedSubview(doneBtn)
        stackViewOfBtn.addArrangedSubview(dateTimeNowBtn)
        
        
        stackViewOfBtn.frame = CGRect(
            origin: CGPoint(x: 10, y: datePicker.frame.height),
            size: CGSize(width: doneBtn.frame.width + dateTimeNowBtn.frame.width, height: doneBtn.frame.height)
        )
        
        stackViewOfBtn.layoutSubviews()
        

        parentView = UIView()
        parentView.layer.shadowColor = UIColor.black.cgColor
        parentView.layer.masksToBounds = false
        parentView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        parentView.layer.shadowRadius = 10
        parentView.layer.shadowOpacity = 0.3

        parentView.addSubview(blurView)
        parentView.addSubview(datePicker)
        parentView.addSubview(stackViewOfBtn)
        
        
        parentView.translatesAutoresizingMaskIntoConstraints = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(parentView)

        NSLayoutConstraint.activate([
            parentView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            parentView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
            parentView.heightAnchor.constraint(equalToConstant: datePicker.frame.height + stackViewOfBtn.frame.height + 20),
            parentView.widthAnchor.constraint(equalToConstant: datePicker.frame.width),
            blurView.heightAnchor.constraint(equalToConstant: datePicker.frame.height + stackViewOfBtn.frame.height + 20),
            blurView.widthAnchor.constraint(equalToConstant: datePicker.frame.width),
        ])
        vc.view.bringSubviewToFront(parentView)
        vc.view.layoutIfNeeded()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        vc.view.gestureRecognizers = [panGesture,tapGesture]

        // animate to show contentView
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .curveLinear, animations: {
            self.parentView.frame = CGRect(
                                    x: -self.parentView.frame.width,
                                    y:  vc.view.frame.height - self.parentView.frame.height,
                                    width: vc.view.frame.width,
                                    height: self.parentView.frame.height
            )
        }, completion: nil)
    
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }


    @objc private func handlePanGesture(_ panGesture:UIPanGestureRecognizer) {

    }

    @objc private func handleTapOutSide(_ tapGesture:UITapGestureRecognizer){
        let tapLocation = tapGesture.location(in: parentView)
        if !parentView.bounds.contains(tapLocation){
            parentView.removeFromSuperview()
            parentView.removeFromSuperview()
        }
    }

    @objc func handler(sender: UIDatePicker) {
        let strDate = dateFormatter.dd_mm_yyyy_hh_mm.value.string(from: sender.date)
        dLog(strDate)
    }
    
    
    @objc func resetDateTime() {
        self.datePicker.setDate(Date(), animated: true)
    }
    
    
    @objc func pressed() {
        
        delegate?.callbackToGetDateTime(didSelectDate:datePicker.date)
        parentView.removeFromSuperview()

    }
    
}
