//
//  SettingPrinter_RebuildViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/09/2023.
//

import UIKit
import RealmSwift
class SettingPrinterViewController: BaseViewController {
    var viewModel = SettingPrinterViewModel()
    var router = SettingPrinterRouter()
    var isFoodApp:Bool = false
    
    
    @IBOutlet weak var view_of_printer_bill: UIView!
    
    @IBOutlet weak var view_of_printer_stamp: UIView!
    
    @IBOutlet weak var view_of_printer_chef_bar: UIView!
    
    @IBOutlet weak var tableView_of_printer_bill: UITableView!
    @IBOutlet weak var tableView_of_printer_stamp: UITableView!
    @IBOutlet weak var tableView_Of_printer_chef_bar: UITableView!
    
    @IBOutlet weak var height_of_printer_stamp_view: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        registerCellAndBindTable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if isFoodApp {
            view_of_printer_bill.isHidden = false
            view_of_printer_chef_bar.isHidden = true
         
        }else{
            
            view_of_printer_bill.isHidden = permissionUtils.GPBH_1_o_3 || (permissionUtils.GPBH_2_o_1 && permissionUtils.OwnerOrCashier) ? false : true
            
            view_of_printer_chef_bar.isHidden = false
            
        }
    
        getPrinters()
        
                
        PrinterUtils.shared.getBLEDevice()
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }

}
