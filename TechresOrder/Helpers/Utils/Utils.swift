//
//  Utils.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import Photos

class Utils: NSObject {
    

    /// Lấy tên nguyên bản trên thiết bị của ảnh
    static func getImageFullName(asset: PHAsset) -> String {
        let resources = PHAssetResource.assetResources(for: asset)
        
        if let resource = resources.first {
            let fullName = resource.originalFilename
            return fullName
        }
        return ""
    }
    
    static var heightOfCustomBar:CGFloat = 50.0
    
    static func getUDID()-> String{
        let UDID = UIDevice.current.identifierForVendor!.uuidString
        
        return UDID.lowercased()
    }
    static func getOSName()-> String{
        return  "iOS"
    }
    static func getPlatFormType()-> String{
        return  ""
    }
    
    static func getAppType()-> Int{
        return  11
    }
    static func getFullMediaLink(string:String) -> String {
        
        return (ManageCacheObject.getConfig().api_upload_short + string).encodeUrl()!
//        return ("https://haproxy.techres.vn/api/v1/short/" + string).encodeUrl()!
        
        }
   static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func getDeviceName()-> String{
        let UDID = UIDevice.current.name
        
        return UDID.lowercased()
    }
    
    static func isHideView(isHide:Bool, view:UIView){
        view.isHidden = isHide
        view.subviews.forEach { _ in
            view.subviews[0].isHidden = isHide
            view.subviews[1].isHidden = isHide
        }
    }
    
    static func isHideAllView(isHide:Bool, view:UIView){
        view.isHidden = isHide
        view.subviews.enumerated().forEach { (index, value) in
            view.subviews[index].isHidden = isHide
        }
        
      
    }
    
