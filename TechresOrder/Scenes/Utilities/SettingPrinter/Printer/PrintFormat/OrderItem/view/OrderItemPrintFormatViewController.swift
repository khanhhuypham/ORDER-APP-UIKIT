//
//  OrderItemPrintFormatViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/12/2023.
//

import UIKit
import RxSwift

class OrderItemPrintFormatViewController: BaseViewController {
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var lbl_already_printed_number: UILabel!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var generalView: UIView!
    
    
//===========================print food using POS Printer=====================================
    
    @IBOutlet weak var view_of_print_food: UIStackView!
    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_item_name: UILabel!
    
    @IBOutlet weak var lbl_ordered_quantity: UILabel!
    
    @IBOutlet weak var lbl_used_quantity: UILabel!
    
    @IBOutlet weak var lbl_returned_quantity: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    
    @IBOutlet weak var lbl_order_id: UILabel!
    
    @IBOutlet weak var lbl_table_name: UILabel!
    
    
    @IBOutlet weak var lbl_note: UILabel!
    
    @IBOutlet weak var lbl_employee_name: UILabel!
    
    @IBOutlet weak var view_of_table: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    
//===========================print stamp using TSC Printer=====================================
    
    @IBOutlet weak var view_of_print_stamp: UIStackView!
    
    @IBOutlet weak var view_of_stamp_1: UIView!
    
    @IBOutlet weak var lbl_stamp1_date: UILabel!
    
    @IBOutlet weak var lbl_stamp1_order_id: UILabel!
    
    @IBOutlet weak var lbl_stamp1_item_name: UILabel!
    
    @IBOutlet weak var lbl_stamp1_children_item: UILabel!
    
    @IBOutlet weak var lbl_stamp1_note: UILabel!
    
    @IBOutlet weak var lbl_stamp1_price: UILabel!
    
    @IBOutlet weak var view_of_stamp_2: UIView!
    
    @IBOutlet weak var lbl_stamp2_date: UILabel!
    
    @IBOutlet weak var lbl_stamp2_order_id: UILabel!
    
    @IBOutlet weak var lbl_stamp2_item_name: UILabel!
    
    @IBOutlet weak var lbl_stamp2_children_item: UILabel!
    
    @IBOutlet weak var lbl_stamp2_note: UILabel!
    
    @IBOutlet weak var lbl_stamp2_price: UILabel!
    
//================================================================================================================================================================================================

    
    var printers:[Printer] = []
    var order = OrderDetail.init()
    var printItem:[Food] = []
    var printType = Constants.printType.new_item
    
    let POSPrinterUtility = CustomPOSPrinter.shared()
    let TSCPrinterUtility = TSCPrinter.shared()
    let BLEPrinterUtility = BLEPrinter.shared()
  
    
    var progressBarTimer: Timer!
    var progressPercent: Float = 0.0
    var viewModel = OrderItemPrintFormatViewModel()
    var completeHandler:(()->Void)? = nil

    
    let textColor:UIColor = .systemGray4
    
    //================================================================
    let backGroundQueue = DispatchQueue(label: "background queue",qos:.utility,autoreleaseFrequency:.workItem)
    let mainQueue =  DispatchQueue(label: "main queue",qos:.userInteractive,target: .main)
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        bindTableViewAndRegisterCell()
        firstSetup()
    }
    


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.order.accept(order)

        viewModel.printType.accept(printType)

        LocalDataBaseUtils.removeWifiQueuedItemByOrderId(orderId: order.id)
        
        PrinterUtils.shared.stopPrintBackGround()
        
        
        for printer in printers {
          
            let printItems = self.printItem.filter{$0.restaurant_kitchen_place_id == printer.id}
            
            if printItems.isEmpty{ // this case is for stamp printer
                printTSC(printer:printer,order:order,printItems:printItem)
            }else{ // this case is for normal printer
                
                switch printer.connection_type{
                    case .blueTooth:
                        printBLE(printer: printer, order: order, printItems: printItems)
                    
                    case .wifi:
                        printWIFI(printer: printer, order: order, printItems: printItems)
                    
                    default:
                        break
//                        messageBox("Thiết bị đang sử dụng chỉ hỗ trợ đối với máy in rời", withTitle: "Cảnh báo", withAutoDismiss: true)
                        
                }
                
            }
            
        }
        
        
        viewModel.calculatePrintNumber()
        
        if let wifiWorkItem = viewModel.WIFIWorkItem.value.first{
            
            backGroundQueue.async(group: dispatchGroup, execute: {[self] in
                wifiWorkItem.connectionWork.perform()
            })
            
        }
        
        
        if let BLEWorkItem = viewModel.BLEWorkItem.value{
            backGroundQueue.async(group: dispatchGroup, execute: {[self] in
                BLEWorkItem.connectionWork.perform()
           })
        }
        
        
        if let TSCEWorkItem = viewModel.TSCWorkItem.value{
            backGroundQueue.async(group: dispatchGroup, execute: {[self] in
                TSCEWorkItem.connectionWork.perform()
           })
            
        }
        

    }

    
    func address<T: AnyObject>(of object: T) -> Int {
        return unsafeBitCast(object, to: Int.self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        POSPrinterUtility?.wifiDisconnect()
        NotificationCenter.default.removeObserver(self)
        PrinterUtils.shared.performPrintBackGround()
        
    }
        
    @IBAction func actionBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
    
}





