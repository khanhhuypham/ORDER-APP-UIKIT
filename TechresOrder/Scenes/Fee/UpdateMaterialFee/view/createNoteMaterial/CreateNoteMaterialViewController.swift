//
//  CreateNoteMaterialViewController.swift
//  TECHRES-ORDER
//
//  Created by macmini_techres_01 on 25/07/2023.
//

import UIKit
import JonAlert
import RxSwift
class CreateNoteMaterialViewController: BaseViewController {
    
    @IBOutlet weak var cancel_btn_view: UIView!
    
    @IBOutlet weak var confirm_btn_view: UIView!
    
    var delegate: MaterialDelegate?
    @IBOutlet weak var textview_note: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // thêm nút done vào bàn phím
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.textview_note.inputAccessoryView = toolbar
        
        cancel_btn_view.roundCorners(corners: [.bottomLeft], radius: 10)
        confirm_btn_view.roundCorners(corners: [.bottomRight], radius: 10)
     
        textview_note.rx.text
            .orEmpty
            .map { [weak self] text in
                guard let self = self else { return "" }
                if text.count > 255 {
                    return String(text.prefix(255))
                }
                return text
            }
            .bind(to: textview_note.rx.text)
            .disposed(by: rxbag)
    }

    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    @objc func dismissMyKeyboard() {
            view.endEditing(true)
        }
    
    @IBAction func actionUpdate(_ sender: Any) {
        if textview_note.text.count > 0 && textview_note.text.count <= 255{
            delegate?.callBackNoteDelete(note: textview_note.text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        else{
            JonAlert.showError(message: "Lý do huỷ phải lớn hơn 2 và nhỏ hơn 255 ký tự!")
        }
    }

}
