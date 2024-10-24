//
//  PrinterUtils.swift
//  Techres - Order
//
//  Created by Kelvin on 31/03/2022.
//  Copyright © 2022 vn.techres.sale. All rights reserved.
//

import UIKit

class PrinterUtils {
    static let bluetoothManager = BluetoothPrinterManager()
    
    static func getLine80() -> String {
      return "------------------------------------------------"//48
    }
    
    static func getTotalSpaceInALine() -> Int {
        return 48
    }
    
 
    
    
    
    static func printTextData(client:TCPClient, text_data:String, isMulti:Int = 0, order_detail_id:Int = 0){

           switch client.connect(timeout: 3) {
               case .success:
        //               appendToTextField(string: "Connected to host \(client.address)")
                   
                   let printerResponse = ["userInfo": ["order_detail_id": order_detail_id]]

                   
                   NotificationCenter.default.post(name: NSNotification.Name("vn.techres.printer.status"),object: nil, userInfo: printerResponse)
                   
                   if let response = sendRequest(string: text_data, using: client) {
                       dLog( "Response thành công: \(response)")
                     
                 }
                   dLog( "print thành công:")
                   
               case .failure(let error):
        //             appendToTextField(string: String(describing: error))
                   dLog( String(describing: error))
                   dLog("món lỗi chưa in đc")
                  
                   dLog(text_data)
                   
                   NotificationCenter.default.post(name: NSNotification.Name("vn.techres.printer.connect.failure"),object: nil)
                   
           }
        
        let cut_and_feed: [UInt8] = [0x1b, 0x69]
        client.send(data: cut_and_feed)
        client.close()
        
//        ManagerRealmHelper.shareInstance().deleteFoodReadyPrinted(order_id: order_id)
        
    }
    
    static func printData(client:TCPClient, data:NSData){

        switch client.connect(timeout: 3) {
            case .success:
               if let response = sendRequests(data: data, using: client) {
                   appendToTextField(string: "Response: \(response)")
               }
            case .failure(let error):
                appendToTextField(string: String(describing: error))
        }

        let cut_and_feed: [UInt8] = [0x1b, 0x69]
        client.send(data: cut_and_feed)
        client.close()
    }

    private static func sendRequests(data: NSData, using client: TCPClient) -> String? {
           appendToTextField(string: "Sending data ... ")
           
        switch client.send(data: data as Data) {
           case .success:
             return readResponse(from: client)
           case .failure(let error):
             appendToTextField(string: String(describing: error))
             return nil
        }
    }

    private static func sendRequest(string: String, using client: TCPClient) -> String? {
        appendToTextField(string: "Sending data ... ")
        switch client.send(string: string) {
            case .success:
                return readResponse(from: client)
            case .failure(let error):
                appendToTextField(string: String(describing: error))
                return nil
        }
    }
     
    private static func readResponse(from client: TCPClient) -> String? {
        guard let response = client.read(1024*10) else { return nil }

        return String(bytes: response, encoding: .utf8)
    }
     
    private static func appendToTextField(string: String) {
        print(string)
    }
    
    
    static func addSpace(numberOfSpace:Int) -> String {
        var space = ""
        for _ in (1...numberOfSpace){
            space += " "
        }
      return space
    }
    
    static func addMiddleAlignedText(word:String,totalCharInLine:Int) -> String {
        var result = ""
        var totalRemainingSpace = totalCharInLine - word.count
        if totalRemainingSpace > 0 {
            return addSpace(numberOfSpace: totalRemainingSpace/2) + word + addSpace(numberOfSpace: totalRemainingSpace/2)
        }else {
            return word
        }
        
    }
    
    static func addSpaceAmongWords(totalSpace: Int, strArray:String...) -> String {
        var result = ""
        var numberOfChar = totalSpace
        for str in strArray{
            numberOfChar -= str.count
            dLog(str.count)
        }

        if numberOfChar > 0{
            for _ in (1...numberOfChar){
                result += " "
            }
        }else if numberOfChar <= 0{ //xử lý trường hợp tên str có độ dài tối đa
            result += "     "
        }
        
        
        
        return result
    }
    
