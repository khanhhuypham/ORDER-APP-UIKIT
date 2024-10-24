//
//  QuantityInputViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 15/02/2023.
//

import UIKit
import JonAlert

class QuantityInputViewController: UIViewController {
    @IBOutlet weak var textField_Result: UITextField!
    @IBOutlet weak var btn_point: UIButton!
    @IBOutlet weak var root_view: UIView!
    var isCheckQuantity:Float? //kiểm tra cho nhập số lượng vượt quá
    var is_sell_by_weight = 0
    var isHavePoint = 0
    var delegate_quantity:CaculatorInputQuantityDelegate?
    var position = 0
    var current_quantity:Float?
    var max_quantity:Float? = 0
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        root_view.round(with: .both, radius: 8)
        
        textField_Result.setRightPaddingPoints(10)
    
        setDoneOnKeyboard()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if is_sell_by_weight == ACTIVE {
            btn_point.isEnabled = true
            if current_quantity == 0 {
                isHavePoint = 0
                textField_Result.text = String(format: "%.0f", current_quantity!)
            }
            else {
                isHavePoint = 1
                textField_Result.text = String(format: "%.2f", current_quantity!)
            }
            
        }
        else {
            btn_point.isEnabled = false
            isHavePoint = 0
            textField_Result.text = String(format: "%.0f", current_quantity == nil ? 0 : current_quantity!)
        }
    }
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.textField_Result.inputAccessoryView = keyboardToolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionClosed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionDone(_ sender: Any) {
        if (self.textField_Result.text! as NSString).floatValue < 0.01 {
            JonAlert.showError(message: "Số lượng không phù hợp", duration: 3.0)
            return
        }
        
        if is_sell_by_weight == ACTIVE {
            if (self.textField_Result.text! as NSString).floatValue > max_quantity! {
                JonAlert.showError(message: String(format: "Số lượng tối đa là %.2f", max_quantity!), duration: 2.0)
            } else {
               
                delegate_quantity?.callbackCaculatorInputQuantity(
                    number: Float(textField_Result.text ?? "0")!,
                    position: position,
                    id: id)
                
                dismiss(animated: true, completion: nil)
            }
        } else {
            if (self.textField_Result.text! as NSString).floatValue > max_quantity! {
                JonAlert.showError(message: String(format: "Số lượng tối đa là %.0f", max_quantity!), duration: 2.0)
            } else {
                
                self.delegate_quantity?.callbackCaculatorInputQuantity(
                    number: Float(textField_Result.text ?? "0")!,
                    position: position,
                    id: id)
                
                dismiss(animated: true, completion: nil)
            }
        }
        
        

        
    }
    
    
    @IBAction func actionPoint(_ sender: Any) {
        
        if (self.isHavePoint == 1) {
            return
        }
        else {
            self.isHavePoint = 1
            dLog(self.textField_Result.text!)
            self.textField_Result.text = String( Int(self.textField_Result.text!)!) + "."
        }
        
        
    }
    
    
    @IBAction func actionCaculator(_ sender: UIButton) {
      //  print(sender.titleLabel?.text)
        
        dLog(self.textField_Result.text!)
        
        if(sender.titleLabel?.text == "C"){
            self.textField_Result.text = "0"
            self.isHavePoint = 0
        }else if(sender.titleLabel?.text == "-1"){

            let text_result = self.textField_Result.text
            
            let leng_result = (self.textField_Result.text?.count)! - 1;
                if(!(self.textField_Result.text?.isEmpty)!){
                    let subStr = text_result!.prefix(leng_result)
                    self.textField_Result.text = String(subStr)
                    if((self.textField_Result.text?.isEmpty)! ){
                        self.textField_Result.text = "0"
                        self.isHavePoint = 0
                    }
                    else if Float(self.textField_Result.text!)! == 0 {
                        self.textField_Result.text = "0"
                        self.isHavePoint = 0
                    }
                }else{
                    if Int(self.textField_Result.text!)! == 0 {
                        self.textField_Result.text = "0"
                        self.isHavePoint = 0
                    }
//                    self.textField_Result.text = "0"
//                    self.isHavePoint = 0
                }
           
        }else if(sender.titleLabel?.text == "%"){
            
//            if isHavePoint == 1 {
//                self.textField_Result.text = String( Float(self.textField_Result.text!)!-0.1)
//            }
//            else {
//                self.textField_Result.text = String( Int(self.textField_Result.text!)!-1)
//            }
            
            
        }else if(sender.titleLabel?.text == "7"){
            if self.textField_Result.text!.count > 9 {
                return
            }
            if isHavePoint == 1 {
                
                self.textField_Result.text! += "7"
                
            }
            else {
                if Float(self.textField_Result.text!)!==0{
                    self.textField_Result.text = String( Int(self.textField_Result.text!)!+7)
                }
                else {
                    self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+7)
                }
                
            }
        }else if(sender.titleLabel?.text == "8"){
            if self.textField_Result.text!.count > 9 {
                return
            }
           if isHavePoint == 1 {
                
                self.textField_Result.text! += "8"
                
            }
            else {
                if Float(self.textField_Result.text!)!==0{
                    self.textField_Result.text = String( Int(self.textField_Result.text!)!+8)
                }
                else {
                    self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+8)
                }
                
            }
        }else if(sender.titleLabel?.text == "9"){
            if self.textField_Result.text!.count > 9 {
                return
            }
            if isHavePoint == 1 {
                
                self.textField_Result.text! += "9"
                
            }
            else {
                if Float(self.textField_Result.text!)!==0{
                    self.textField_Result.text = String( Int(self.textField_Result.text!)!+9)
                }
                else {
                    self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+9)
                }
                
            }      }
        else if(sender.titleLabel?.text == "4"){
            if self.textField_Result.text!.count > 9 {
                return
            }
            if isHavePoint == 1 {
                
                self.textField_Result.text! += "4"
                
            }
            else {
                if Float(self.textField_Result.text!)!==0{
                    self.textField_Result.text = String( Int(self.textField_Result.text!)!+4)
                }
                else {
                    self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+4)
                }
                
            }
        }else if(sender.titleLabel?.text == "5"){
            if self.textField_Result.text!.count > 9 {
                return
            }
           if isHavePoint == 1 {
               
               self.textField_Result.text! += "5"
               
           }
           else {
               if Float(self.textField_Result.text!)!==0{
                   dLog(self.textField_Result.text!)
                   self.textField_Result.text = String( Int(self.textField_Result.text!)!+5)
               }
               else {
                   self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+5)
               }
               
           }
        }
        else if(sender.titleLabel?.text == "6"){
            if self.textField_Result.text!.count > 9 {
                return
            }
               if isHavePoint == 1 {
                    
                    self.textField_Result.text! += "6"
                    
                }
                else {
                    if Float(self.textField_Result.text!)!==0{
                        dLog(self.textField_Result.text!)
                        self.textField_Result.text = String( Int(self.textField_Result.text!)!+6)
                    }
                    else {
                        self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+6)
                    }
                    
                }
            
        }else if(sender.titleLabel?.text == "1"){
            if self.textField_Result.text!.count > 9 {
                return
            }
            if isHavePoint == 1 {
                
                self.textField_Result.text! += "1"
                
            }
            else {
                if Float(self.textField_Result.text!)!==0{
                    dLog(self.textField_Result.text!)
                    self.textField_Result.text = String( Int(self.textField_Result.text!)!+1)
                }
                else {
                    self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+1)
                }
                
            }
        }else if(sender.titleLabel?.text == "2"){
            if self.textField_Result.text!.count > 9 {
                return
            }
           if isHavePoint == 1 {
               
               self.textField_Result.text! += "2"
               
           }
           else {
               if Float(self.textField_Result.text!)!==0{
                   dLog(self.textField_Result.text!)
                   self.textField_Result.text = String( Int(self.textField_Result.text!)!+2)
               }
               else {
                   self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+2)
               }
               
           }
        }else if(sender.titleLabel?.text == "3"){
            if self.textField_Result.text!.count > 9 {
                return
            }
           if isHavePoint == 1 {
                
                self.textField_Result.text! += "3"
                
            }
            else {
                if Float(self.textField_Result.text!)!==0{
                    dLog(self.textField_Result.text!)
                    self.textField_Result.text = String( Int(self.textField_Result.text!)!+3)
                }
                else {
                    self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+3)
                }
                
            }
        }else if(sender.titleLabel?.text == "0"){
            if self.textField_Result.text!.count > 9 {
                return
            }
           if isHavePoint == 1 {
               
               self.textField_Result.text! += "0"
               
           }
           else {
               if Float(self.textField_Result.text!)!==0{
                   self.textField_Result.text = String( Int(self.textField_Result.text!)!+0)
               }
               else {
                   self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+0)
               }
               
           }
        }
        
//        if(Float(self.textField_Result.text!)! > max_quantity!){
//            if(self.is_sell_by_weight == ACTIVE){
//                self.textField_Result.text = String(format: "%.2f", max_quantity!)
//            }else{
//                self.textField_Result.text = String(format: "%d", max_quantity!)
//            }
//
//        }
        
    }
    
    
 
}

