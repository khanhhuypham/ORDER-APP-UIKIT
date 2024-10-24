//
//  InputQuantityViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import JonAlert

class InputQuantityViewController: BaseViewController {
    @IBOutlet weak var textField_Result: UILabel!
    var delegate:CaculatorInputQuantityDelegate?
    var position:Int = 0
    var current_quantity:Float?
    var is_sell_by_weight = 0
    var max_quantity:Float? = 0
    
    
    //Thêm viewmodel
    var viewmodel = NoteViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

       
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        if is_sell_by_weight == 1 {
            if current_quantity == 0 {
                textField_Result.text = "0"
            }
            else {
                textField_Result.text = String(format: "%.2f", current_quantity!)
            }
            
//            textField_Result.text = String(format: "%.2f", current_quantity == nil ? 0 : current_quantity!)
        }else{
            textField_Result.text = String(format: "%.0f", current_quantity == nil ? 0 : current_quantity!)
        }
    }

    @IBAction func actionClosed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func actionDone(_ sender: Any) {

        delegate?.callbackCaculatorInputQuantity(number: Float(self.textField_Result.text!)!, position: position,id: 0)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionCaculator(_ sender: UIButton) {
      //  print(sender.titleLabel?.text)
//        if(Int(self.textField_Result.text!)! >= 1000){
//            let s = self.textField_Result.text
//            let sub = s!.suffix(3)
//            self.textField_Result.text = String(sub)
//        }
            
        if(sender.titleLabel?.text == "C"){
            self.textField_Result.text = "0"
        }else if(sender.titleLabel?.text == "-1"){
            let text_result = self.textField_Result.text
            
            let leng_result = (self.textField_Result.text?.count)! - 1;
                if(!(self.textField_Result.text?.isEmpty)!){
                    let subStr = text_result!.suffix(leng_result)
                    self.textField_Result.text = String(subStr)
                    if((self.textField_Result.text?.isEmpty)! ){
                        self.textField_Result.text = "0"
                    }
                }else{
                    self.textField_Result.text = "0"
                }
           
        }else if(sender.titleLabel?.text == "Giảm"){
            self.textField_Result.text = String( Int(self.textField_Result.text!)!-1)
            if(Int(self.textField_Result.text!)! <= 0){
                self.textField_Result.text = String("0")
            }
        }else if(sender.titleLabel?.text == "Tăng"){
            if self.textField_Result.text == "999" {
                Toast.show(message: "Số lượng tối đa cho phép là 999", controller: self)
//                JonAlert.showError(message: "Số lượng tối đa cho phép là 999", duration: 2.0)
                return
            } else {
                self.textField_Result.text = String( Int(self.textField_Result.text!)!+1)
            }
            
        }else if(sender.titleLabel?.text == "7"){
            if Int(self.textField_Result.text!)!==0{
                self.textField_Result.text = String( Int(self.textField_Result.text!)!+7)
            }
            else{
                self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+7)
            }
            if(Float(self.textField_Result.text!)! < max_quantity!){
                let s = self.textField_Result.text
                let sub = s!.suffix(3)
                self.textField_Result.text = String(sub)
            }
        }else if(sender.titleLabel?.text == "8"){
            if Int(self.textField_Result.text!)!==0{
                self.textField_Result.text = String( Int(self.textField_Result.text!)!+8)
            }
            else{
                self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+8)
            }
            if(Float(self.textField_Result.text!)! < max_quantity!){
                let s = self.textField_Result.text
                let sub = s!.suffix(3)
                self.textField_Result.text = String(sub)
            }
        }else if(sender.titleLabel?.text == "9"){
            if Int(self.textField_Result.text!)!==0{
                self.textField_Result.text = String( Int(self.textField_Result.text!)!+9)
            }
            else{
                self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+9)
            }
            if(Float(self.textField_Result.text!)! < max_quantity!){
                let s = self.textField_Result.text
                let sub = s!.suffix(3)
                self.textField_Result.text = String(sub)
            }
        }
        
        else if(sender.titleLabel?.text == "-"){
//            self.textField_Result.text =  self.textField_Result.text! + "-"
        }else if(sender.titleLabel?.text == "4"){
            if Int(self.textField_Result.text!)!==0{
                self.textField_Result.text = String( Int(self.textField_Result.text!)!+4)
            }
            else{
                self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+4)
            }
            if(Float(self.textField_Result.text!)! < max_quantity!){
                let s = self.textField_Result.text
                let sub = s!.suffix(3)
                self.textField_Result.text = String(sub)
            }
        }else if(sender.titleLabel?.text == "5"){
            if Int(self.textField_Result.text!)!==0{
                self.textField_Result.text = String( Int(self.textField_Result.text!)!+5)
            }
            else{
                self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+5)
            }
            if(Float(self.textField_Result.text!)! < max_quantity!){
                let s = self.textField_Result.text
                let sub = s!.suffix(3)
                self.textField_Result.text = String(sub)
            }
        }
        else if(sender.titleLabel?.text == "6"){
                if Int(self.textField_Result.text!)!==0{
                    self.textField_Result.text = String( Int(self.textField_Result.text!)!+6)
                }
                else{
                    self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+6)
                }
            if(Float(self.textField_Result.text!)! < max_quantity!){
                let s = self.textField_Result.text
                let sub = s!.suffix(3)
                self.textField_Result.text = String(sub)
            }
            
        }else if(sender.titleLabel?.text == "+"){
//             self.textField_Result.text =  self.textField_Result.text! + "+"
        }else if(sender.titleLabel?.text == "1"){
            if Int(self.textField_Result.text!)!==0{
                self.textField_Result.text = String( Int(self.textField_Result.text!)!+1)
            }
            else{
                self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+1)
            }
            if(Float(self.textField_Result.text!)! < max_quantity!){
                let s = self.textField_Result.text
                let sub = s!.suffix(3)
                self.textField_Result.text = String(sub)
            }
        }else if(sender.titleLabel?.text == "2"){
            if Int(self.textField_Result.text!)!==0{
                self.textField_Result.text = String( Int(self.textField_Result.text!)!+2)
            }
            else{
                self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+2)
            }
            if(Float(self.textField_Result.text!)! < max_quantity!){
                let s = self.textField_Result.text
                let sub = s!.suffix(3)
                self.textField_Result.text = String(sub)
            }
        }else if(sender.titleLabel?.text == "3"){
            if Int(self.textField_Result.text!)!==0{
                self.textField_Result.text = String( Int(self.textField_Result.text!)!+3)
            }
            else{
                self.textField_Result.text=String(Int(self.textField_Result.text!)!*10+3)
            }
            if(Float(self.textField_Result.text!)! < max_quantity!){
                let s = self.textField_Result.text
                let sub = s!.suffix(3)
                self.textField_Result.text = String(sub)
            }
        }else if(sender.titleLabel?.text == "+/="){
            
        }else if(sender.titleLabel?.text == "0"){
            if Int(self.textField_Result.text!)!==0{
                self.textField_Result.text = String( Int(self.textField_Result.text!)!+0)
            }
            else{
                self.textField_Result.text=String(Int(self.textField_Result.text!)!*10)
            }
        }else if(sender.titleLabel?.text == "000"){
            self.textField_Result.text = String( Int(self.textField_Result.text!)!*1000)
        }else {
        }
//        if(Float(self.textField_Result.text!)! > max_quantity!){
//            self.textField_Result.text = String(format: "%.0f", max_quantity!)
//        }
        // Thêm sự kiện lắng nghe valid
        viewmodel.isValid.subscribe({ [weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else { return }
            if Int(strongSelf.textField_Result.text!)! >= 999 {
                strongSelf.textField_Result.text = "999"
                Toast.show(message: "Giá trị tối đa có thể là 1 và tối đa là 999", controller: self!)
//                JonAlert.showError(message: "Giá trị tối thiểu là 1 và tối đa là 999", duration: 2.0)
            }
        })

        
    }
}
