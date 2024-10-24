//
//  CreateNoteViewController + Extension + validate.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/01/2024.
//

import UIKit


extension CreateNoteViewController {
    
    func firstSetup(){
        mapData()
        lbl_header.text = note.id > 0 ? "CẬP NHẬT GHI CHÚ" : "TẠO MỚI GHI CHÚ"
        btnCreate.setTitle(note.id > 0 ? "CẬP NHẬT" : "THÊM", for: .normal)
    }
    
    private func mapData(){
        
        textview_note.text = viewModel.note.value.content
        
        _ = textview_note.rx.text.map{str in
            
            let content = str ?? ""
            
            if content.count > 50{
                self.showWarningMessage(content: "Ghi chú tối đa 50 ký tự!")
            }
            return String(content.prefix(50))
            
        }.map{[self] content in
            
            var note = viewModel.note.value
            note.content = content.trimmingCharacters(in: .whitespacesAndNewlines)
            textview_note.text = content
            lbl_count_text.text = String(format:"%d/50",note.content.count)
            
            return note
        }.bind(to:viewModel.note).disposed(by: rxbag)
        
        
        _ = viewModel.note.map{$0.content}.subscribe(onNext: {str in
            
            let valid = str.count >= 2 && str.count <= 50
    
            self.btnCreate.backgroundColor = valid ? ColorUtils.orange_brand_900() : .systemGray2
            self.btnCreate.isEnabled = valid ? true : false
            
        }).disposed(by:rxbag)
        
       

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
            
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if textview_note.isFirstResponder {
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.1)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if textview_note.isFirstResponder{
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
