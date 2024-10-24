//
//  BankAccountSettingViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/04/2024.
//

import UIKit

class BankAccountSettingViewController: BaseViewController {
    var viewModel = BankAccountSettingViewModel()
    var router = BankAccountSettingRouter()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var view_btn: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        
        bindTableViewAndRegisterCell()
        
        view_btn.isHidden = true
        getBankAccount()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    
    @IBAction func actionCreateBankAccount(_ sender: Any) {
        presentasd()
    }
    
   
    
}
