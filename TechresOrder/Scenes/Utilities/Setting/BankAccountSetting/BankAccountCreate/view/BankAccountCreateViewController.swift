//
//  BankAccountCreateViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/04/2024.
//

import UIKit

class BankAccountCreateViewController: BaseViewController {
    var viewModel = BankAccountCreateViewModel()
    var bankAccount:BankAccount?
    var completion:(() -> Void)?
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_bank: UILabel!
    @IBOutlet weak var btn_dropDown: UIButton!
    @IBOutlet weak var textfield_account_number: UITextField!
    @IBOutlet weak var textfield_account_holder: UITextField!
    @IBOutlet weak var btn_create: UIButton!
    
    let btnAttr = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular),
        NSAttributedString.Key.foregroundColor: ColorUtils.black()
    ]
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        // Do any additional setup after loading the view.
        getBankList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
        mapDataAndValidate()
     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    @IBAction func actionShowBankList(_ sender: UIButton) {
        showList(btn: sender,list: viewModel.bankList.value.map{String(format: "%@ - %@", $0.name, $0.short_name)})
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func actionCreate(_ sender: Any) {
        
        if bankAccount != nil {
            updateBankAccount(bankAccount: viewModel.bankAccount.value)
        }else{
            createBankAccount(bankAccount: viewModel.bankAccount.value)
        }
        
    }
    
}
