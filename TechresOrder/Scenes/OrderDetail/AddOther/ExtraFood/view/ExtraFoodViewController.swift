//
//  ExtraFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 21/01/2023.
//

import UIKit
import JonAlert
class ExtraFoodViewController: BaseViewController {
    var viewModel = ExtraFoodViewModel()
    let btnAttr = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
        NSAttributedString.Key.foregroundColor: ColorUtils.black()
    ]
    var popViewController:(() -> Void) = {}
    var order_id = 0
    
    @IBOutlet weak var BtnDropDown: UIButton!
    @IBOutlet weak var textfield_charge_amount: UITextField!
    
    @IBOutlet weak var textview_description: UITextView!
    @IBOutlet weak var lbl_number_character: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textview_description.withDoneButton()
        viewModel.bind(view: self)

        _ = textfield_charge_amount.rx.text.map{ str in
            let price = Utils.convertStringToInteger(str: str ?? "0")
            var charge = self.viewModel.charge.value
            charge.price = Float(price)
            if charge.price > 500000000{
                charge.price = 500000000
            }
            
            self.textfield_charge_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: charge.price)
            
            return charge
        }.bind(to:viewModel.charge).disposed(by: rxbag)
        
        _ = textview_description.rx.text.map{String($0?.prefix(255) ?? "")}.map{ str in
            
            let des = Utils.blockSpecialCharacters(str)
        
            var charge = self.viewModel.charge.value
            charge.description = des
            self.lbl_number_character.text = String(format: "%d/255", charge.description.count)
            self.textview_description.text = charge.description
            
            return charge
        }.bind(to:viewModel.charge).disposed(by: rxbag)
        
        isExtraChargetValid()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getExtraCharges()
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
        popViewController()
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        
        addExtraCharge()
    }
    
}
