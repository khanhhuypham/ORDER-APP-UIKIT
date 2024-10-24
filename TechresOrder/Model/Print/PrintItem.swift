//
//  PrintItem.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 19/01/2024.
//

import UIKit
import RealmSwift
import Realm


// Define the enum
enum print_type: Int, PersistableEnum {
    case wifi = 0
    case Imin = 1
    case sunmi = 2
    case usb = 3
    case blueTooth = 4
}



class PrinterObject: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var printer_ip_address = ""
    @Persisted var printer_name = ""
    @Persisted var printer_port = ""
    @Persisted var branch_id = 0
    @Persisted var printer_paper_size = 0
    @Persisted var is_have_printer = 0
    @Persisted var type:PRINTER_TYPE = .bar
    @Persisted var connection_type:CONNECTION_TYPE = .wifi
    @Persisted var is_print_each_food:Int = 0
    @Persisted var print_number:Int = 1
    @Persisted var WIFI_queued_items:List<WIFIQueuedItemObject>
    @Persisted var TSC_queued_items:List<TSCQueuedItemObject>
    
    @Persisted var isFoodAppPrinter:Bool = false
   

    convenience init(printer: Printer) {
        self.init()
        self.id = printer.id
        self.printer_ip_address = printer.printer_ip_address
        self.printer_name = printer.printer_name
        self.printer_port = printer.printer_port
        self.branch_id = printer.branch_id
        self.printer_paper_size = printer.printer_paper_size
        self.is_have_printer = printer.is_have_printer
        self.type = printer.type
        self.connection_type = printer.connection_type
        self.is_print_each_food = printer.is_print_each_food
        self.print_number = printer.print_number
        self.isFoodAppPrinter = printer.isFoodAppPrinter
    }
}


class WIFIQueuedItemObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var orderId:Int
    @Persisted var data:Data
    @Persisted var items:List<ItemObject>
    @Persisted var printer:PrinterObject?
    @Persisted var isLastItem:Bool = false
    @Persisted var created_at = Date()
    @Persisted var retryNumber:Int = 0
    @Persisted var isFinished:Bool = false
}


class ItemObject: EmbeddedObject {
    @Persisted var id = 0
    @Persisted var name = ""
    @Persisted var quantity:Float = 0
    @Persisted var is_sell_by_weight:Int = 0
    @Persisted var note = ""
    @Persisted var addition_foods:List<ChildItemObject>
    
    convenience init(item: Food) {
        self.init()
        self.id = item.id
        self.name = item.name
        self.quantity = item.quantity
        self.is_sell_by_weight = item.is_sell_by_weight
        self.note = item.note
        var childrenItem:[ChildItemObject] = []
        for child in item.addition_foods{
            childrenItem.append(ChildItemObject.init(child: child))
        }
    }
}

class ChildItemObject: EmbeddedObject {
    @Persisted var id = 0
    @Persisted var name = ""
    @Persisted var quantity = 0
    
    convenience init(child: FoodAddition) {
        self.init()
        self.id = child.id
        self.name = child.name
        self.quantity = child.quantity
    }
}


class TSCQueuedItemObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var orderId:String
    @Persisted var data:List<Data>
    @Persisted var printer:PrinterObject?
    @Persisted var isLastItem:Bool = false
    @Persisted var created_at = Date()
    @Persisted var retryNumber:Int = 0
    @Persisted var isFinished:Bool = false
}
