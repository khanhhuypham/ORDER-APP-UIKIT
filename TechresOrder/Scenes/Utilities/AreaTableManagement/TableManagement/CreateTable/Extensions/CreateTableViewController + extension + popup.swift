//
//  CreateTableViewController + extension + popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/04/2024.
//

import UIKit

extension CreateTableViewController{
    
    private func handleSelection(element:Area,menu:UIMenu) -> UIMenu{
      
        btn_choose_area.setAttributedTitle(Utils.setAttributesForBtn(content: element.name, attributes: btnAttr),for: .normal)
        var table = viewModel.table.value
        table.area_id = element.id
        viewModel.table.accept(table)

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

            let option = UIAction(title: element.name, image: nil, identifier: nil, handler: { _ in
                self.btn_choose_area.menu = self.handleSelection(element: element, menu:self.btn_choose_area.menu!)
            })

            options.append(option)
        }

        btn_choose_area.menu = UIMenu(options:.singleSelection, children: options)
        btn_choose_area.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
        
        
        if list.count > 0{
            self.btn_choose_area.menu =  handleSelection(element: list[0], menu:self.btn_choose_area.menu!)

            for element in list.filter{$0.is_select == ACTIVE} {
                self.btn_choose_area.menu = handleSelection(element: element, menu:self.btn_choose_area.menu!)
            }
        }
    }
}
