//
//  CreateFood_rebuildViewController + extension + validate + mapData.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/11/2023.
//

import UIKit
import UIKit
import RxSwift
import RxRelay
import JonAlert
import TagListView

extension CreateFoodViewController:TagListViewDelegate {

    func setupData(createModel:CreateFood){
    
        if createModel.id > 0{
            lbl_title.text = "CẬP NHẬT MÓN"
            btn_update.setTitle("CẬP NHẬT", for: .normal)
            
            createModel.is_allow_print == ACTIVE ? actionStickCheckBoxPrintChefBar("") : {}()
            
        }else{
            btn_update.setTitle("THÊM", for: .normal)
            lbl_title.text = createModel.is_addition == DEACTIVE ? "THÊM MÓN" : "THÊM MÓN BÁN KÈM/TOPPING"
            
            actionStickCheckBoxPrintChefBar("")
        }
        
        food_avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: createModel.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
        textfield_of_food_name.text = createModel.name
        lbl_food_price.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: createModel.price)
        lbl_from_date_of_temporary_price.text = createModel.temporary_price_from_date.isEmpty ? TimeUtils.getFullCurrentDate() : createModel.temporary_price_from_date
        lbl_to_date_of_temporary_price.text = createModel.temporary_price_to_date.isEmpty ? TimeUtils.getFullCurrentDate() : createModel.temporary_price_to_date
        
        
        createModel.is_sell_by_weight == ACTIVE ? actionCheckSellByWeight("") : {}()
        
        createModel.is_addition_like_food == ACTIVE ? actionAddToMenu("") : {}()
        
        createModel.status == ACTIVE ? actionCheckFoodStatus("") : {}()
        
        createModel.temporary_price != 0 || createModel.temporary_percent != 0 ? actionCheckTemporaryPrice("") : {}()
        
        createModel.is_allow_print_stamp == ACTIVE ? actionStickCheckBoxPrintStamp("") : {}()
      
        createModel.restaurant_vat_config_id > 0 ? actionStickCheckBoxTax("") : {}()
        
        
    
        textfield_enter_increasing_price.isUserInteractionEnabled = false
        textfield_enter_increasing_percent.isUserInteractionEnabled = false
        textfield_enter_decreasing_price.isUserInteractionEnabled = false
        textfield_enter_decreasing_percent.isUserInteractionEnabled = false
        
