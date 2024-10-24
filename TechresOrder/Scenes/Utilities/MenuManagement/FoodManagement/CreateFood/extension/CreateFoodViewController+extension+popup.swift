//
//  CreateFoodViewController+extension+popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 08/11/2023.
//

import UIKit

extension CreateFoodViewController: ArrayChooseUnitViewControllerDelegate{
    func showList(btn:UIButton,list:[String]){
        let controller = ArrayChooseUnitViewController(Direction.allValues)
        controller.listString = list
        controller.delegate = self
        controller.preferredContentSize = CGSize(width: btn.frame.width, height: 200)
        showPopup(controller, sourceView: btn)
    }
    
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        presentationController.sourceRect = CGRectMake(sourceView.bounds.origin.x, sourceView.bounds.origin.y + 135, sourceView.bounds.width, sourceView.bounds.height)
        self.present(controller, animated: true)
    }
    
    func selectUnitAt(pos: Int) {
        var model = viewModel.createFoodModel.value
        /*
            popupType = 1 <=> danh mục
            popupType = 2 <=> đơn vị
            popupType = 3 <=> printer
            popupType = 4 <=> vat
         */
        switch viewModel.popupType.value{
            case 1:
                model.category_id = viewModel.categoryList.value[pos].id
                model.category_type = viewModel.categoryList.value[pos].categoryType.value
                btn_show_category_list.setTitle("  " + viewModel.categoryList.value[pos].name , for: .normal)
                model.restaurant_kitchen_place_id = 0
                btn_show_printer.setTitle("",for: .normal)

                if model.is_addition == DEACTIVE{ //Nếu món là món chính thì ẩn hiển theo danh mục
                    view_of_addition_food.isHidden = model.category_type == CATEGORY_OF_DRINK || model.category_type == CATEGORY_OF_OTHER ? true : false
                    view_of_selling_by_weight.isHidden = model.category_type == CATEGORY_OF_DRINK || model.category_type == CATEGORY_OF_OTHER ? true : false
                    
                    if view_of_addition_food.isHidden{
                        taglist.removeAllTags()
                        
                        var list = viewModel.additionFoodList.value
                        for i in (0..<list.count){
                            list[i].is_selected = DEACTIVE
                        }
                        viewModel.additionFoodList.accept(list)
                        embeddedDropDown.selectedIds = []
                        height_of_taglist.constant = taglist.intrinsicContentSize.height
                    }
                   
                }
               
                break
            
            case 2:
                model.unit = viewModel.unitList.value[pos].name
                btn_show_unit_list.setTitle("  " + viewModel.unitList.value[pos].name, for: .normal)
                break
            
            case 3:
                var printerList = viewModel.printerList.value
                if model.category_type == 1{
                    printerList = printerList.filter{$0.type == .chef}
                } else if  model.category_type == 2 {
                    printerList = printerList.filter{$0.type == .bar}
                }

                model.restaurant_kitchen_place_id = printerList[pos].id
                btn_show_printer.setTitle("  " + printerList[pos].name, for: .normal)
                break
            
            case 4:
                model.restaurant_vat_config_id = viewModel.vatList.value[pos].id
                btn_show_vat_list.setTitle("  " + viewModel.vatList.value[pos].vat_config_name, for: .normal)
                break
            
            default:
                break
        }
        
        
        
        viewModel.createFoodModel.accept(model)
       
    }
}

extension CreateFoodViewController:dateTimePickerDelegate{
    func callbackToGetDateTime(didSelectDate: Date) {
        var model = viewModel.createFoodModel.value
        let result = convertDateToDateString(date: didSelectDate)
        switch viewModel.dateType.value{
            case 1:
                if TimeUtils.isDateValid(fromDateStr: result, toDateStr: model.temporary_price_to_date){
                    model.temporary_price_from_date = result
                    lbl_from_date_of_temporary_price.text = result
                    viewModel.createFoodModel.accept(model)
                }else {
                    showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
                    lbl_from_date_of_temporary_price.text = model.temporary_price_from_date
                }
                break

            case 2:
                if TimeUtils.isDateValid(fromDateStr: model.temporary_price_from_date, toDateStr:result){
                    model.temporary_price_to_date = result
                    viewModel.createFoodModel.accept(model)
                    lbl_to_date_of_temporary_price.text = result
                }else {
                    showWarningMessage(content: "Ngày kết thúc không được bé hơn ngày bắt đầu")
                    lbl_to_date_of_temporary_price.text = model.temporary_price_to_date
                }
                break

            default:
                break
        }
    }
    
    
    
    private func convertDateStringToDate(dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = dateFormatter.date(from: dateString)
        return date ?? Date()
    }
    
    private func convertDateToDateString(date:Date) -> String{
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return  dateFormatter.string(from: date)
        
    }
    
}



extension CreateFoodViewController: CalculatorMoneyDelegate{
    func presentModalCaculatorInputMoneyViewController(result:Int) {
        let caculatorInputMoneyViewController = CaculatorInputMoneyViewController()
        caculatorInputMoneyViewController.limitMoneyFee = 999999999
        caculatorInputMoneyViewController.result = result
        caculatorInputMoneyViewController.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: caculatorInputMoneyViewController)
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
        caculatorInputMoneyViewController.delegate = self
        present(nav, animated: true, completion: nil)

    }
    
    func callBackCalculatorMoney(amount: Int, position: Int) {
        var model = viewModel.createFoodModel.value
        model.price = amount
        lbl_food_price.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: amount)
        viewModel.createFoodModel.accept(model)
    }
    
}


