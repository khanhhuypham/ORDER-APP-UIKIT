//
//  OtherFoodRebuildViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 04/12/2023.
//

import UIKit

class OtherFoodViewController: BaseViewController {
    var viewModel = OtherFoodViewModel()
    var orderDetail = OrderDetail()
    var popViewController:(() -> Void) = {}
    
    @IBOutlet weak var textfield_food_name: UITextField!
    
    @IBOutlet weak var btn_show_money_input: UIButton!
    
    @IBOutlet weak var btn_show_quantity_input: UIButton!
    
    
    @IBOutlet weak var view_of_printer_list: UIView!
    
    @IBOutlet weak var lbl_printer_name: UILabel!
    
    @IBOutlet weak var btn_show_printer_list: UIButton!
    
    @IBOutlet weak var btn_of_printing_chef_bar: UIButton!

    
    @IBOutlet weak var text_view: UITextView!
    
    @IBOutlet weak var lbl_number_of_word: UILabel!
    
    @IBOutlet weak var btn_confirm: UIButton!

    /*
        biến này được tạo ra để chứa cháy tạm thời cho yêu cầu tào lao của QC
        
     
     */
    var count = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        mapDataAndValidate()
        getPrinterList()
        viewModel.order.accept(orderDetail)
    }

    
    @IBAction func actionStickcheckbox(_ sender: Any) {
        
        btn_of_printing_chef_bar.isSelected = !btn_of_printing_chef_bar.isSelected
        view_of_printer_list.isHidden = !btn_of_printing_chef_bar.isSelected
        
        if count > 1{
            Toast.show(message: btn_of_printing_chef_bar.isSelected ? "Sẽ in phiếu chế biến ở Bếp/Bar lúc gọi món" : "Sẽ không in phiếu chế biến ở Bếp/Bar lúc gọi món", controller: self)
        }
        
    
        var otherFood = viewModel.otherFood.value
        otherFood.is_allow_print = btn_of_printing_chef_bar.isSelected == true ? 1 : 0
        viewModel.otherFood.accept(otherFood)
        
        count += 1
    }
    
    @IBAction func actionShowCalculator(_ sender: Any) {
        presentMoneyInput(price: viewModel.otherFood.value.price)
    }
    
    @IBAction func actionShowQuantityInput(_ sender: UIButton) {
        var otherFood = viewModel.otherFood.value
        switch sender.titleLabel?.text{
            case "+":
                otherFood.quantity += 1
                break
            case "-":
                otherFood.quantity -= 1
                break
            default:
                presentQuantityInput(quantity: Float(viewModel.otherFood.value.quantity))
                break
                
        }
        
        if otherFood.quantity <= 1{
            otherFood.quantity = 1
        }else if otherFood.quantity >= 999{
            otherFood.quantity = 999
        }
        viewModel.otherFood.accept(otherFood)
        btn_show_quantity_input.setAttributedTitle(getAttribute(content: String(format:"%@", Utils.stringQuantityFormatWithNumberFloat(quantity: otherFood.quantity))), for: .normal)
    }
    

    
    @IBAction func actionShowPrinterList(_ sender: Any) {
        showPrinterList()
    }
    
    
    @IBAction func actionConfirm(_ sender: Any) {
        addOtherFoodsToOrder()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        popViewController()
    }
    
}
