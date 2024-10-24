//
//  UpdateCustomerSlotViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit

class UpdateCustomerSlotViewController: UIViewController {

    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var textField_Result: UILabel!
    var position:Int?
    var current_quantity:Int?
    var delegate:UpdateCustomerSloteDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        root_view.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
//        textField_Result.setRightPaddingPoints(10)
        textField_Result.text = String(format: "%d", current_quantity == nil ? 0 : current_quantity!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionClosed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func actionDone(_ sender: Any) {
        delegate?.callbackPeopleQuantity(number_slot: Int(self.textField_Result.text!)!)
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func actionCaculator(_ sender: UIButton) {

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
            if(Int(self.textField_Result.text!)! >= 1000){
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
            if(Int(self.textField_Result.text!)! >= 1000){
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
            if(Int(self.textField_Result.text!)! >= 1000){
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
            if(Int(self.textField_Result.text!)! >= 1000){
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
            if(Int(self.textField_Result.text!)! >= 1000){
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
            if(Int(self.textField_Result.text!)! >= 1000){
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
            if(Int(self.textField_Result.text!)! >= 1000){
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
            if(Int(self.textField_Result.text!)! >= 1000){
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
            if(Int(self.textField_Result.text!)! >= 1000){
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
        if(Int(self.textField_Result.text!)! >= 1000){
            self.textField_Result.text = "0"
        }
    }
    

}
