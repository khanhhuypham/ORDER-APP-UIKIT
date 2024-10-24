//
//  OtherFoodRebuildViewController + Extension + popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/12/2023.
//
//
//  AddOtherFoodViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit

extension OtherFoodViewController {
    enum Direction : String {
        
        case north, east, south, west,wests,westss,westsss
        
        static var allValues = [Direction.north, .east, .south, .west, .wests, .westss, .westsss]
        
    }
    
    
    
    func getAttribute(content:String) -> NSAttributedString{
        return NSAttributedString(
                string: content,
                attributes: [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                        NSAttributedString.Key.foregroundColor: ColorUtils.black(),
                ]
        )
    }

}

extension OtherFoodViewController: CalculatorMoneyDelegate{

    func presentMoneyInput(price:Int) {
        let vc = CaculatorInputMoneyViewController()
        vc.checkMoneyFee = 1000
        vc.limitMoneyFee = 999999999
        vc.result = price
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.delegate = self
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
    
    func callBackCalculatorMoney(amount: Int, position: Int) {
        var otherFood = viewModel.otherFood.value
        otherFood.price = amount
        viewModel.otherFood.accept(otherFood)
        btn_show_money_input.setAttributedTitle(getAttribute(content: String(format:"%@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: amount))), for: .normal)
    }

}

extension OtherFoodViewController:CaculatorInputQuantityDelegate{

    func presentQuantityInput(quantity:Float) {
        let vc = InputQuantityViewController()
        vc.max_quantity = 1000
        vc.delegate = self
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
    
    
    func callbackCaculatorInputQuantity(number:Float, position:Int, id:Int) {
        var otherFood = viewModel.otherFood.value
        otherFood.quantity = number
        
        if otherFood.quantity <= 1{
            otherFood.quantity = 1
        }else if otherFood.quantity >= 999{
            otherFood.quantity = 999
        }
        
        viewModel.otherFood.accept(otherFood)
        btn_show_quantity_input.setAttributedTitle(getAttribute(content: String(format:"%@", Utils.stringQuantityFormatWithNumberFloat(quantity: otherFood.quantity))), for: .normal)
    }
      
}
extension OtherFoodViewController{
    func showPrinterList(){
        var listName = [String]()
        var listIcon = [String]()
           
        for name in viewModel.printers.value.map{$0.name} {
            listName.append(name)
            listIcon.append("baseline_account_balance_black_48pt")
        }
           
        let controller = ArrayChooseViewController(Direction.allValues)
        
        controller.list_icons = listIcon
        controller.listString = listName
        controller.preferredContentSize = CGSize(width: btn_show_printer_list.frame.width, height: 200)
        controller.delegate = self
        
        showPopup(controller, sourceView: btn_show_printer_list)
    }

    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
}
extension OtherFoodViewController: ArrayChooseViewControllerDelegate{
    func selectAt(pos: Int) {
        lbl_printer_name.text = viewModel.printers.value[pos].name
        
        var otherFood = viewModel.otherFood.value
        otherFood.restaurant_kitchen_place_id = viewModel.printers.value[pos].id
        viewModel.otherFood.accept(otherFood)
    
    }
    
}