    static func getTextInALine(totalSpace: Int, str1:String, str2:String) -> String {
        var result = ""
                
        var numberOfChar = totalSpace
        
        numberOfChar -= (str1.count + str2.count)
        
    
        if numberOfChar > 0{
            result += str1
            for _ in (1...numberOfChar){
                result += " "
            }
            result += str2
        }else if numberOfChar <= 0{ //xử lý trường hợp tên str có độ dài tối đa
            
            var array:[String] = [] //["pham ", "khanh ", " huy ","ios ","developer"]
            var newArray:[String] = [] //["pham khanh huy ", "ios developer"]

            let splitedStrArray = str1.split(separator: " ")
            splitedStrArray.enumerated().forEach{(i,value) in
        
                if i == splitedStrArray.count - 1{
                    array.append(String(value))
                }else{
                    array.append(value + " ")
                }
            }
            
    
            var splitedStr = ""
            var index = 0
            array.enumerated().forEach{(i,value) in
                splitedStr += value
                if splitedStr.count >= 30{
                    newArray.append(splitedStr)
                    splitedStr = ""
                    index = i
                }
            }
            
    
            let start = index + 1
            let end = array.count - 1
            if end >= 0 && start <= array.count - 1{
                newArray.append(array[start...end].joined())
            }

            newArray.enumerated().forEach{(i,value) in
                if i == 0{
                    result += value + addSpaceAmongWords(totalSpace: totalSpace, strArray:value,str2) + str2 + "\n"
                }else if i == newArray.count - 1{
                    result += value
                }else{
                    result += value + "\n"
                }
            }
        }
        
        
        return result
    }
    

    
    static func PrintOrderItem(order:OrderDetailData,items:[Food],print_type:Int,printer:Kitchen){
        
     
        switch printer.printer_type{
            case 0:
            DispatchQueue(label: "queue", attributes: .concurrent).sync { [self] in
                    if printer.is_print_each_food == ACTIVE {
                        for fd in items {
                            for _ in 1...printer.print_number{
                                PrinterUtils.printItemsByWifi(order: order, food_prints: [fd], print_type: print_type, kitchen: printer)
                                sleep(1)
                            }
                        }
                    }else{
                        for _ in 1...printer.print_number{
                            PrinterUtils.printItemsByWifi(order: order, food_prints: items, print_type: print_type, kitchen: printer)
                            sleep(1)
                        }
                    }
                }
                break
            
            case 4:
            
            if printer.is_print_each_food == ACTIVE {
                for fd in items {
                    for _ in 1...printer.print_number{
                        printItemByBLE(order:order,items:[fd],print_type: print_type)

                    }
                }
            }else{
                for _ in 1...printer.print_number{
                    printItemByBLE(order:order,items:items,print_type: print_type)
                }
            }
            
               
            default:
                break
        }
    }
    
    
    static func printItemByBLE(order:OrderDetailData,items:[Food],print_type:Int){
        let receipt = Receipt(.init(maxWidthDensity: 480, fontDensity: 10, encoding: .utf8))
        receipt <<~ .style(.initialize)
        receipt <<~ .page(.printAndFeed(lines: 1))
        receipt <<~ .layout(.justification(.center)) <<~ .style(.emphasis(enable: true))
        switch print_type {
            case  PRINT_TYPE_ADD_FOOD:
                receipt <<< "PHIEU MOI"
            case  PRINT_TYPE_UPDATE_FOOD:
                receipt <<< "PHIEU CAP NHAT SO LUONG"
            case  PRINT_TYPE_CANCEL_FOOD:
                receipt <<< "PHIEU HUY"
            case  PRINT_TYPE_RETURN_FOOD:
                receipt <<< "PHIEU TRA"
            default:
                receipt <<< "PHIEU MOI"
        }
        receipt <<~ .page(.printAndFeed(lines: 1)) <<~ .layout(.justification(.left)) <<~ .style(.emphasis(enable: false))
              
        if (print_type == PRINT_TYPE_RETURN_FOOD){
            
            receipt <<< String(format: "Ten mon: %@", ConverHelper.convertVietNam(text: items[0].name))
            receipt <<< String(format: "So luong da goi: %d", Int(items[0].printed_quantity))
            receipt <<< String(format: "So luong su dung: %d", Int(items[0].quantity))
            receipt <<< String(format: "So luong tra: %d", Int(items[0].printed_quantity - items[0].quantity))
            receipt <<< String(format: "Ma HD: %d", order.id)
            receipt <<< String(format: "Ten Ban: %@",ConverHelper.convertVietNam(text: order.table_name))
            receipt <<< String(format: "Ghi chu: %@", ConverHelper.convertVietNam(text: items[0].note))
            receipt <<< String(format: "Nhan vien: %@", ConverHelper.convertVietNam(text: order.employee_name))
            receipt <<< String(format: "Ngay: %@", Utils.getFullCurrentDate())
            
        }else{
            receipt <<< String(format: "Ngay: %@", Utils.getFullCurrentDate())
            receipt <<< String(format: "Ma HD: %d", order.id)
            receipt <<< String(format: "Ban: %@",ConverHelper.convertVietNam(text: order.table_name))
            receipt <<< String(format: "Nhan vien: %@", ConverHelper.convertVietNam(text: order.employee_name))
            receipt <<< Dividing.default(provider: "-")
        }
        // Section 2 : Purchaced items
        for item in items {

            let name = ConverHelper.convertVietNam(text: item.name)
            var quantity = ""
            
            switch print_type {
                
                case PRINT_TYPE_ADD_FOOD, PRINT_TYPE_CANCEL_FOOD:
                
                    quantity = String(format: item.is_sell_by_weight == ACTIVE ? "%.2f" : "%.0f", item.quantity)
                    
                
                    let totalCharInLine = getTotalSpaceInALine()
                    name.count > 30
                    ? {receipt <<< getTextInALine(totalSpace: totalCharInLine, str1:name, str2:quantity)}()
                    : {receipt <<< KVItem(name, quantity)}()
                
                   
                    
                    for childFood in item.order_detail_additions{
                        receipt <<< String(format: " + %@ x %d", ConverHelper.convertVietNam(text: childFood.name), Int(childFood.quantity))
                    }
                    break
                 
                case PRINT_TYPE_RETURN_FOOD:
                
                    quantity = String(format: "%d", Int(item.printed_quantity) - Int(item.quantity))
                    receipt <<< KVItem(name, quantity)
                    break
                
                default:
                    break
                
                
            }
                
            if !item.note.isEmpty {
                receipt <<< String(format:"(%@)", item.note.folding(options: .diacriticInsensitive, locale: .current))
            }
            receipt <<< Dividing.default(provider: "-")
        }
        receipt <<~ .page(.printAndFeed(lines: 2))
    
        if bluetoothManager.canPrint {
            bluetoothManager.write(Data(receipt.data), completeBlock: {_ in
               
                dLog("=================== in bluetooth thanh cong.......")
                
                NotificationCenter.default.post(name: NSNotification.Name("vn.techres.printer.status.bluetooth"), object: nil)
                
            })
        }
    }
    
