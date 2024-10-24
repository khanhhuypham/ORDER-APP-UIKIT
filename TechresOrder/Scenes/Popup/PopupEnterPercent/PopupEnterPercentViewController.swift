//
//  PopupEnterPercentViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/05/2024.
//

import UIKit
import RxRelay

class PopupEnterPercentViewController: BaseViewController {
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var btn_confirm: UIButton!
    
    
    var header = ""
    var percent:Int? = nil
    var placeHolder = ""
    var itemId:Int = 0
    var delegate:EnterPercentDelegate? = nil
    
    var percentObsever = BehaviorRelay<Int>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_header.text = header
        textfield.placeholder = placeHolder
        textfield.setMaxValue(maxValue: 100)
        if let percent = percent{
            textfield.text = String(percent)
        }
        
        
        _ = textfield.rx.text.map{[self] str in
            var percent = Int(str ?? "0") ?? 0
            if percent > 100{
                showWarningMessage(content: "Phần trăm giảm giá không được quá 100%")
                percent = 100
            }
            return percent
        }.bind(to: percentObsever).disposed(by: rxbag)
        
        _ = percentObsever.subscribe(onNext:{(percent) in
            
            let valid = percent >= 0 && percent <= 100
            self.btn_confirm.backgroundColor = valid ? ColorUtils.orange_brand_900() : .systemGray2
            self.btn_confirm.isUserInteractionEnabled = valid ? true : false
            
        }).disposed(by: rxbag)

        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
           dismiss(animated: true)
        }
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
       
        dismiss(animated: true,completion: {
            self.delegate?.callbackToGetPercent(id:self.itemId,percent: Int(self.textfield.text ?? "0") ?? 0)
        })
    }
    
  
    
}
