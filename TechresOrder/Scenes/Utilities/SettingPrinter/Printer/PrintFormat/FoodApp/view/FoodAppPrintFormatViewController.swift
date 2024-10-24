//
//  FoodAppPrintFormatViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//

import UIKit

class FoodAppPrintFormatViewController: BaseViewController {
    
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var lbl_already_printed_number: UILabel!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var generalView: UIView!
    
    @IBOutlet weak var view_of_print_receipt: UIStackView!
    
    @IBOutlet weak var lbl_name_of_food_app_partner: UILabel!
    
    @IBOutlet weak var lbl_restaurant_name: UILabel!
    
    @IBOutlet weak var lbl_table_type: UILabel!
    
    @IBOutlet weak var lbl_address: UILabel!
    
    @IBOutlet weak var lbl_cumtomer_service: UILabel!
    
    @IBOutlet weak var lbl_order_id: UILabel!
    
    @IBOutlet weak var lbl_display_id: UILabel!
    
    @IBOutlet weak var lbl_driver_name: UILabel!
    
    @IBOutlet weak var lbl_driver_phone: UILabel!
    
    @IBOutlet weak var lbl_employee_name: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var height_of_table: NSLayoutConstraint!

    //===================Tổng hoá đơn==================
    
    @IBOutlet weak var lbl_title_total_payment: UILabel!
    
    @IBOutlet weak var lbl_total_payment: UILabel!
    
    
    //===================restaurant discount==================
    @IBOutlet weak var view_of_restaurant_discount: UIView!
    @IBOutlet weak var lbl_restaurant_discount: UILabel!
    //===================customer discount==================
    @IBOutlet weak var view_of_customer_discount: UIView!
    @IBOutlet weak var lbl_customer_discount: UILabel!
    
    //===================shipping fee==================
    @IBOutlet weak var view_of_shipping_fee: UIView!
    @IBOutlet weak var lbl_shipping_fee: UILabel!
    
    //===================VAT==================
    @IBOutlet weak var lbl_total_vat: UILabel!
    
    //=====================Payment======================================================
    @IBOutlet weak var lbl_customer_order_amount: UILabel!
    
    //=========================greeting==================================
    @IBOutlet weak var view_of_copy_right: UIView!
    
    //================================================================================================================================================================================================

    //===========================print stamp using TSC Printer=====================================
        
    @IBOutlet weak var view_of_print_stamp: UIStackView!
    
    @IBOutlet weak var view_of_stamp_1: UIView!
    
    @IBOutlet weak var lbl_stamp1_order: UILabel!
    
//    @IBOutlet weak var lbl_stamp1_FoodApp_order_id: UILabel!
    
    @IBOutlet weak var lbl_stamp1_order_id: UILabel!
    
    @IBOutlet weak var lbl_stamp1_item_name: UILabel!
    
    @IBOutlet weak var lbl_stamp1_children_item: UILabel!
    
    @IBOutlet weak var lbl_stamp1_note: UILabel!
    
    @IBOutlet weak var lbl_stamp1_price: UILabel!
    @IBOutlet weak var lbl_stamp1_date: UILabel!
    
    //==============================================================================================
    
    @IBOutlet weak var view_of_stamp_2: UIView!
    
    @IBOutlet weak var lbl_stamp2_order: UILabel!
    
//    @IBOutlet weak var lbl_stamp2_FoodApp_order_id: UILabel!
    
    @IBOutlet weak var lbl_stamp2_order_id: UILabel!
    
    @IBOutlet weak var lbl_stamp2_item_name: UILabel!
    
    @IBOutlet weak var lbl_stamp2_children_item: UILabel!
    
    @IBOutlet weak var lbl_stamp2_note: UILabel!
    
    @IBOutlet weak var lbl_stamp2_price: UILabel!
    @IBOutlet weak var lbl_stamp2_date: UILabel!
    //================================================================================================================================================================================================



    var printers:[Printer] = []

    
    var orders:[FoodAppOrder] = []
    
    var isCustomerOrder:Bool = true
    var printType = Constants.printType.new_item
    
    let POSPrinterUtility = CustomPOSPrinter.shared()
    let TSCPrinterUtility = TSCPrinter.shared()
    let BLEPrinterUtility = BLEPrinter.shared()
  
    
    var progressBarTimer: Timer!
    var progressPercent: Float = 0.0
    var viewModel = FoodAppPrintFormatViewModel()
    var completeHandler:(()->Void)? = nil
    
    let textColor:UIColor = .systemGray4
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        bindTableViewAndRegisterCell()
        firstSetup()
    }
    


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.orders.accept(orders)
        viewModel.printType.accept(printType)
        
        
        PrinterUtils.shared.stopPrintBackGround()

        
        for order in viewModel.orders.value{
            
            viewModel.order.accept(order)
            
            for printer in printers {
    
                switch printer.type{
    
                    case .stamp_of_food_app:
                        printTSC(printer: printer,order: order)
    
                    case .cashier_of_food_app:
                        printdata(printer:printer,order: order,islastItem: true)
                        break
                    
                    default:
                        break
                }
    
            }

        }
        
        
        calculatePrintNumber()
      
        if let wifiWorkItem = viewModel.WIFIWorkItems.value.first{
            wifiWorkItem.connectionWork.perform()
//            backGroundQueue.async(group: dispatchGroup, execute: {[self] in
//                wifiWorkItem.connectionWork.perform()
//            })
            
        }
        
        

        if let TSCEWorkItem = viewModel.TSCWorkItem.value{

            TSCEWorkItem.connectionWork.perform()
            
        }
        
    }

    private func calculatePrintNumber() {
        var printNumber = 0
        
        for _ in viewModel.WIFIWorkItems.value{
            printNumber += 1
        }
        
    
        viewModel.totalWIFIWorkItems.accept(viewModel.WIFIWorkItems.value.count)
        
        if let TSCWorkItem = viewModel.TSCWorkItem.value{
            printNumber += TSCWorkItem.image.count
        }
    
        viewModel.printNumber.accept(printNumber)

        lbl_already_printed_number.text = String(format: "%d/%d",0,printNumber)
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
        dismiss(animated: true,completion: {
            (self.completeHandler ?? {})()
            self.POSPrinterUtility?.wifiDisconnect()
            self.TSCPrinterUtility?.wifiDisconnect()
        })
    }



}
