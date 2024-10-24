//
//  CreateTableQuicklyViewController + extension + popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 15/04/2024.
//

import UIKit


extension CreateTableQuicklyViewController{
    
    private func handleSelection(element:Area,menu:UIMenu) -> UIMenu{
      
        btn_show_area.setAttributedTitle(Utils.setAttributesForBtn(content: element.name, attributes: btnAttr),for: .normal)
        
        var list = viewModel.areaList.value
        
        list.enumerated().forEach{(i, area) in
            list[i].is_select = area.id == element.id ? ACTIVE : DEACTIVE
        }
        viewModel.areaList.accept(list)
        

        menu.children.enumerated().forEach{(i, action) in
            guard let action = action as? UIAction else {
                return
            }
            action.state = action.title == element.name ? .on : .off
        }
        return menu
    }
    
    func setupMenu(list:[Area]){
        
        var options:[UIAction] = []
    
        for element in list {

            options.append(
                UIAction(title: element.name, image: nil, identifier: nil, handler: { _ in
                    self.btn_show_area.menu = self.handleSelection(element: element, menu:self.btn_show_area.menu!)
                })
            )
        }

        btn_show_area.menu = UIMenu(options: .displayInline, children: options)
        
        if list.count > 0{
            self.btn_show_area.menu =  handleSelection(element: list[0], menu:self.btn_show_area.menu!)
            
            for element in list.filter{$0.is_select == ACTIVE} {
                self.btn_show_area.menu = handleSelection(element: element, menu:self.btn_show_area.menu!)
            }
        }
        
        btn_show_area.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
    }
}
