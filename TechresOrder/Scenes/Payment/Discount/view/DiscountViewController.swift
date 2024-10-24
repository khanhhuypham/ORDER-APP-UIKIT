//
//  DiscountViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 20/01/2023.
//

import UIKit
import Alamofire
import JonAlert
import RxSwift
class DiscountViewController: BaseViewController {
    var viewModel = DiscountViewModel()
    var completion:(() -> Void) = {}
    let listName = ["Khách quen của quán","Khách vip của quán","Chương trình khuyến mãi", "Khác"]

    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var btnDiscountTotalBill: UIButton!
    @IBOutlet weak var btnDiscountByCategory: UIButton!

    
    @IBOutlet weak var view_of_discount_by_category: UIView!
    @IBOutlet weak var btnDiscountFood: UIButton!
    @IBOutlet weak var btnDiscountDrink: UIButton!
    @IBOutlet weak var btnDiscountReasonByCategory: UIButton!
    @IBOutlet weak var textfield_discount_percent_of_food: UITextField!
    @IBOutlet weak var textfield_discount_percent_of_drink: UITextField!
    @IBOutlet weak var btnDiscount: UIButton!
    
    
    @IBOutlet weak var view_of_discount_on_total_bill: UIView!
    @IBOutlet weak var textfield_discount_percent_on_bill: UITextField!
    @IBOutlet weak var btnDiscountReasonOnBill: UIButton!
    
    var order_id = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.bind(view: self)
     
        viewModel.note.accept(self.listName[0])
        btnDiscountReasonOnBill.setAttributedTitle(getAttribute(content:listName[0]), for: .normal)
        btnDiscountReasonByCategory.setAttributedTitle(getAttribute(content:listName[0]), for: .normal)
        checkDiscountTotalBill("")
        mapDataAndValidate()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        
        
    }
    
    func getAttribute(content:String) -> NSAttributedString{
        return NSAttributedString(string: content, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
    }
    
    
    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
           dismiss(animated: true)
        }
    }
    

    @IBAction func actionChooseReason(_ sender: UIButton) {
        self.showChooseReasonDiscount(btn:sender)
        
        /*
            discountReasonType là loại lý do giảm giá
            type = 1 -> discount trên tổng bill
            type = 2 -> discount theo từng loại món
         */
        if sender == btnDiscountReasonOnBill{
            viewModel.discountReasonType.accept(1)
        }else if sender == btnDiscountReasonByCategory{
            viewModel.discountReasonType.accept(2)
        }
       
    }
    
    @IBAction func actionDiscount(_ sender: Any) {
        viewModel.order_id.accept(self.order_id)
        if btnDiscountTotalBill.isSelected{
            viewModel.drink_discount_percent.accept(0)
            viewModel.food_discount_percent.accept(0)
        }else if  btnDiscountByCategory.isSelected{
            viewModel.total_bill_discount_percent.accept(0)
        }
        self.applyDiscount()

    }
    
    @IBAction func actionBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func checkDiscountTotalBill(_ sender: Any) {
        btnDiscountTotalBill.isSelected = true
        view_of_discount_by_category.isHidden = true
        view_of_discount_on_total_bill.isHidden = false
        btnDiscountByCategory.isSelected = false
        btnDiscountFood.isSelected = false
        btnDiscountDrink.isSelected = false
        textfield_discount_percent_on_bill.isUserInteractionEnabled = btnDiscountTotalBill.isSelected ? true : false
        /*sử dụng hàm insertText để chạy lại hàm validate*/
        textfield_discount_percent_on_bill.insertText("")
        textfield_discount_percent_of_food.insertText("")
        textfield_discount_percent_of_drink.insertText("")
    }
    
    @IBAction func checkDiscountByCategory(_ sender: Any) {
        btnDiscountTotalBill.isSelected = false
        btnDiscountByCategory.isSelected = true
        view_of_discount_by_category.isHidden = false
        view_of_discount_on_total_bill.isHidden = true
        /*sử dụng hàm insertText để chạy lại hàm validate*/
        textfield_discount_percent_on_bill.insertText("")
        textfield_discount_percent_of_food.insertText("")
        textfield_discount_percent_of_drink.insertText("")
    }
    
    @IBAction func checkDiscountByFood(_ sender: Any) {
        btnDiscountFood.isSelected = !btnDiscountFood.isSelected
        textfield_discount_percent_of_food.isUserInteractionEnabled = btnDiscountFood.isSelected ? true : false
        textfield_discount_percent_of_food.text = ""
        textfield_discount_percent_of_food.insertText("")
    }
    
    @IBAction func checkDiscountByDrink(_ sender: Any) {
        btnDiscountDrink.isSelected = !btnDiscountDrink.isSelected
        textfield_discount_percent_of_drink.isUserInteractionEnabled = btnDiscountDrink.isSelected ? true : false
        textfield_discount_percent_of_drink.text = ""
        textfield_discount_percent_of_drink.insertText("")
    }
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if textfield_discount_percent_of_food.isFirstResponder || textfield_discount_percent_of_drink.isFirstResponder || textfield_discount_percent_on_bill.isFirstResponder{
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.1)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if textfield_discount_percent_of_food.isFirstResponder || textfield_discount_percent_of_drink.isFirstResponder || textfield_discount_percent_on_bill.isFirstResponder{
            root_view.transform = .identity
        }
    }
    
}
    