    static func printItemsByWifi(order:OrderDetailData,food_prints:[Food], print_type:Int, kitchen:Kitchen) {
       
        let client = TCPClient(address: kitchen.printer_ip_address, port: Int32(kitchen.printer_port) ?? 0)
        //tổng số ký tự trong 1 dòng
        let totalCharInLine = getTotalSpaceInALine()
    
        let textData: NSMutableString = NSMutableString()

        
        var title = ""
        
        switch print_type {
            case  PRINT_TYPE_ADD_FOOD:
                title = "PHIEU MOI"
            case  PRINT_TYPE_UPDATE_FOOD:
                title = "PHIEU CAP NHAT SO LUONG"
            case  PRINT_TYPE_CANCEL_FOOD:
                title = "PHIEU HUY"
            case  PRINT_TYPE_RETURN_FOOD:
                title = "PHIEU TRA"
            default:
                title = "PHIEU MOI"
        }

        
        let remind_number_title = addSpaceAmongWords(totalSpace: totalCharInLine, strArray: title).count
    
        title = addSpace(numberOfSpace: remind_number_title/2) + title + addSpace(numberOfSpace: remind_number_title/2) + "\n\n"
        
        textData.append(title)
        
        var header = ""
        if (print_type == 3){//phiếu trả
            header =
                String(format: "Ten mon: %@\n", ConverHelper.convertVietNam(text: food_prints[0].name)) +
                String(format: "So luong da goi: %d\n", Int(food_prints[0].printed_quantity)) +
                String(format: "So luong su dung: %d\n", Int(food_prints[0].quantity)) +
                String(format: "So luong tra: %d\n", Int(food_prints[0].printed_quantity - food_prints[0].quantity)) +
                String(format: "Ma HD: %d\n", order.id) +
                String(format: "Ten Ban: %@\n",ConverHelper.convertVietNam(text: order.table_name)) +
                String(format: "Ghi chu: %@\n", ConverHelper.convertVietNam(text: "")) +
                String(format: "Nhan vien: %@\n", ConverHelper.convertVietNam(text: order.employee_name)) +
                String(format: "Ngay: %@\n", Utils.getFullCurrentDate()) +
                PrinterUtils.getLine80() + "\n\n\n\n\n"
            
            textData.append(header)
        }else{
            
            header =
                String(format: "Ngay: %@\n", Utils.getFullCurrentDate()) +
                String(format: "Ma HD: %d\n", order.id) +
                String(format: "Ban: %@\n",ConverHelper.convertVietNam(text: order.table_name)) +
                String(format: "Nhan vien: %@\n", ConverHelper.convertVietNam(text: order.employee_name)) + PrinterUtils.getLine80()
            
            textData.append(header)
            
            // Section 2 : Purchaced items
            for food in food_prints {

                //"Món gà số lượng thay đổi từ 2 thành 4"
                var item = ""
                let name = ConverHelper.convertVietNam(text: food.name)
                var quantity = ""
                
                if print_type == PRINT_TYPE_ADD_FOOD ||  print_type == PRINT_TYPE_CANCEL_FOOD{
          
                    quantity = String(format: food.is_sell_by_weight == ACTIVE ? "%.2f" : "%.0f", food.quantity)
                    
                    
                    item = getTextInALine(totalSpace: totalCharInLine, str1:name, str2:quantity) + "\n"
                    
                    for childFood in food.order_detail_additions{
                        item.append(String(format: " + %@ x %d\n", ConverHelper.convertVietNam(text: childFood.name), Int(childFood.quantity)))
                    }

                } else if print_type == PRINT_TYPE_RETURN_FOOD{
                    quantity = String(format: "%d\n", Int(food.printed_quantity) - Int(food.quantity))
                    
                    item = getTextInALine(totalSpace: totalCharInLine, str1:name, str2:quantity)
       
                }
                
                textData.append(item)
                
                if !food.note.isEmpty {
                   let note = food.note.folding(options: .diacriticInsensitive, locale: .current)
                   textData.append(String(format: "(%@)\n", note))
                }
                
                textData.append(PrinterUtils.getLine80())
            }
            
            textData.append("\n\n\n\n\n\n")
        }
        dLog(textData)
       
        
        PrinterUtils.printTextData(client: client, text_data: textData.substring(from: 0), order_detail_id: food_prints[0].id)
        
        client.close()
        
    }
    
    

