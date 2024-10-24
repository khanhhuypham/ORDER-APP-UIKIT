//
//  BankAccountSetting + extension + registerCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/04/2024.
//

import UIKit
import RxSwift
extension BankAccountSettingViewController{
    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "BankAccountSettingTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "BankAccountSettingTableViewCell")
        
        tableView.rx.modelSelected(BankAccount.self) .subscribe(onNext: { element in
            
            self.presentasd(account: element)
            
        }).disposed(by: rxbag)

    }
    
    

    
    
    private func bindTableViewData() {
        viewModel.bankAccounts.bind(to: tableView.rx.items(cellIdentifier: "BankAccountSettingTableViewCell", cellType: BankAccountSettingTableViewCell.self))
           {  (row, account, cell) in
               cell.viewModel = self.viewModel
               cell.data = account
               cell.lbl_order.text = String(row + 1)
           }.disposed(by: rxbag)
       }
}
