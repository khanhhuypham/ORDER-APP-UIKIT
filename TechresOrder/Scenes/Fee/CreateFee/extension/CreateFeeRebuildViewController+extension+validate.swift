//
//  CreateFeeRebuildViewController+extension+validate.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/02/2024.
//

import UIKit
import ObjectMapper
import RxSwift
extension CreateFeedRebuildViewController{
    func firstSetup(){
        textview_note.withDoneButton()
        textview_note.setPlaceholderColor("Ghi chú", false)
        
        lbl_date.text = TimeUtils.getCurrentDateTime().dateTimeNow
        
        var otherFees:[Fee] = []
        for var i in 0..<strings.count {
            otherFees.append(Fee.init(id: i, objectName: strings[i], icon: strings[i]))
        }
        viewModel.array.accept(otherFees)
        
        
        mapData()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
   
    }
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            
            switch viewType{
                case 1:
                    if textview_note.isFirstResponder {
                        root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.1)
                    }
                    break
                case 2:
                    root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/1.2)
                    break
                
                default:
                    break
            }
        }
    }
        

    @objc private func keyboardWillHide(notification: NSNotification) {
        root_view.transform = .identity
    }

    
    
    private func mapData(){
        

        
        _ = textfield_object_name.rx.text.map{str in
            
            let content = str ?? ""
            
            if content.count > 50{
                self.showWarningMessage(content: "Mục đích tối đa 50 ký tự!")
            }
            return String(content.prefix(50))
            
        }.map{[self] object_name in
            textfield_object_name.text = object_name
        
            var fee = viewModel.fee.value
            fee.object_name = object_name.trimmingCharacters(in: .whitespacesAndNewlines)
        
            return fee
            
        }.bind(to:viewModel.fee).disposed(by: rxbag)
        
        
        _ = textview_note.rx.text.map{[self] note in

            var fee = viewModel.fee.value
            fee.note = note ?? ""
            return fee
            
        }.bind(to:viewModel.fee).disposed(by: rxbag)
        
    
        
    }
    
    
    var isFeeValid: Observable<Bool>{
        return Observable.combineLatest(isObjectNameValid,isAmoutValid){$0 && $1 }
    }
    
    

    private var isObjectNameValid: Observable<Bool>{
        return viewModel.fee.map{$0.object_name}.asObservable().map(){[self](name) in
            
            if name.isEmpty{
                self.showWarningMessage(content: "vui lòng nhập mục đích chi")
                return false
            }else if name.count < 2 || name.count > 50  {
                return false
            }else {
                return true
            }
        }
    }

    private var isAmoutValid: Observable<Bool>{
        return viewModel.fee.map{$0.amount}.distinctUntilChanged().asObservable().map(){[self](amount) in
            if amount <= 0{
                self.showWarningMessage(content: "vui lòng nhập số tiền")
            }
            
            return amount > 0
        }
    }

    
}