    static func doubleToPrecent(value : Double)-> String
    {
        let index = value*100
        let str = String(format: "%.1f%%", index)
        return str
    }
    
    
    // kiem tra ky tu đặc biet khi nhap vao cho tên vùng -> trả về chuỗi
    static func blockSpecialCharacters(_ string: String) -> String {
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9\\p{L}\\p{M} ]+")
        let filteredString = regex.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: "")
        return filteredString
    }
    
    
    
    
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
  
    
    static func encoded(str:String)->String{
        
        if let base64Str = str.base64Encoded() {
            print("Base64 encoded string: \"\(base64Str)\"")
            return base64Str
        }
        return str
    }
    
    static func rateDefaultTemplate(numerator: Double, denominator: Double) -> Double {
        var rate: Double = 0
        
        if numerator == 0 && denominator == 0 {
            rate = 0
        } else if denominator == 0 {
            rate = 1
        } else {
            rate = numerator / denominator
        }
        return rate
    }
    
    static func stringQuantityFormatWithNumberFloat(amount:Float)->(String){
        let number = NumberFormatter()
        number.usesGroupingSeparator = true
        number.numberStyle = .decimal
        number.groupingSeparator = ","
        number.decimalSeparator = "."
        number.groupingSize = 3
        number.maximumFractionDigits = 2
        let strAmount = number.string(from: NSNumber(value: Double(amount)))
        return String(format: "%@",strAmount!)
    }
    
    //lay ngay thang nam
    static func getCurrentDateTime() -> (thisWeek: String, thisMonth: String, lastMonth: String, threeLastMonth: String, yearCurrent: String, lastYear: String, threeLastYear: String, dateTimeNow: String, today: String, yesterday: String) {
        
        // Tạo một đối tượng Calendar với múi giờ của Việt Nam
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")!

        // Lấy ngày hiện tại
        let date = Date()
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        


        // Lấy số tuần hiện tại
        let currentWeek = calendar.component(.weekOfYear, from: date)

 

//String(format: "%d/%d", Week, year)
//        if thisWeek.count == 6 {
        let thisWeek = String(format: "%02d/%d", currentWeek, year)
//        }
        
        // Tháng này
        _ = String(format: "%d/%d", month, year)
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
    
    static func stringQuantityFormatWithNumber(amount:Int)->(String){
        let number = NumberFormatter()
        number.usesGroupingSeparator = true
        number.groupingSeparator = ","
        number.groupingSize = 3
        
        let strAmount = number.string(from: NSNumber(value: amount))
        return String(format: "%@",strAmount!)
    }
    

    //kiểm tra uppercased và lowercased
    static func isCheckStringEqual(stringA : String, stringB : String) -> Bool{
        
        let isEqual = stringA.trim().lowercased().elementsEqual(stringB.trim().lowercased())
        
        if isEqual{
            return true
        }else{
            return false
        }

    }
    static func checkRoleIsPrintBill() -> Bool{
        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE &&
           ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO || ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE &&
           ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE){
          return false
        }
        return true
    }

    static func isCheckValidateAddress(address: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: #"^[\p{L}0-9\s.,-]+$"#, options: .caseInsensitive)
        let range = NSRange(location: 0, length: address.utf16.count)
        return regex.firstMatch(in: address, options: [], range: range) != nil
    }
    
    

    static func validatePercentage(percent: String) -> Bool {
        guard let percentage = Double(percent) else {
            // Nếu không thể chuyển đổi thành giá trị số
            // Xử lý theo logic tương ứng (không phải là lỗi vượt quá 100%)
            return true
        }
        
        if percentage > 100 {
            // Giá trị lớn hơn 100%
            return false
        }
        
        return true
    }
    

    static func hideTotalAmount(amount:Float)->String{
        var suffix:String = ""
        var digits:Int?
        //debugPrintln(amount)
        var reducedAmount:Float?
        
        reducedAmount = amount / 10000;
        suffix = "K";
//        suffix = "...";
        digits = 1;
        
        let f1 = (amount - floorf(amount))
        let f2 = powf(0.1, Float(digits!))-Float(0.0001)
        
        if (f1 < f2) {
            digits = 0
        }
        
        let number = NumberFormatter()
        number.usesGroupingSeparator = true
        number.maximumFractionDigits = 4
        number.minimumFractionDigits = digits!
        let strAmount = number.string(from: NSNumber(value: reducedAmount!))
        debugPrint(String(format: "%@%@",strAmount!,suffix))
        let str = String(format: "%@%@",strAmount!,suffix)
        
        return String(format:"%@%@",String(str.split(separator: ",")[0]),"...")
    }
    
    
    static func stringVietnameseMoneyFormatWithNumberDouble(amount:Double, unit_name :String = "") -> String{
        let number = NumberFormatter()
        number.usesGroupingSeparator = true
        number.numberStyle = .decimal
        number.groupingSeparator = ","
        number.decimalSeparator = "."
        number.groupingSize = 3
        number.maximumFractionDigits = 2
        
        let strAmount = number.string(from: NSNumber(value: amount))
        return String(format: "%@", strAmount!)
    }
    
    static func stringVietnameseMoneyFormatWithNumber(amount:Float, unit_name :String = "")-> String{
        let number = NumberFormatter()
        number.usesGroupingSeparator = true
        number.groupingSeparator = ","
        number.groupingSize = 3
        
        let strAmount = number.string(from: NSNumber(value: amount))
        
        if unit_name.isEmpty{
            return strAmount!
        }else{
            return String(format: "%@ %@",strAmount!, unit_name)
        }
        
    }
    
    static func stringVietnameseMoneyFormatWithNumberInt(amount:Int, unit_name :String = "") -> String{
        let number = NumberFormatter()
        number.usesGroupingSeparator = true
        number.groupingSeparator = ","
        number.groupingSize = 3
        let strAmount = number.string(from: NSNumber(value: amount))
        if unit_name.isEmpty{
            return strAmount!
        }else{
            return String(format: "%@ %@",strAmount!, unit_name)
        }
    }
    
    static func stringQuantityFormatWithNumberFloat(quantity:Float) -> String{
        /*
            nếu 1.0 return "1"
            nếu 2.5 return "2.5"
            nếu 2.68 return "2.68"
         */
        var amount = String(format: "%.2f", quantity)
        while amount.last == "0" {
           amount.removeLast()
        }
        if amount.last == "." {
           amount.removeLast()
        }
        return amount
    }
    
    static func convertStringToInteger(str:String) -> Int{
        let amount = str.replacingOccurrences(of: ",", with: "")
        return Int(amount) ?? 0
    }
    
   
    
   
    


    
    // MARK: QUYỀN HỦY MÓN KHI ĐÃ HOÀN TẤT( MÓN HOÀN TẤT, PHỤ THU, MÓN NGOÀI
    static func checkRoleCancel(permission:[String])->Bool{
        var isAllow = false
        for item in permission {
            if ((item.elementsEqual(CANCEL_COMPLETED_FOOD)) == true
                || (item.elementsEqual(EMPLOYEE_MANAGER)) == true
                || (item.elementsEqual(OWNER)) == true){
                isAllow = true
            }
        }
        return isAllow
    }
   
    
    //MARK: QUYỀN KIỂM SOÁT ORDER TRÊN APP TECHRES-ORDER
    static func checkRoleManagerOrder(permission:[String], employeeId:Int = 0)->Bool{
        var isAllow = false
        for item in permission {
            if ((item.elementsEqual(ACTION_ON_FOOD_AND_TABLE)) == true || (item.elementsEqual(RESTAURANT_MANAGER)) == true ||
                (item.elementsEqual(OWNER)) == true){
                isAllow = true
            }
        }
        return isAllow
    }
    
    // MARK: QUYỀN GIẢM GIÁ, TẶNG MÓN, VAT,  TRÊN APP TECHRES-ORDER
    static func checkRoleDiscountGifFood(permission:[String])->Bool{
        var isAllow = false
        for item in permission {
            if ((item.elementsEqual(RESTAURANT_MANAGER)) == true ||
                (item.elementsEqual(OWNER)) == true ||
                (item.elementsEqual(DISCOUNT_ORDER)) == true){
                isAllow = true
            }
        }
        return isAllow
    }
    
    //MARK: QUYỀN THÊM MÓN NGOÀI, PHỤ THU & HUỶ PHỤ THU
    static func checkRoleAddCustomFood(permission:[String])->Bool{
        var isAllow = false
        for item in permission {
            if ((item.elementsEqual(OWNER)) == true
                || (item.elementsEqual(RESTAURANT_MANAGER)) == true
                || (item.elementsEqual(ADD_FOOD_NOT_IN_MENU)) == true){
                    isAllow = true
            }
        }
        return isAllow
    }
    //MARK: QUYỀN SUPPERADMIN | CHỦ NHÀ HÀNG
    static func checkRoleOwner(permission:[String])->Bool{
           var isAllow = false
           for item in permission {
               if ((item.elementsEqual(OWNER)) == true){
                     isAllow = true
                   }
           }
           return isAllow
    }
    
   
    //MARK: QUYỀN TỔNG QUẢN LÝ
    static func checkRoleOwnerAndGeneralManager(permission:[String])->Bool{
           var isAllow = false
           for item in permission {
               if ((item.elementsEqual(OWNER)) == true
                    || (item.elementsEqual(GENERAL_MANAGER)) == true
                    ){
                     isAllow = true
                   }
           }
           return isAllow
    }
    //MARK: QUYỀN HỦY MÓN KHI ĐÃ HOÀN TẤT( MÓN HOÀN TẤT, PHỤ THU, MÓN NGOÀI... )
    static func checkRoleCancelFoodCompleted(permission:[String])->Bool{
              var isAllow = false
              for item in permission {
                if ((item.elementsEqual(OWNER)) == true
                    || (item.elementsEqual(CANCEL_COMPLETED_FOOD)) == true){
                        isAllow = true
                      }
              }
              return isAllow
       }
    
  
    
    
    //MARK: QUYỀN ORDER MON TRÊN APP TECHRES-ORDER
    static func checkRoleOrderFood(permission:[String], employeeId:Int = 0)->Bool{
        var isAllow = false
        for item in permission {
            if ((item.elementsEqual(ORDER_FOOD)) == true
                || (item.elementsEqual(RESTAURANT_MANAGER)) == true
                || (item.elementsEqual(CASHIER_ACCESS)) == true
                || (item.elementsEqual(OWNER)) == true){
                isAllow = true
            }
        }
        return isAllow
    }
   

    

    

    

    static let calendar = Calendar.current
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
   
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/YYYY"
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
    
    static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
    
    static func getCurrentDateString()->String{
        let currentDay = calendar.date(byAdding: .day, value: 0, to: Date())
        return String(format: "%@", dateFormatter.string(from: currentDay!))
    }
    
    static func getYesterdayString()->String{
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
        return String(format: "%@", dateFormatter.string(from: yesterday!))
    }
    
    static func getCurrentWeekString() ->String {
        // Tạo một đối tượng Calendar với múi giờ của Việt Nam
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")!

        // Lấy ngày hiện tại
        let currentDate = Date()

        // Lấy số tuần hiện tại
        let currentWeek = calendar.component(.weekOfYear, from: currentDate)



        //let week = Calendar.current.component(.weekOfYearCalendarUnit , from: Date())
        let year = Calendar.current.component(.year, from: Date())
        return String(format: "%d/%d",currentWeek,year)
    }
    
    static func getLastThreeMonthString() ->String {
        let lastThreeMonth = calendar.date(byAdding: .month, value: -3, to: Date())
        return String(format: "%@", monthFormatter.string(from: lastThreeMonth!))
    }
    
    static func getLastMonthString() ->String {
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: Date())
        return String(format: "%@", monthFormatter.string(from: lastMonth!))
    }
    
    static func getCurrentMonthString() ->String {
        let currentMonth = calendar.date(byAdding: .month, value: 0, to: Date())
        return String(format: "%@", monthFormatter.string(from: currentMonth!))
    }
    
    static func getLastThreeYearString() -> String {
        let lastThreeYear = calendar.date(byAdding: .year, value: -3, to: Date())
        return String(format: "%@", yearFormatter.string(from: lastThreeYear!))
    }
    
    static func getLastYearString() -> String {
        let lastYear = calendar.date(byAdding: .year, value: -1, to: Date())
        return String(format: "%@", yearFormatter.string(from: lastYear!))
    }
    
    static func getCurrentYearString() -> String {
        let year = Calendar.current.component(.year, from: Date())
        return String(format: "%d", year)
    }
    
    static func getCurrentMonthYearString() -> String{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year:Int =  components.year ?? 2022
        let month:Int = components.month ?? 01
        
        return String(format: "%02d/%d",  month, year)
    }
    //MARK: CHECK TOKEN EXPIRATION
    static func checkTokenExpiration()-> Bool{
        
        //Time in seconds since 1970.
        let expiry = ManageCacheObject.getCurrentUser().token_time_life

        //if expirationDate > Now
        if Date(timeIntervalSince1970: expiry) > Date() {
            print("JWT hasn't expired yet.")
            return false
        } else {
            print("JWT has expired.")
            return true
        }
    }
    
    static func reviewOnAppStore() {
        guard let productURL = URL(string: APP_STORE_URL) else {
            return
        }
        
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)

        // 2.
        components?.queryItems = [
          URLQueryItem(name: "action", value: "write-review")
        ]

        // 3.
        guard let writeReviewURL = components?.url else {
          return
        }

        // 4.
        UIApplication.shared.open(writeReviewURL)
     }

    static func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        //            let build = dictionary["CFBundleVersion"] as! String
        return version
    }
    
    // kiem tra ky tu đặc biet khi nhap vao
    static func ischaracter(string : String) -> Bool {
        let character = "!@#$%&*"
        if character.contains(string){
            return true
        } else {
            return false
        }
    }
    
    
    
    static func setAttributesForBtn(content: String, attributes:[NSAttributedString.Key:Any]) -> NSAttributedString {
        return NSAttributedString(
                string: content,
                attributes: attributes
        )
    }
    
    static func setAttributesForLabel(label: UILabel, attributes:[(str:String,properties:[NSAttributedString.Key:Any])]) -> NSMutableAttributedString {
            var totalStr = ""
            var pointer = 0
            
            for i in 0..<(attributes.count - 1) {
                totalStr += attributes[i].str
            }
            totalStr += attributes[attributes.count - 1].str
            
            let myMutableString = NSMutableAttributedString(string: totalStr,attributes: [NSAttributedString.Key.foregroundColor :label.textColor as Any])
            for attr in attributes {
                for property in attr.properties {
                    myMutableString.addAttribute(property.key, value: property.value, range: NSRange(location:pointer,length:attr.str.count))
                }
                pointer += attr.str.count
            }
        
            label.text = totalStr
            return myMutableString
    }
    
    
    static func getAttributedString(attributes:[(str:String,properties:[NSAttributedString.Key:Any])]) -> NSMutableAttributedString {
            var totalStr = ""
            var pointer = 0
            
            for i in 0..<(attributes.count - 1) {
                totalStr += attributes[i].str
            }
            totalStr += attributes[attributes.count - 1].str
            
            let myMutableString = NSMutableAttributedString(string: totalStr,attributes:[:])
        
            for attr in attributes {
                for property in attr.properties {
                    myMutableString.addAttribute(property.key, value: property.value, range: NSRange(location:pointer,length:attr.str.count))
                }
                pointer += attr.str.count
            }
        
            return myMutableString
    }
    
    
    
    

  