    static func PrintReceipt(order:OrderDetailData,printItems:[OrderItem],printer:Kitchen){
        switch printer.printer_type{
            case 0:
                DispatchQueue(label: "queue", attributes: .concurrent).async { [self] in
                    PrintReceiptByWifi(order: order,printItems: printItems,printer: printer)
                }
                break
            case 4:
                PrintReceiptByBLE(order:order,printItems:printItems)
            default:
                break
        }
        
    }
    
    static func PrintReceiptByWifi(order:OrderDetailData,printItems:[OrderItem],printer:Kitchen) {
      
        let client = TCPClient(address: printer.printer_ip_address, port: Int32(printer.printer_port) ?? 0)
        
        //tổng số ký tự trong 1 dòng
        let totalCharInLine = getTotalSpaceInALine()
    
        
        let textData: NSMutableString = NSMutableString()
        var header = ""

        header +=   addMiddleAlignedText(word: "HOA DON THANH TOAN", totalCharInLine: totalCharInLine) + "\n" +
                    addMiddleAlignedText(word: String(format: "SO: #%d ", order.id), totalCharInLine: totalCharInLine) + "\n\n" +
                    String(format: "Ngay: %@\n", Utils.getFullCurrentDate()) +
                    ConverHelper.convertVietNam(text: String(format: "Ban: %@\n", order.table_name)) +
                    String(format: "Quan: %@\n", ConverHelper.convertVietNam(text: ManageCacheObject.getCurrentUser().branch_name)) +
                    String(format: "CSKH: %@\n", ConverHelper.convertVietNam(text: ManageCacheObject.getCurrentBranch().phone)) +
                    String(format: "Dia chi: %@\n", ConverHelper.convertVietNam(text: ManageCacheObject.getCurrentBranch().street_name)) +
                    String(format: "Nhan vien: %@\n\n\n", ConverHelper.convertVietNam(text: order.employee_name)) +
                    String(format: "%@                               %@\n", "TEN MON", "THANH TIEN") + PrinterUtils.getLine80()
                    
        textData.append(header)


        // Section 2 : Purchaced items
        for item in printItems {
            
            
            //"Món gà số lượng thay đổi từ 2 thành 4"
            var form = ""
            let name = ConverHelper.convertVietNam(text: item.name)
            let quantity =  String(format: item.is_sell_by_weight == ACTIVE ? "%.2f x %@\n" : "%.0f x %@\n", item.quantity, Utils.stringVietnameseMoneyFormatWithNumberInt(amount: item.price))
            let totalAmount = String(format: "%@", Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(item.price) * Float(item.quantity)))
            
    
        
            
            item.is_gift == ACTIVE
            ? {form = getTextInALine(totalSpace: totalCharInLine, str1:name, str2:"MON TANG") + "\n"}()
            : {form = getTextInALine(totalSpace: totalCharInLine, str1:name, str2:totalAmount) + "\n"}()
           
        
            
            switch item.category_type{
                case SERVICE:
                    let usedTime = String(format: "%@ -> %@ (%@)\n",
                                          TimeUtils.convertToDateFormatForService(dateStr: item.service_start_time),
                                          TimeUtils.convertToDateFormatForService(dateStr: item.service_end_time),
                                          TimeUtils.ConvertMinutetoHourMinuteFormat(item.service_time_used))
                  
                    form += usedTime
                    break
                default:
                    form += quantity
                    break
            }

                       
            for childFood in item.order_detail_additions{
                form += String(format: " + %@ x %d\n", ConverHelper.convertVietNam(text: childFood.name), Int(childFood.quantity))
            }
            
            for childFood in item.order_detail_combo{
                form += String(format: " + %@\n", ConverHelper.convertVietNam(text: childFood.name))
            }
            
            
            if !item.note.isEmpty {
               let note = item.note.folding(options: .diacriticInsensitive, locale: .current)
                form += String(format: "(%@)\n", note)
            }
 
            form += PrinterUtils.getLine80()

            textData.append(form)
        }
        
