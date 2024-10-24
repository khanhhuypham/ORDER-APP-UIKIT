//
//  AssignToBranch + extension + popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/09/2024.
//

import UIKit


extension AssignToBranchViewController{
    func showList(list:[BranchOfFoodApp],btn:UIButton){
      
        var dropDownList:[(id:Int,name:String,icon:String?)] = []
           
        for element in list {
          
            dropDownList.append(
                (element.channel_order_food_token_id,element.branch_name,nil)
            )
        }
           
        let controller = DropDownViewController(Direction.allValues)
        
        controller.list = dropDownList
        controller.preferredContentSize = CGSize(width: btn.frame.width, height: 200)
        controller.delegate = self
        
        showPopup(controller, sourceView: btn)
    }

    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        presentationController.sourceRect = CGRectMake(sourceView.bounds.origin.x, sourceView.bounds.origin.y + 135, sourceView.bounds.width, sourceView.bounds.height)
        self.present(controller, animated: true)
    }
    
   
    
}
extension AssignToBranchViewController: chooseItemDelegate{
  
    func selectItem(id: Int) {
     
        var branches = viewModel.branches.value
        
        var slots = viewModel.slots.value

        
        if let pos = branches.firstIndex(where: {$0.channel_order_food_token_id == id}){
            
            if let i = slots.firstIndex(where: {$0.slotNumber == viewModel.selectedslot.value}){
                
                
                if let j = branches.firstIndex(where: {$0.channel_order_food_token_id == slots[i].branch?.channel_order_food_token_id}){
                    branches[j].isSelect = false
                }
                
                //branches with channel_order_food_token_id = -1 is "Vui lòng chọn"
                branches[pos].isSelect = branches[pos].channel_order_food_token_id == -1 ? false : true
                slots[i].branch = branches[pos].channel_order_food_token_id == -1 ? nil : branches[pos]
        
            }
        }

        for branch in branches{
            dLog(branch)
        }
 
        viewModel.branches.accept(branches)
        viewModel.slots.accept(slots)

    }
    
}