//    
//   static func address<T: AnyObject>(of object: T) -> Int {
//        return unsafeBitCast(object, to: Int.self)
//    }

    
    static func changeBgBtn(btn:UIButton, btnArray:[UIButton]){
        for button in btnArray{
            button.backgroundColor = ColorUtils.white()
            button.setTitleColor(ColorUtils.orange_brand_900(),for: .normal)
            
            let btnTxt = NSMutableAttributedString(string: button.titleLabel?.text ?? "",attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 12, weight: .semibold)])
        
            button.setAttributedTitle(btnTxt,for: .normal)
            button.borderWidth = 1
            button.borderColor = ColorUtils.orange_brand_900()
        }
        btn.borderWidth = 0
        btn.backgroundColor = ColorUtils.orange_brand_900()
        btn.setTitleColor(ColorUtils.white(),for: .normal)
        
     
    }
    

    static func getAreaBottomPadding() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding ?? 50
        }else {
           return 50
        }
    }
    
    static func containsVietnameseCharacters(_ string: String) -> Bool {
            
        let vietnameseCharacters = Set("ăâđêôơưàảãáạăằẳẵắặâầẩẫấậèẻẽéẹêềểễếệìỉĩíịòỏõóọôồổỗốộơờởỡớợùủũúụưừửữứựỳỷỹýỵđ")

        for character in string {
            if vietnameseCharacters.contains(character) {
                return true
            }
        }

        return false
    }
    
    static func containsEmojis(_ string: String) -> Bool {
            
        let emojiPattern = "[\\p{Emoji}]{1,}"
        
        let emojiPredicate = NSPredicate(format: "SELF MATCHES %@", emojiPattern)
        
        let isEmoji = emojiPredicate.evaluate(with: string)
        
        return isEmoji
    }
    
    
    static func textContainsAtLeastThreeCharacter(_ s: String) -> Bool {
        var alphabeticCount = 0
        for character in s {
            if character.isLetter {
                alphabeticCount += 1
            }
        }
        return alphabeticCount >= 3 ? true : false
    }
    
    
    
    
    static func blockCharacterVN(string: String) -> String{
        return string.folded
    }
    
    static func blockEmoij(textField: UITextField){
        textField.keyboardType = UIKeyboardType.asciiCapable
    }
    
    static func containsValidCharacters(_ text: String) -> Bool {
        let validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,@:?!()$\\/# \n"
        let invalidSet = CharacterSet(charactersIn: validChars).inverted

        return text.rangeOfCharacter(from: invalidSet) == nil
    }
    
    static func resetConfig(){
        ManageCacheObject.saveCurrentPoint(NextPoint()!)
        ManageCacheObject.saveCurrentBrand(Brand())
        ManageCacheObject.saveCurrentBranch(Branch())
        ManageCacheObject.setSetting(Setting()!)
        ManageCacheObject.saveCurrentUser(Account())
        ManageCacheObject.setConfig(Config()!)
    }
    
    
    
    static func encrypt(plainText: String, publicKey: SecKey) throws -> Data {
        let blockSize = SecKeyGetBlockSize(publicKey)
        var messageData = plainText.data(using: .utf8)!
        var encryptedData = Data(count: blockSize)
        
        var encryptedDataLength = blockSize
        let status = encryptedData.withUnsafeMutableBytes { encryptedBytes in
            messageData.withUnsafeBytes { messageBytes in
                SecKeyEncrypt(publicKey, .PKCS1, messageBytes, messageData.count, encryptedBytes, &encryptedDataLength)
            }
        }
        
        guard status == errSecSuccess else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
        }
        
        encryptedData.removeSubrange(encryptedDataLength..<encryptedData.count)
        return encryptedData
    }
    
    
    static func createPublicKey(from base64String: String) throws -> SecKey {
        guard let publicKeyData = Data(base64Encoded: base64String) else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(errSecDecode), userInfo: nil)
        }
        
        let keyDict: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: 2048,
            kSecReturnPersistentRef as String: true
        ]
        
        var error: Unmanaged<CFError>?
        guard let secKey = SecKeyCreateWithData(publicKeyData as CFData, keyDict as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        return secKey
    }

}
extension UITextView {
    /// Change Color Placeholder UILabel To This UITextView
    public func setPlaceholderColor(_ placeholderText: String , _ isCallApi: Bool) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.textColor = ColorUtils.gray_400()
        placeholderLabel.font = self.font
        placeholderLabel.numberOfLines = 0
        placeholderLabel.sizeToFit()
        if isCallApi {
            if (self.text.isEmpty){
                placeholderLabel.isHidden = false
            } else {
                placeholderLabel.isHidden = true
            }
        } else {
            placeholderLabel.isHidden = false
        }
        self.addSubview(placeholderLabel)
        self.setValue(placeholderLabel, forKey: "_placeholderLabel")
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: self, queue: nil) { [weak self] _ in
            self?.updatePlaceholderVisibility(placeholderLabel)
        }
    }
    /// Remove Placeholder UILabel When Text In UiTextView Empty
    private func updatePlaceholderVisibility(_ placeholderLabel: UILabel) {
        placeholderLabel.isHidden = !self.text.isEmpty
        // Remove the observer when you no longer need it to prevent any potential memory leaks
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
   
}
