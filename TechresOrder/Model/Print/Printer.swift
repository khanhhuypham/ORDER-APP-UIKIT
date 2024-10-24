//
//  Kitchen.swift
//  TechresOrder
//
//  Created by Kelvin on 17/01/2023.
//

import UIKit
import ObjectMapper


@objc class Printer: NSObject, Mappable {

    var id = 0
    @objc var name = ""
    var descript = ""
    var restaurant_id = 0
    var branch_id = 0
    var restaurant_brand_id = 0
    var status = 0
    var branch_name = ""
    var type:PRINTER_TYPE = .bar
    var printer_name = ""
    @objc var printer_ip_address = ""
    @objc var printer_port = ""
    @objc var printer_paper_size = 1
    var is_have_printer = 0
    var created_at = ""
    var updated_at = ""
    var is_print_each_food:Int = 0
    @objc var connection_type:CONNECTION_TYPE = .wifi
    var print_number:Int = 1
    var isFoodAppPrinter:Bool = false

    
    override init(){}
    
    init(id:Int,name:String,printerName:String,type:PRINTER_TYPE,paperSize:Int? = nil,isFoodAppPrinter:Bool){
        self.id = id
        self.name = name
        self.printer_name = printerName
        self.type = type
        if let paperSize = paperSize{
            self.printer_paper_size = paperSize
        }
        self.isFoodAppPrinter = isFoodAppPrinter
    }

    
    required init?(map: Map) {}
    
    init(printerObject:PrinterObject){
        self.id = printerObject.id
        self.branch_id = printerObject.branch_id
        self.printer_name = printerObject.printer_name
        self.printer_ip_address = printerObject.printer_ip_address
        self.printer_port = printerObject.printer_port
        self.printer_paper_size = printerObject.printer_paper_size
        self.is_have_printer = printerObject.is_have_printer
        self.is_print_each_food = printerObject.is_have_printer
        self.type = printerObject.type
        self.connection_type = printerObject.connection_type
        self.print_number = printerObject.print_number
    }

    func mapping(map: Map) {
        id                                      <- map["id"]
        name                                    <- map["name"]
        descript                             <- map["description"]
        restaurant_id                           <- map["restaurant_id"]
        status                                  <- map["status"]
        branch_id                               <- map["branch_id"]
        branch_name                             <- map["branch_name"]
        created_at                              <- map["created_at"]
        updated_at                              <- map["updated_at"]
        printer_name                              <- map["printer_name"]
        printer_ip_address                              <- map["printer_ip_address"]
        printer_port                              <- map["printer_port"]
        printer_paper_size                              <- map["printer_paper_size"]
        print_number                         <- map["print_number"]
        is_have_printer                              <- map["is_have_printer"]
        is_print_each_food                       <- map["is_print_each_food"]
        type                       <- map["type"]
        connection_type                       <- map["printer_type"]
        isFoodAppPrinter <- map["isFoodAppPrinter"]
    }
}



@objc class Kitchen:NSObject {
    
    var identifier:String = ""
    var name = ""
    var mtu = 0
    var state:CBPeripheralState = .disconnected
    
}

