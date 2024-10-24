//
//  EditBuffetTicketViewController + extension + API.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/05/2024.
//

import UIKit
import RxSwift
import JonAlert


//MARK: set up data, UITextFieldDelegate
extension EditBuffetTicketViewController{
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var buffet = viewModel.buffet.value
                
        buffet.setQuantity(quantity: Int(textfield_quantity.text ?? "0") ?? 0)
        
        viewModel.buffet.accept(buffet)
    }
    
    func mapData() {
        
        var buffet = viewModel.buffet.value
        lbl_name.text = buffet.buffet_ticket_name
        lbl_amount.text = Utils.stringQuantityFormatWithNumber(amount: buffet.total_final_amount)
        
        
        textfield_quantity.text = String(buffet.adult_quantity)
        textfield_quantity.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfield_quantity.setMaxValue(maxValue: 999)
        tableView.isHidden = buffet.ticketChildren.count > 0 ? false : true
        view_related_quantity_action.isHidden = buffet.ticketChildren.count > 0 ? true : false

        _ = viewModel.buffet.asObservable().subscribe(onNext: {(item) in
            var buffet = item
            
            let amount =  buffet.ticketChildren.count > 0
            ? buffet.ticketChildren.map{$0.price * $0.quantity}.reduce(0, +)
            : item.adult_price * item.quantity
            
            
            self.lbl_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: amount)
            
        }).disposed(by: rxbag)
        
        self.viewModel.ticketChildren.accept(buffet.ticketChildren)
        
     
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.1)
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        root_view.transform = .identity
    }
}


//MARK: bind data
extension EditBuffetTicketViewController{
    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "EditBuffetTicketTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "EditBuffetTicketTableViewCell")
        tableView.isScrollEnabled = false
    }
    private func bindTableViewData() {
        viewModel.ticketChildren.bind(to: tableView.rx.items(cellIdentifier: "EditBuffetTicketTableViewCell", cellType: EditBuffetTicketTableViewCell.self))
        {(row, item, cell) in
            cell.viewModel = self.viewModel
            cell.data = item
        }.disposed(by: rxbag)
    }
    
    
}
