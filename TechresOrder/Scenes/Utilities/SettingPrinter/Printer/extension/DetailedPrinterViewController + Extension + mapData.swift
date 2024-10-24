//
//  DetailedPrinterViewController + Extension + mapData.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/11/2023.
//

import UIKit

//MARK: setup and map data
extension DetailedPrinterViewController{
    
    func firstSetup(){
        btn_show_printing_queue.isHidden = true
    
//        if environmentMode == .staging && (printer.type == .chef || printer.type == .bar){
//            btn_show_printing_queue.isHidden = false
//        }else{
//            btn_show_printing_queue.isHidden = false
//        }
        
       
        _ = textfield_print_ipaddress.rx.text.map{[self] str in
            var printer = viewModel.printer.value
            printer.printer_ip_address = str ?? ""
            return printer
        }.bind(to:viewModel.printer).disposed(by: rxbag)
        
        _ = textfield_print_port.rx.text.map{[self] str in
            var printer = viewModel.printer.value
            printer.printer_port = str ?? ""
            return printer
        }.bind(to:viewModel.printer).disposed(by: rxbag)
    }
    
   
    
    
    func mapData(printer:Printer){
        view_of_device_type_switch.isHidden = printer.type == .stamp_of_food_app || printer.type == .cashier_of_food_app
        textfield_of_BLE_device_name.text = printer.printer_name
        textfield_print_ipaddress.text = printer.printer_ip_address
        textfield_print_port.text = printer.printer_port
        textfield_print_number.text = String(printer.print_number)
        printerSwitch.isOn = printer.is_have_printer == ACTIVE ? true : false
        if printer.type == .cashier || printer.type == .cashier_of_food_app{
            setupInterfaceForBillPrinter()
        }else if printer.type == .stamp || printer.type == .stamp_of_food_app{
            setupInterfaceForStampPrinter(printer: printer)
        }else if printer.type == .chef || printer.type == .bar{
            setupInterfaceForChefBarPrinter(printer: printer)
        }
 
       
        switch printer.connection_type{
            case .wifi:
                view_of_ip_address.isHidden = false
                view_of_port.isHidden = false
                view_of_device_name.isHidden = true
                device_type_switch.selectedSegmentIndex = 0
                break
            
            case .blueTooth:
                view_of_ip_address.isHidden = true
                view_of_port.isHidden = true
                view_of_device_name.isHidden = false
                device_type_switch.selectedSegmentIndex = 1

                break
            
            default:              
                device_type_switch.selectedSegmentIndex = 0
                actionSwitchDevice(device_type_switch)
            
                break
        }
             
    
       
    }
    

    
    private func setupInterfaceForBillPrinter(){
        lbl_header_options.isHidden = true
        btn_of_option1.isHidden = true
        btn_of_option2.isHidden = true
        view_of_printer_number.isHidden = true
       
    }
    private func setupInterfaceForStampPrinter(printer:Printer){
        btn_of_option1.setTitle("  50x30(mm)", for: .normal)
        btn_of_option2.setTitle("  30x20(mm)", for: .normal)
        btn_of_option1.setImage(UIImage(named: printer.printer_paper_size == 50 ? "icon-radio-checked" : "icon-radio-uncheck"), for: .normal)
        btn_of_option2.setImage(UIImage(named: printer.printer_paper_size == 30 ? "icon-radio-checked" : "icon-radio-uncheck"), for: .normal)
       
    }
    private func setupInterfaceForChefBarPrinter(printer:Printer){
        btn_of_option1.setTitle("  In order trên 1 phiếu", for: .normal)
        btn_of_option2.setTitle("  In riêng từng món", for: .normal)
        btn_of_option1.setImage(UIImage(named: printer.is_print_each_food == DEACTIVE ? "icon-radio-checked" : "icon-radio-uncheck"), for: .normal)
        btn_of_option2.setImage(UIImage(named: printer.is_print_each_food == ACTIVE ? "icon-radio-checked" : "icon-radio-uncheck"), for: .normal)
    }
}
