//
//  CreateAreaViewController + Extension + validate.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/01/2024.
//

import UIKit
import RxSwift
import RxRelay
extension CreateAreaViewController {
    func validate(){
        _ = textfield_area_name.rx.text.map{(str) in
            var name = str ?? ""
            name = String(name.drop(while:{$0.isWhitespace}))
            if name.count > 20{
                self.showWarningMessage(content: "Tên khu vực tối đa 20 ký tự")
            }
            
            return String(name.prefix(20))
        }.map{[self] str in
            var area = viewModel.area.value
            area.name = Utils.blockSpecialCharacters(str)
            textfield_area_name.text = area.name
            return area
        }.bind(to: viewModel.area).disposed(by: rxbag)
        
        
    
        
        viewModel.area.map{$0.name}.subscribe(onNext: { [self](str) in
            let valid = str.count >= 2 &&  str.count <= 20
            
            self.btnCreate.backgroundColor = valid ? ColorUtils.orange_brand_900() : .systemGray2
            self.btnCreate.isUserInteractionEnabled = valid ? true : false
        
        }).disposed(by: rxbag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
          
        
    }

        
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if textfield_area_name.isFirstResponder {
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.1)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if textfield_area_name.isFirstResponder{
            root_view.transform = .identity
        }
    }
    
    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
            actionDismiss("")
        }
    }

    
}