        if createModel.temporary_price > 0 || createModel.temporary_percent > 0 {
            actionChooseIncreasePrice("")
            
            if createModel.temporary_percent != 0{
                actionSetTemporaryPrice(btn_enter_increasing_percent)
                textfield_enter_increasing_percent.text = String(createModel.temporary_percent)
            }else{
                actionSetTemporaryPrice(btn_enter_increasing_price)
                textfield_enter_increasing_price.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: createModel.temporary_price)
            }

           
        }else if createModel.temporary_price < 0 || createModel.temporary_percent < 0 {
            actionChooseDecreasePrice("")
                   
            if createModel.temporary_percent != 0{
                actionSetTemporaryPrice(btn_enter_decreasing_percent)
                textfield_enter_decreasing_percent.text = String(createModel.temporary_percent)
            }else{
                actionSetTemporaryPrice(btn_enter_decreasing_price)
                textfield_enter_decreasing_price.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: createModel.temporary_price).replacingOccurrences(of: "-", with: "")
            }
                                
        }
        
        
        
        /*
            if: món bán kèm thì luôn ẩn view món bàn kèm
            if: món là món chính thì phải xét xem món đó thuộc danh mục gì
                                                                            if: category_type == CATEGORY_OF_DRINK || CATEGORY_OF_OTHER -> ẩn đi view món bán kèm
         */
        if createModel.is_addition == ACTIVE{
            view_of_addition_food.isHidden = true
            view_of_selling_by_weight.isHidden = true
        }else{
            view_of_addition_food.isHidden = createModel.category_type == CATEGORY_OF_DRINK ? true : false
            view_of_selling_by_weight.isHidden = createModel.category_type == CATEGORY_OF_DRINK || createModel.category_type == CATEGORY_OF_OTHER ? true : false
        }
        
        
        view_of_adding_to_menu.isHidden = createModel.is_addition == ACTIVE ? false : true
        
        stackview_of_print_chef_bar.isHidden = permissionUtils.GPBH_1_o_1 ? true : false
        
        mappingData()
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
       
        var list = viewModel.additionFoodList.value
        if let position = list.firstIndex(where: {$0.name == title}){
            list[position].is_selected = DEACTIVE
            taglist.removeTag(title)
        }

        embeddedDropDown.selectedIds = list.filter{$0.is_selected == ACTIVE}.map{$0.id}
       
        viewModel.additionFoodList.accept(list)
        taglist.isHidden = taglist.intrinsicContentSize.height > 0 ? false : true
        height_of_taglist.constant = taglist.intrinsicContentSize.height
    }
    
   


    private func mappingData(){
        taglist.isHidden = true
        taglist.delegate = self
        embeddedDropDown.multiSelection = true
        embeddedDropDown.didSelect(completion: {[self] (string,index,id) in
            taglist.isHidden = false
            var list = viewModel.additionFoodList.value
            if let position = list.firstIndex(where: {$0.id==id}){
                
                list[position].is_selected = list[position].is_selected == ACTIVE ? DEACTIVE : ACTIVE
                if list[position].is_selected == ACTIVE{
                    taglist.addTag(list[position].name)
                }else if list[position].is_selected == DEACTIVE  {
                   taglist.removeTag(list[position].name)
                }
            }
            viewModel.additionFoodList.accept(list)
            embeddedDropDown.selectedIds = list.filter{$0.is_selected == ACTIVE}.map{$0.id}
            height_of_taglist.constant = taglist.intrinsicContentSize.height
            taglist.isHidden = taglist.intrinsicContentSize.height > 0 ? false : true
        })
    


        _ = textfield_of_food_name.rx.text.map{(str) in
            if str!.count > 100 {
                self.showWarningMessage(content: "Độ dài tối đa 100 ký tự")
            }else if str!.count < 2 && !str!.isEmpty{
                self.showWarningMessage(content: "Độ dài tối thiểu 2 ký tự")
            }
            return String(str!.prefix(100))
        }.map{[self] name in
            textfield_of_food_name.text = name
            var model = viewModel.createFoodModel.value
            model.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            return model
        }.bind(to:viewModel.createFoodModel).disposed(by: rxbag)
        
        
        _ = textfield_enter_increasing_price.rx.text.map{[self] price in
            let temporaryPrice = price!.trim().replacingOccurrences(of: ",", with: "")
            var model = viewModel.createFoodModel.value
            
            if btn_enter_increasing_price.isSelected{
                model.temporary_price = Int(temporaryPrice) ?? 0
                model.temporary_percent = 0
           
                if model.temporary_price > 999999999{
                    model.temporary_price = 999999999
                }
    
                insertText(
                    text:Utils.stringVietnameseMoneyFormatWithNumberInt(amount: model.temporary_price),
                    textField: textfield_enter_increasing_price
                )
            }
                        
            return model
        }.bind(to: viewModel.createFoodModel).disposed(by: rxbag)
        
        
        _ = textfield_enter_increasing_percent.rx.text.map{[self] percent in
            
            var model = viewModel.createFoodModel.value
            
            if btn_enter_increasing_percent.isSelected{
             
                model.temporary_percent = (Int(percent ?? "") ?? 0)
                model.temporary_price = 0
                
                if model.temporary_percent > 100{
                    model.temporary_percent = 100
                    showWarningMessage(content: "Phần trăm phải nhỏ hơn hoặc bằng 100")
                   
                }
                

                insertText(
                    text: String(abs(model.temporary_percent)),
                    textField: textfield_enter_increasing_percent
                )
            }
             
            return model
        }.bind(to: viewModel.createFoodModel).disposed(by: rxbag)
        
       
        _ = textfield_enter_decreasing_price.rx.text.map{[self] price in
            let temporaryPrice = price!.trim().replacingOccurrences(of: ",", with: "")
        
            var model = viewModel.createFoodModel.value
            
            if btn_enter_decreasing_price.isSelected{
                /*vì giá thời vụ dù tăng hay giảm cũng điều map vào trường model.temporary_price nên ta phải dựa vào
                    btn_decrease_price & btn_increase_price để phẩn loại chính xác
                    */
                model.temporary_price = (Int(temporaryPrice) ?? 0)*(-1)
                model.temporary_percent = 0
                
                if model.temporary_price < -999999999{
                    model.temporary_price = -999999999
                }
                
                insertText(
                    text: Utils.stringVietnameseMoneyFormatWithNumberInt(amount: abs(model.temporary_price)),
                    textField: textfield_enter_decreasing_price
                )
            }
         
            return model
        }.bind(to: viewModel.createFoodModel).disposed(by: rxbag)
        
        
        _ = textfield_enter_decreasing_percent.rx.text.map{[self] percent in
            
            var model = viewModel.createFoodModel.value
            
            if btn_enter_decreasing_percent.isSelected{
                /*vì giá thời vụ dù tăng hay giảm cũng điều map vào trường model.temporary_percent nên ta phải dựa vào
                    btn_decrease_price & btn_increase_price để phẩn loại chính xác
                    */
                model.temporary_percent = (Int(percent ?? "") ?? 0)*(-1)
                model.temporary_price = 0
                
                if model.temporary_percent < -100{
                    model.temporary_percent = -100
                    showWarningMessage(content: "Phần trăm phải nhỏ hơn hoặc bằng 100")
                }
        

                insertText(
                    text: String(abs(model.temporary_percent)),
                    textField: textfield_enter_decreasing_percent
                )
            }
            
            return model
        }.bind(to: viewModel.createFoodModel).disposed(by: rxbag)
      
    }
    
    
    private func insertText(text:String, textField:UITextField){
        textfield_enter_increasing_price.text = ""
        textfield_enter_increasing_percent.text = ""
        textfield_enter_decreasing_price.text = ""
        textfield_enter_decreasing_percent.text = ""
        textField.text = text
    }


    var isCreateFoodModelValid: Observable<Bool>{
        return Observable.combineLatest(isNameValid,isPriceValid,isTemporaryPriceValid,isTemporaryPercentValid,isPrinterValid){$0 && $1 && $2 && $3 && $4}
    }
    
    

    private var isNameValid: Observable<Bool>{
        return viewModel.createFoodModel.map{$0.name}.asObservable().map(){[self](name) in
            if name.isEmpty{
                self.showWarningMessage(content: "vui lòng nhập tên món ăn")
                return false
            }else if name.count < 2 || name.count > 50  {
                return false
            }else {
                return true
            }
        }
    }

    private var isPriceValid: Observable<Bool>{
        return viewModel.createFoodModel.map{$0.price}.distinctUntilChanged().asObservable().map(){[self](str) in
            let model = viewModel.createFoodModel.value
            let price = Int(str)
            
            if model.is_addition == DEACTIVE{
                if price == 0{
                    self.showWarningMessage(content: "vui lòng nhập giá bán")
                    return false
                }else if price < 1000 || price > 999999999{
                    self.showWarningMessage(content: "Giá trị tối thiểu có thể là 1,000 và tối đa có thể là 999,999,999")
                    return false
                } else {
                    return true
                }
            }else{
                return true
            }
        }
    }
    
    
    private var isTemporaryPriceValid: Observable<Bool>{
        return viewModel.createFoodModel.map{$0.temporary_price}.distinctUntilChanged().asObservable().map(){[self](price) in
            
            if btn_stick_checkbox_temporaryPrice.isSelected{
                
            
                if btn_enter_increasing_price.isSelected{
                    
                    if price == 0{
                        self.showWarningMessage(content: "Vui lòng nhập giá tiền cần tăng")
                        return false
                    }else if price < 1000 || price > 999999999{
                        self.showWarningMessage(content: "Giá trị tối thiểu của giá thời vụ là 1,000 và tối đa là 999,999,999")
                        return false
                    }
                    
                  
                }else if btn_enter_decreasing_price.isSelected {
                   
                    if price == 0{
                        self.showWarningMessage(content: "Vui lòng nhập giá tiền cần giảm")
                        return false
                    }else if price < -999999999 || price > -1000{
                        self.showWarningMessage(content: "Giá trị tối thiểu của giá thời vụ là 1,000 và tối đa là 999,999,999")
                        return false
                    }else if abs(price) > viewModel.createFoodModel.value.price{
                        self.showWarningMessage(content: "Giá giảm không được lớn hơn giá món")
                        return false
                    }
                    
                }
            }
            return true
        }
    }
    
    
    private var isTemporaryPercentValid: Observable<Bool>{
        return viewModel.createFoodModel.map{$0.temporary_percent}.distinctUntilChanged().asObservable().map(){[self](percent) in
            if btn_stick_checkbox_temporaryPrice.isSelected{
                if btn_enter_increasing_percent.isSelected && percent == 0{
                    self.showWarningMessage(content: "Vui lòng nhập phần trăm tăng giá món")
                    return false
                }else if btn_enter_decreasing_percent.isSelected && percent == 0{
                    self.showWarningMessage(content: "Vui lòng nhập phần trăm giảm giá món")
                    return false
                }
            }
            return true
        }
    }
    
    
    private var isPrinterValid: Observable<Bool>{
        return viewModel.createFoodModel.map{$0.restaurant_kitchen_place_id}.distinctUntilChanged().asObservable().map(){[self](id) in
            if btn_stick_checkbox_print_chef_bar.isSelected{
                
                if id == 0{
                    self.showWarningMessage(content: "Vui lòng chọn máy in")
                    return false
                }
            }
            return true
        }
    }
}
