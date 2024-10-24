//
//  EditChildrenFoodViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/03/2024.
//

import UIKit
import JonAlert
//MARK: set up data, UITextFieldDelegate
extension EditChildrenFoodViewController{
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var item = self.viewModel.orderItem.value
        
        let quantity = item.is_sell_by_weight == ACTIVE ? MathUtils.convertStringToDoubleString(str:textField.text ?? "") : textField.text
                    
        self.text_field_quantity.text = quantity
        
        item.setQuantity(quantity: Float(quantity ?? "0") ?? 0.0)
        
        viewModel.orderItem.accept(item)
    }
    
    func mapData() {

        var item = viewModel.orderItem.value
        lbl_name.text = item.name
        lbl_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: item.total_price)
        text_field_quantity.text = Utils.stringQuantityFormatWithNumberFloat(amount: item.quantity)
        text_field_quantity.keyboardType = item.is_sell_by_weight == ACTIVE ? .decimalPad : .numberPad
        text_field_quantity.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        text_field_quantity.setMaxValue(maxValue: item.is_sell_by_weight == ACTIVE ? 200 : 999)

        
        
        _ = viewModel.orderItem.asObservable().subscribe(onNext: {(item) in
            var amount:Float = 0
            amount = Float(item.price) * item.quantity
            
            for children in item.order_detail_additions.filter({$0.isSelected == ACTIVE}){
              
                amount += Float(children.price) * children.quantity
           
            }
            
            self.lbl_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: amount)
            
        }).disposed(by: rxbag)
        
      
        
          item.order_detail_additions.enumerated().forEach{(i,value) in
              item.order_detail_additions[i].isSelected = ACTIVE
          }
         
          if item.order_detail_additions.count > 0{
              height_of_table.constant = 200
              for i in (0...item.order_detail_additions.count - 1){
                  let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
                  height_of_table.constant += CGFloat(cell?.frame.height ?? 0)
                  tableView.layoutIfNeeded()
              }
              height_of_table.constant -= 200
          }else{
              height_of_table.constant = 0
          }
          
          
          viewModel.orderItem.accept(item)
          
          let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
          tapGestureRecognizer.cancelsTouchesInView = false
          view.addGestureRecognizer(tapGestureRecognizer)
          
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if text_field_quantity.isFirstResponder{
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.1)
            }
        }
    }
        

    @objc private func keyboardWillHide(notification: NSNotification) {
        if text_field_quantity.isFirstResponder{
            root_view.transform = .identity
        }
    }
}

//MARK: bind data
extension EditChildrenFoodViewController{
    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
    }

    private func registerCell() {
        let cell = UINib(nibName: "EditChildrenFoodTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "EditChildrenFoodTableViewCell")
    }



    private func bindTableViewData() {
        viewModel.orderItem.map{$0.order_detail_additions}.bind(to: tableView.rx.items(cellIdentifier: "EditChildrenFoodTableViewCell", cellType: EditChildrenFoodTableViewCell.self))
           {  (row, item, cell) in
               cell.viewModel = self.viewModel
               cell.data = item
           }.disposed(by: rxbag)
    }
    
}




