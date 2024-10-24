//
//  CreateCategoryPopupViewController + extension + setup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/11/2023.
//

import UIKit

extension CreateCategoryPopupViewController {
    
    func firstSetup(){
 
        let category = viewModel.category.value
        

        if category.id > 0{
            btn_choose_category.isUserInteractionEnabled = false
            icon_dropDown.isHidden = true
            width_of_icon_dropDown.constant = 0
            btn_confirm.setTitle("CẬP NHẬT", for: .normal)
            btn_status.isHidden = false
            btn_status.isSelected = category.status == ACTIVE ? true : false
            lbl_category_type.text = category.categoryType.name
            textfield_categoryName.text = category.name
         
    
        }else{
            btn_choose_category.isUserInteractionEnabled = true
            icon_dropDown.isHidden = false
            width_of_icon_dropDown.constant = 20
            btn_confirm.setTitle("THÊM", for: .normal)
            btn_status.isHidden = true
            lbl_category_type.text = String(format: "%@", category.categoryType.name)
            actionChangeStatus("")
            
            var options:[UIAction] = []
            
            for type in CATEGORY_TYPE.allCases {
                
                let option = UIAction(title: type.name, image: nil, identifier: nil, handler: { _ in

                    self.btn_choose_category.menu = self.handleSelection(type: type, menu:self.btn_choose_category.menu!)
                })

                options.append(option)
            }
            

            options[0].state = .on
            btn_choose_category.menu = UIMenu(title: "", children: options)
        }
        

        _ = textfield_categoryName.rx.text.map{[self] str in
            let name = str ?? ""
            textfield_categoryName.text = name
            var cate = viewModel.category.value
            cate.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            return cate
        }.bind(to:viewModel.category).disposed(by: rxbag)
        
        
        _ = viewModel.category.map{$0.name}.subscribe(onNext: {(name) in
            self.btn_confirm.isUserInteractionEnabled = name.count >= 2 && name.count <= 50 ? true : false
            self.btn_confirm .backgroundColor = name.count >= 2 && name.count <= 50 ? ColorUtils.orange_brand_900() : ColorUtils.gray_600()
        }).disposed(by: rxbag)

    }

    
    private func handleSelection(type: CATEGORY_TYPE, menu:UIMenu) -> UIMenu{

        lbl_category_type.text = String(format: "%@", type.name)
        var category = self.viewModel.category.value
        category.categoryType = type
        viewModel.category.accept(category)
 
        menu.children.enumerated().forEach{(i, action) in
            guard let action = action as? UIAction else {
                return
            }
            action.state = action.title == type.name ? .on : .off
        }
    
        return menu
    }
    

}
