//
//  CreateTableViewController + extension + setup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/04/2024.
//

import UIKit
import RxSwift

extension CreateTableViewController {
    
    func setUpAndValidate(table:Table){
        setup(table: table)
        setupMenu(list: viewModel.area_array.value)
        isValid()
    }
    func setup(table:Table){

      
        if(table.id > 0){// update table
            lbl_title.text = "CẬP NHẬT BÀN"
            btn_confirm.setTitle("CẬP NHẬT", for: .normal)
            textfield_name.text = table.name
            textfield_number_slot.text = String(format: "%d", table.slot_number)
            btn_active.isHidden = false

            if(table.is_active == ACTIVE){
                actionStickCheckBox("")
            }
            
        }else{
            lbl_title.text = "THÊM BÀN"
            btn_confirm.setTitle("THÊM", for: .normal)
            btn_active.isHidden = true

            var t = viewModel.table.value
            t.is_active = ACTIVE
            viewModel.table.accept(t)
        }
        
        
        
        _ = textfield_name.rx.text.map{(str) in
            let name = Utils.blockSpecialCharacters(str ?? "")
            
            if name.count > 7{
                self.showWarningMessage(content: "Tên bàn tối đa 7 ký tự")
            }
            return String(name.prefix(7))
        }.map{[self] str in
            var table = viewModel.table.value
            table.name = str
            textfield_name.text = table.name
            return table
        }.bind(to: viewModel.table).disposed(by: rxbag)
        
        
        
        _ = textfield_number_slot.rx.text.map{[self] str in
            var table = viewModel.table.value
         
            
            if str!.count > 0{
                var string = str
                string = string?.replacingOccurrences(of: "Số khách: ", with: "") ?? ""
                table.slot_number = Int(string ?? "0") ?? 0
            }
           
            
            if table.slot_number > 999{
                table.slot_number = 999
            }
            
            
            textfield_number_slot.attributedText = Utils.getAttributedString(
                
                attributes: [
                    (str:"Số khách: ",properties:[NSAttributedString.Key.foregroundColor: ColorUtils.black()]),
                    (str:String(format: "%d", table.slot_number),properties:[
                        NSAttributedString.Key.foregroundColor: ColorUtils.orange_brand_900(),
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)
                    ])
                ])
            
            return table
        }.bind(to: viewModel.table).disposed(by: rxbag)
        
    

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
  

    
    private func isValid(){
        _ = Observable.combineLatest(isNameValid, isAreaValid, isSlotNumberValid){$0 && $1 && $2}.subscribe(onNext: {(valid) in
            self.btn_confirm.backgroundColor = valid ? ColorUtils.orange_brand_900() : .systemGray2
            self.btn_confirm.isEnabled = valid ? true : false
        }).disposed(by: rxbag)
    }
    
  
    

    private var isNameValid: Observable<Bool> {
        
        return viewModel.table.map{$0.name}.asObservable().map { name in
            return name.count >= 2 &&  name.count <= 7
        }
    }
    
    private var isAreaValid: Observable<Bool> {
        return viewModel.table.map{$0.area_id}.asObservable().map{id in
            return id != 0
        }
    }
    
    private var isSlotNumberValid: Observable<Bool> {
        return viewModel.table.map{$0.slot_number}.asObservable().map { number in
            return number > 0 && number <= 999
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if textfield_number_slot.isFirstResponder || textfield_name.isFirstResponder {
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.1)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if textfield_number_slot.isFirstResponder || textfield_name.isFirstResponder{
            root_view.transform = .identity
        }
    }
    
    @objc private func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
            actionCancel("")
        }
    }

    
}
