//
//  AddFood_RebuildViewController + Extension + Popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/09/2023.
//

import UIKit

extension AddFoodViewController: NotFoodDelegate{
    func callBackNoteFood(pos:Int, id:Int, note:String) {
        
        switch viewModel.APIParameter.value.category_type{
            case .buffet_ticket:
                break
            
            default:
                
                if var food = viewModel.getFood(id: id){
                    food.note = note
                    food.select()
                    viewModel.setElement(element: food, categoryType: .food)
                }
            
                let indexPath = IndexPath(item: pos, section: 0)
                tableView.reloadRows(at: [indexPath], with: .none)
                break
            
        }
        
    }
    
    
    func presentModalNoteViewController(pos:Int,id:Int,note:String = "") {
        let vc = NoteViewController()
        vc.delegate = self
        vc.pos = pos
        vc.food_id = id
        vc.food_note = note
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)

    }
} 

extension AddFoodViewController:EnterPercentDelegate{
    func callbackToGetPercent(id:Int,percent: Int) {
        if var food = viewModel.getFood(id: id){
          
            food.discount_percent = percent
            if food.discount_percent > 0{
                food.select()
            }
            viewModel.setElement(element: food, categoryType: .food)
        }
    }
    
    
    func presentPopupDiscountViewController(itemId:Int,percent:Int? = nil) {
        let vc = PopupEnterPercentViewController()
        vc.header = "GIẢM GIÁ MÓN"
        vc.placeHolder = "Vui lòng nhập % bạn muốn giảm giá"
        vc.percent = percent
        vc.itemId = itemId
        vc.delegate = self
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
}


extension AddFoodViewController:EnterPercentForBuffetDelegate{
    func callbackToGetBuffet(buffet:Buffet){
        viewModel.setElement(element: buffet, categoryType: .buffet_ticket)
    }
    

    func presentPopupEnterPercentForBuffetViewController(buffet:Buffet) {
        let vc = PopupEnterPercentForBuffetViewController()
        vc.buffet.accept(buffet)
        vc.delegate = self
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }

}





extension AddFoodViewController:CaculatorInputQuantityDelegate{

    func presentModalInputQuantityViewController(item:Any) {

        let vc = QuantityInputViewController()
        
        switch viewModel.APIParameter.value.category_type{
            case .buffet_ticket:
                let buffet = item as! Buffet
                vc.id = buffet.id
                vc.current_quantity = Float(buffet.quantity)
                break
            
            default:
                let food = item as! Food
                vc.is_sell_by_weight = food.is_sell_by_weight
                vc.id = food.id
                vc.current_quantity = food.quantity
                break
        }
        
       
        vc.max_quantity = 999
        vc.delegate_quantity = self
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: vc)
            // 1
        nav.modalPresentationStyle = .overCurrentContext
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
    
        present(nav, animated: true, completion: nil)

    }
      
    func callbackCaculatorInputQuantity(number: Float, position:Int,id:Int) {
        
        switch viewModel.APIParameter.value.category_type{
            case .buffet_ticket:
                
                if var buffet = viewModel.getBuffet(id: id){
                    
                    if buffet.ticketChildren.count > 0{
                        
                        if let position = buffet.ticketChildren.firstIndex(where: {$0.ticketType == viewModel.buffetTicketType.value}){
                            
                            buffet.ticketChildren[position].setQuantity(quantity:Int(number))
                        }

                    }else{
                        buffet.setQuantity(quantity: Int(number))
                    }
                    viewModel.setElement(element: buffet, categoryType: .buffet_ticket)
                }
                break
            
            default:
                        
                if var food = viewModel.getFood(id: id){
                    food.setQuantity(quantity: number)
                    viewModel.setElement(element: food, categoryType: .food)
                }
            
                break
        }

    }
    
}

