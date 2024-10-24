//
//  LocalDataBaseUtils + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/07/2024.
//

import UIKit
import RealmSwift
extension LocalDataBaseUtils {
    
    
    static func savePrinters(printersArray:[Printer]){
        do {
            
            removePrinters()
            removeAllQueuedItem()
            
        
            var printers:[PrinterObject] = []
            
            for element in printersArray{
                let printer = PrinterObject()
                printer.id = element.id
                printer.printer_ip_address = element.printer_ip_address
                printer.printer_name = element.printer_name
                printer.printer_port = element.printer_port
                printer.branch_id = element.branch_id
                printer.printer_paper_size = element.printer_paper_size
                printer.is_have_printer = element.is_have_printer
                printer.is_print_each_food = element.is_print_each_food
                printers.append(printer)
            }
            
            // realm
            let realm = try Realm()
            //realm write
            try! realm.write {
                realm.add(printers)
            }
            
        } catch let error{
            dLog(error.localizedDescription)
            return
        }
    }
    
    
    static func updatePrinters(printersArray:[Printer]){
        do {
                    
            // realm
            let realm = try Realm()
            let printerObjects = realm.objects(PrinterObject.self).where{
                $0.id.in(printersArray.map{$0.id})
            }
            
   
            try! realm.write {
                

                for printer in printersArray{
                    
                    if let position = printerObjects.firstIndex(where: {$0.id == printer.id}){
                        printerObjects[position].printer_ip_address = printer.printer_ip_address
                        printerObjects[position].printer_name = printer.printer_name
                        printerObjects[position].printer_port = printer.printer_port
                        printerObjects[position].branch_id = printer.branch_id
                        printerObjects[position].printer_paper_size = printer.printer_paper_size
                        printerObjects[position].is_have_printer = printer.is_have_printer
                        printerObjects[position].is_print_each_food = printer.is_print_each_food
                    }
                }
                
            }
            
        } catch let error{
            dLog(error.localizedDescription)
            return
        }
    }
    
    
    static func removePrinters() {
        do {
            let realm = try Realm()
            
            let printer = realm.objects(PrinterObject.self)
            
            try realm.write {
                realm.delete(printer)
            }
            
                       
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
