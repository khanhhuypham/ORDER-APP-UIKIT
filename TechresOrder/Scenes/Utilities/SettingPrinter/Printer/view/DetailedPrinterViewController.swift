//
//  StampPrinterViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/09/2023.
//

import UIKit
import RxSwift
import ExternalAccessory
class DetailedPrinterViewController: BaseViewController {

    var viewModel = DetailedPrinterViewModel()
    var router = DetailedPrinterRouter()
    var printer = Printer.init()

        
    
    @IBOutlet weak var device_type_switch: UISegmentedControl!
    @IBOutlet weak var view_of_device_type_switch: UIView!
    @IBOutlet weak var view_of_ip_address: UIView!
    @IBOutlet weak var view_of_port: UIView!
    
    @IBOutlet weak var textfield_print_ipaddress: UITextField!
    @IBOutlet weak var textfield_print_port: UITextField!
    
    @IBOutlet weak var view_of_device_name: UIView!
    @IBOutlet weak var textfield_of_BLE_device_name: UITextField!
    
    
    @IBOutlet weak var lbl_header_options: UILabel!
    @IBOutlet weak var btn_of_option1: UIButton!
    @IBOutlet weak var btn_of_option2: UIButton!
            
    @IBOutlet weak var view_of_printer_number: UIView!
    @IBOutlet weak var textfield_print_number: UITextField!
    @IBOutlet weak var printerSwitch: UISwitch!
    
    @IBOutlet weak var btn_show_printing_queue: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        firstSetup()
        viewModel.printer.accept(printer)
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view_of_device_name.isHidden = true
        mapData(printer: viewModel.printer.value)
        textfield_print_number.addTarget(self, action: #selector(textFieldDidEndEditing), for: UIControl.Event.editingChanged)
    }
    

    
    
    @IBAction func actionSwitchDevice(_ sender: UISegmentedControl) {
        var printer = viewModel.printer.value
      
        if sender.selectedSegmentIndex == 0{ // wifi
            printer.connection_type = .wifi
        }else if sender.selectedSegmentIndex == 1{ // bluetooth
            printer.connection_type = .blueTooth
        }
        viewModel.printer.accept(printer)
        mapData(printer: printer)
    }
    

    @IBAction func actionSearch(_ sender: Any) {
       presentDialogBLEInvestigator()
    }
     
    
    @IBAction func actionChooseOption1(_ sender: Any) {
        var printer = viewModel.printer.value
            
        if printer.type == .stamp || printer.type == .stamp_of_food_app {
            printer.printer_paper_size = 50
        }else if printer.type == .chef || printer.type == .bar{
            printer.is_print_each_food = DEACTIVE
        }
        
        viewModel.printer.accept(printer)
        mapData(printer: printer)
    }
    
    
    
    @IBAction func actionChooseOption2(_ sender: Any) {
        var printer = viewModel.printer.value
            
        if printer.type == .stamp || printer.type == .stamp_of_food_app {
            printer.printer_paper_size = 30
        }else if printer.type == .chef || printer.type == .bar{
            printer.is_print_each_food = ACTIVE
        }
        viewModel.printer.accept(printer)
        mapData(printer: printer)
    }
    
    
    @IBAction func actionTurnOnOffPrinter(_ sender: UISwitch) {
        var printer = viewModel.printer.value
        printer.is_have_printer = sender.isOn ? ACTIVE : DEACTIVE
        if device_type_switch.selectedSegmentIndex == 1{

        }
        viewModel.printer.accept(printer)
    }
    
    
    
    @IBAction func actionPrintTest(_ sender: Any) {
        var printer = viewModel.printer.value

        
        printer.type == .cashier_of_food_app || printer.type == .stamp_of_food_app
        ? printTestForFoodApp(printer: printer)
        : printTestForTechResOrderApp(printer: printer)
       
        
    }
    
    @IBAction func actionUpdate(_ sender: Any) {
//        
//        if self.printer.isFoodAppPrinter{
//            var foodAppPrinter = Constants.foodAppPrinters
//            if let p = foodAppPrinter.firstIndex(where: {$0.id == viewModel.printer.value.id}){
//                foodAppPrinter[p] = viewModel.printer.value
//                ManageCacheObject.SaveAppFoodPrinter(foodAppPrinter, cache_key: KEY_FOOD_APP_PRINTER)
//            }
//            actionBack("")
//        }else{
//            updateKitchen()
//        }
//        
        updateKitchen()
    }
    
    
    @IBAction func btn_show_printing_queue(_ sender: Any) {
        presentPrintingQueueViewController()
        
    }
    

    @IBAction func actionBack(_ sender: Any) {
        
        self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
            return vc.isKind(of: ReceiptPrintFormatViewController.self) ? true : false
        })
      
        viewModel.makePopViewController()
    }
    
    @objc internal func textFieldDidEndEditing(_ textField: UITextField) {
        
        /*
            nếu empty thì tự động trả về một
            chia lấy dự cho 10 để lấy dc số cuối cùng vì value thật chất là luôn > 10
         */
        var printer = viewModel.printer.value
        guard let value = Int(textField.text!) else {
            textField.text = String(1)
            printer.print_number = 1
            viewModel.printer.accept(printer)
            return
        }
        
       
        let remainder = value%10
        textField.text = String(remainder)

        if(remainder > 5){
            textField.text = String(5)
        }else if (remainder < 1){
            textField.text = String(1)
        }
        
        printer.print_number = Int(textField.text!) ?? 1
        viewModel.printer.accept(printer)
    }
    
}