        var summary = "\n"
        let payment = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.total_amount))
        let totalDiscount = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.discount_amount))
        let totalVAT = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.vat_amount))
        let netPayment = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.total_final_amount))
        summary += getTextInALine(totalSpace: totalCharInLine, str1:"THANH TIEN:", str2:payment) + "\n"
        
        
        if order.food_discount_percent > 0 || order.drink_discount_percent > 0{
            
            summary += getTextInALine(totalSpace: totalCharInLine, str1:"GIAM GIA:", str2:totalDiscount) + "\n"
            summary += getTextInALine(totalSpace: totalCharInLine, str1:String(format: "  + MON AN(%d%%)", order.food_discount_percent), str2:Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.food_discount_amount)) + "\n"
            summary += getTextInALine(totalSpace: totalCharInLine, str1:String(format: "  + THUC UONG(%d%%)", order.drink_discount_percent), str2:Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.drink_discount_amount)) + "\n"
        }else if order.total_amount_discount_percent > 0{
            summary += getTextInALine(totalSpace: totalCharInLine, str1:"GIAM GIA (TONG BILL):", str2:totalDiscount) + "\n"
        }else{
    
            summary += getTextInALine(totalSpace: totalCharInLine, str1:"GIAM GIA:", str2:totalDiscount) + "\n"
        }
        
        summary += getTextInALine(totalSpace: totalCharInLine, str1:"VAT:", str2:totalVAT) + "\n"
        summary += getTextInALine(totalSpace: totalCharInLine, str1:"THANH TOAN:", str2:netPayment) + "\n"
        summary += PrinterUtils.getLine80() + "\n"
        if order.is_apply_vat == DEACTIVE{
            summary += addMiddleAlignedText(word: "GIA CHUA BAO GOM THUE VAT", totalCharInLine: totalCharInLine) + "\n"
        }
        summary += addMiddleAlignedText(word: "CHAN THANH CAM ON QUY KHACH!", totalCharInLine: totalCharInLine) + "\n"
        summary += PrinterUtils.getLine80() + "\n"
        summary += addMiddleAlignedText(word: "TECHRES.VN DUOC PHAT TRIEN BOI OVERATE-VNTECH", totalCharInLine: totalCharInLine) + "\n"
              
        summary += "\n\n\n\n\n\n\n"
        
        textData.append(summary)//1

               
        print(textData.substring(from: 0))
    
        PrinterUtils.printTextData(client: client, text_data: ConverHelper.convertVietNam(text: textData.substring(from: 0)))
        client.close()
    }
    
    
    static func PrintReceiptByBLE(order:OrderDetailData,printItems:[OrderItem]) {
      
        let receipt = Receipt(.init(maxWidthDensity: 480, fontDensity: 10, encoding: .utf8))
        receipt <<~ .style(.clear)
        receipt <<~ .style(.initialize)
        receipt <<~ .page(.printAndFeed(lines: 2))
        receipt <<~ .layout(.justification(.center)) <<~ .style(.emphasis(enable: true))
        receipt <<< "HOA DON THANH TOAN"
        receipt <<< String(format: "Ma HD: #%d\n\n", order.id)  <<~ .style(.emphasis(enable: false))

        receipt <<~ .layout(.justification(.left))
        receipt <<< String(format:"Ngay: %@", Utils.getFullCurrentDate())
        receipt <<< String(format:"Ban: %@", order.table_name)
        receipt <<< String(format: "Quan: %@", ConverHelper.convertVietNam(text: ManageCacheObject.getCurrentUser().branch_name))
        receipt <<< String(format: "CSKH: %@", ConverHelper.convertVietNam(text: ManageCacheObject.getCurrentBranch().phone))
        receipt <<< String(format: "Dia chi: %@", ConverHelper.convertVietNam(text: ManageCacheObject.getCurrentBranch().street_name))
        receipt <<< String(format: "Nhan vien: %@\n", ConverHelper.convertVietNam(text: order.employee_name))
       
        receipt <<< KVItem("TEN MON", "THANH TIEN")
        receipt <<~ .style(.emphasis(enable: true)) <<< Dividing.default(provider: "-") <<~ .style(.emphasis(enable: false))
        
        
    
        for item in printItems {
      
            var form = ""
            let name = ConverHelper.convertVietNam(text: item.name)
            let quantity =  String(format: item.is_sell_by_weight == ACTIVE ? "%.2f x %@" : "%.0f x %@", item.quantity, Utils.stringVietnameseMoneyFormatWithNumberInt(amount: item.price))
            let totalAmount = String(format: "%@", Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(item.price) * Float(item.quantity)))
            
          
            if name.count > 30{
                
                //tổng số ký tự trong 1 dòng
                let totalCharInLine = getTotalSpaceInALine()
                
                item.is_gift == ACTIVE
                ? {receipt <<< getTextInALine(totalSpace: totalCharInLine, str1:name, str2:"MON TANG")}()
                : {receipt <<< getTextInALine(totalSpace: totalCharInLine, str1:name, str2:totalAmount)}()

            }else {
                item.is_gift == ACTIVE
                ? { receipt <<< KVItem(name,"MON TANG")}()
                : { receipt <<< KVItem(name,totalAmount)}()
            }
            

            switch item.category_type{
                case SERVICE:
                    let usedTime = String(format: "%@ -> %@ (%@)",
                                          TimeUtils.convertToDateFormatForService(dateStr: item.service_start_time),
                                          TimeUtils.convertToDateFormatForService(dateStr: item.service_end_time),
                                          TimeUtils.ConvertMinutetoHourMinuteFormat(item.service_time_used))
                    receipt <<< usedTime
                    break
                default:
                    receipt <<< quantity
                    break
            }

                       
            for childFood in item.order_detail_additions{
                receipt <<< String(format: " + %@ x %d", ConverHelper.convertVietNam(text: childFood.name), Int(childFood.quantity))
    
            }
            
            for childFood in item.order_detail_combo{
                receipt <<< String(format: " + %@", ConverHelper.convertVietNam(text: childFood.name))
            }
            
            
            if !item.note.isEmpty {
                receipt <<< String(format: "(%@)", item.note.folding(options: .diacriticInsensitive, locale: .current))
            }
 
            receipt <<~ .style(.emphasis(enable: true)) <<< Dividing.default(provider: "-") <<~ .style(.emphasis(enable: false))
        }
        

        let payment = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.total_amount))
        let totalDiscount = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.discount_amount))
        let totalVAT = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.vat_amount))
        let netPayment = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.total_final_amount))
        
        
        
        receipt <<< KVItem("THANH TIEN:",payment)
   
        
        if order.food_discount_percent > 0 || order.drink_discount_percent > 0{
            receipt <<< KVItem("GIAM GIA:",totalDiscount)
            receipt <<< KVItem(String(format: "  + MON AN(%d%%)", order.food_discount_percent),Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.food_discount_amount))
            receipt <<< KVItem(String(format: "  + THUC UONG(%d%%)", order.drink_discount_percent),Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.drink_discount_amount))
        }else if order.total_amount_discount_percent > 0{
            receipt <<< KVItem("GIAM GIA (TONG BILL):",totalDiscount)
        }else{
            receipt <<< KVItem("GIAM GIA:",totalDiscount)
        }
        
        receipt <<< KVItem("VAT:",totalVAT)
        receipt <<< KVItem("THANH TOAN:",netPayment)
        receipt <<~ .style(.emphasis(enable: true)) <<< Dividing.default(provider: "-") <<~ .style(.emphasis(enable: false))
        
        receipt <<~ .layout(.justification(.center))
 
        if order.is_apply_vat == DEACTIVE{
            receipt <<< "GIA CHUA BAO GOM THUE VAT"
        }
        receipt <<< "CHAN THANH CAM ON QUY KHACH!"
        receipt <<< Dividing.default(provider: "-")
        receipt <<< "TECHRES.VN DUOC PHAT TRIEN BOI OVERATE-VNTECH"
        receipt <<~ .page(.printAndFeed(lines: 4))
        
        if bluetoothManager.canPrint {
            bluetoothManager.write(Data(receipt.data))
        }
    }
    
    
    
    
}
