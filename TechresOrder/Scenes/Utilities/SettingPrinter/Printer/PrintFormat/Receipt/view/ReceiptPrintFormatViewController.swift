//
//  ReceiptPrintFormatViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/12/2023.
// https://download4.epson.biz/sec_pubs/pos/reference_en/index.html

import UIKit
import JonAlert

class ReceiptPrintFormatViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lbl_already_printed_number: UILabel!
    
 
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var lbl_name_of_food_app_partner: UILabel!
    
    @IBOutlet weak var lbl_restaurant_name: UILabel!
    
    @IBOutlet weak var lbl_table_type: UILabel!
    
    @IBOutlet weak var lbl_address: UILabel!
    
    @IBOutlet weak var lbl_cumtomer_service: UILabel!
    
    @IBOutlet weak var lbl_table_name: UILabel!
    
    @IBOutlet weak var lbl_employee_name: UILabel!
    
    @IBOutlet weak var view_of_saler: UIView!
    @IBOutlet weak var lbl_saler: UILabel!
    
    @IBOutlet weak var view_of_accumulative_point: UIView!
    @IBOutlet weak var lbl_accumulative_point: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    
    @IBOutlet weak var lbl_title_SL: UILabel!
    @IBOutlet weak var lbl_title_DG: UILabel!
    
       
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var height_of_table: NSLayoutConstraint!

    //===================tặng==================
    @IBOutlet weak var view_of_gift: UIView!
    @IBOutlet weak var lbl_total_gifted: UILabel!
    
    //===================Tổng hoá đơn==================
    @IBOutlet weak var lbl_title_total_payment: UILabel!
    @IBOutlet weak var lbl_total_payment: UILabel!
    
    //=========================Điểm sử dụng==================================
    @IBOutlet weak var view_of_used_point: UIView!
    
    //===================service Charge==================
    @IBOutlet weak var view_of_service_charge: UIView!
    @IBOutlet weak var lbl_total_service_charge: UILabel!
    
    //===================extra Charge==================
    @IBOutlet weak var view_of_extra_charge: UIView!
    @IBOutlet weak var lbl_total_extra_charge: UILabel!
    
    //===================VAT==================
    @IBOutlet weak var view_of_vat: UIView!
    
    @IBOutlet weak var lbl_vat_title: UILabel!
    @IBOutlet weak var lbl_total_vat: UILabel!
    
    //===================Discount==================
    
    @IBOutlet weak var stack_view_of_discount: UIStackView!
    @IBOutlet weak var lbl_discount_percent: UILabel!
    @IBOutlet weak var lbl_total_discount: UILabel!
    @IBOutlet weak var view_of_discount_detail: UIView!
    
    @IBOutlet weak var lbl_discount_percent_of_food: UILabel!
    @IBOutlet weak var lbl_discount_percent_of_drink: UILabel!

    //=========================tiền đặt cọc==================================
    @IBOutlet weak var deposit_amount: UILabel!
    @IBOutlet weak var view_of_deposit: UIView!
    
    
    //=====================Payment======================================================
    @IBOutlet weak var net_payment: UILabel!
    @IBOutlet weak var title_net_payment: UILabel!
    
    //=========================tiền khách trả==================================
    @IBOutlet weak var view_of_return_amount: UIView!
    @IBOutlet weak var returned_amount: UILabel!
    
    //=========================tiền khách thừa==================================
    @IBOutlet weak var view_of_change_amount: UIView!
    @IBOutlet weak var change_amount: UILabel!
    
    //=========================QR code==================================
    @IBOutlet weak var qr_code_view: UIView!
    @IBOutlet weak var qr_code_img_view:UIImageView?
    @IBOutlet weak var lbl_account_number: UILabel!
    @IBOutlet weak var lbl_bank: UILabel!
    @IBOutlet weak var lbl_account_holder: UILabel!
    
    //=========================greeting==================================
    @IBOutlet weak var view_of_greeting: UIView!
    @IBOutlet weak var view_of_vat_content: UIView!
    @IBOutlet weak var vat_content: UILabel!
    @IBOutlet weak var greeting_content: UILabel!
    @IBOutlet weak var top_contraint_of_greeting_content: NSLayoutConstraint!
    
    //=========================greeting==================================
    @IBOutlet weak var view_of_copy_right: UIView!
    
    
    
    var viewModel = ReceiptPrintFormatViewModel()
    var printer = Printer()
    //MARK: order from techres order app
    var order:OrderDetail? = nil
    var bankAccount:BankAccount?

    
    
    var completeHandler:(()->Void)? = nil
    var POSPrinterUtility = CustomPOSPrinter.shared()
    var BLEPrinterUtility = BLEPrinter.shared()
    var timerOFCheckingPrinterStatus: Timer?
    
    var progressBarTimer: Timer!
    var progressPercent: Float = 0.0

    
    
    let mainQueue = DispatchQueue(label: "main queue",qos:.userInteractive,target: .main)
    let backGroundQueue = DispatchQueue(label: "background queue",qos:.utility,autoreleaseFrequency:.workItem)
    let dispatchGroup = DispatchGroup()
    
    let textColor:UIColor = .systemGray4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        registerCell()
        firstSetup()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PrinterUtils.shared.stopPrintBackGround()

        
    
        if let order = self.order{
            
            if let bankAccount = self.bankAccount {
                setupBill(order:order,bankAccount: bankAccount)
                performWorkItem(printer:printer)
            }else{
                self.dismiss(animated: true, completion: {
                    JonAlert.showError(message: "Chưa có thông tin tài khoản ngân hàng để thanh toán")
                })

            }
        }
        
        
        

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        PrinterUtils.shared.performPrintBackGround()
        timerOFCheckingPrinterStatus?.invalidate()
        timerOFCheckingPrinterStatus = nil
        
    }
    
    
    
}







