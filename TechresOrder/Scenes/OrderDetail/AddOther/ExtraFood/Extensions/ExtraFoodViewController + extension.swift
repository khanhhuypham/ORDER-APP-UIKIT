//
//  ExtraFoodViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/04/2024.
//

import UIKit

extension ExtraFoodViewController {
   
    private func handleSelection(element:ExtraCharge,menu:UIMenu) -> UIMenu{
        viewModel.charge.accept(ExtraCharge.init(
                id: element.id,
                name: element.name,
                price: element.price,
                quantity: element.quantity,
                description: viewModel.charge.value.description)
        )
        
        BtnDropDown.setAttributedTitle(Utils.setAttributesForBtn(content: element.name, attributes: btnAttr),for: .normal)
        textfield_charge_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: element.price)
        textfield_charge_amount.isEnabled = element.id == 0 ? true : false
        
        
        menu.children.enumerated().forEach{(i, action) in
            guard let action = action as? UIAction else {
                return
            }
            action.state = action.title == element.name ? .on : .off
        }
        return menu
    }
    
    func setupMenu(list:[ExtraCharge]){
        
        var options:[UIAction] = []
        
        for element in list {
            
            let option = UIAction(title: element.name, image: nil, identifier: nil, handler: { _ in
                self.BtnDropDown.menu = self.handleSelection(element: element, menu:self.BtnDropDown.menu!)
            })

            options.append(option)
        }
        
        if list.count > 0{
            BtnDropDown.menu = UIMenu(title: "Phụ thu", children: options)
            self.BtnDropDown.menu = self.handleSelection(element: list[0], menu:self.BtnDropDown.menu!)
        }
        
    }

}
