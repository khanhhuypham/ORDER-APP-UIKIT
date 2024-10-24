//
//  OtherFoodRebuildViewController + extension + validate.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/12/2023.
//

import UIKit
import RxSwift
extension OtherFoodViewController {
    
    func mapDataAndValidate(){
        mappData()
        isDiscountValid()
        firstSetup()
    }
    
    
    
    private func firstSetup(){
        
        text_view.withDoneButton()
        var otherFood = self.viewModel.otherFood.value
        otherFood.quantity = 1
        viewModel.otherFood.accept(otherFood)
        
        if permissionUtils.GPBH_1_o_1 {
            view_of_printer_list.isHidden = true
            btn_of_printing_chef_bar.isHidden = true
            
        }else{
            view_of_printer_list.isHidden = false
            btn_of_printing_chef_bar.isHidden = false
            actionStickcheckbox("")
//            btn_of_printing_chef_bar.setTitle(permissionUtils.GPBH_3 ? "  In Phiếu/Gửi món bếp bar" : "  In phiếu BẾP/BAR",for: .normal)
            
            if permissionUtils.GPBH_3{
                btn_of_printing_chef_bar.setTitle("  In Phiếu/Gửi món bếp bar",for: .normal)
                btn_of_printing_chef_bar.isUserInteractionEnabled = false
            }else{
                btn_of_printing_chef_bar.setTitle("  In phiếu BẾP/BAR",for: .normal)
                btn_of_printing_chef_bar.isUserInteractionEnabled = true
            }
            
        }
    }
    
    private func mappData(){
        
        
        _ = textfield_food_name.rx.text.map{(str) in
            if str!.count > 50 {
                self.showWarningMessage(content: "Độ dài tối đa 50 ký tự")
            }
            return String(str!.prefix(50))
        }.map{(name) in
            var otherFood = self.viewModel.otherFood.value
            otherFood.food_name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            return otherFood
            
        }.bind(to: viewModel.otherFood).disposed(by: rxbag)
        
        _ = text_view.rx.text.map{(str) in
            if str!.count > 255 {
                self.showWarningMessage(content: "Độ dài tối đa 255 ký tự")
            }
            return String(str!.prefix(255))
        }.map{(note) in
            self.lbl_number_of_word.text = String(format: "%d/255", note.count)
            var otherFood = self.viewModel.otherFood.value
            otherFood.note = note
            return otherFood
            
        }.bind(to: viewModel.otherFood).disposed(by: rxbag)
        
     
    }
        
    private func isDiscountValid(){
        Observable.combineLatest(isNameValid,isPriceValid,isQuantityValid,isDescriptionValid).map{(a,b,c,d) in
            return a && b && c && d
        }.subscribe(onNext: {(valid) in
            self.btn_confirm.backgroundColor = valid ? ColorUtils.orange_brand_900() : .systemGray2
            self.btn_confirm.isUserInteractionEnabled = valid ? true : false
        }).disposed(by: rxbag)
    }
    
    private var isNameValid: Observable<Bool>{
        return viewModel.otherFood.map{$0.food_name}.asObservable().map(){[self](name) in
            return  name.count >= 2 && name.count <= 50
        }
    }
    
    private var isPriceValid: Observable<Bool>{
        return viewModel.otherFood.map{$0.price}.asObservable().map(){[self](price) in
            return price >= 1000
        }
    }
    
    
    private var isQuantityValid: Observable<Bool>{
        return viewModel.otherFood.map{$0.quantity}.asObservable().map(){[self](quantity) in
            return quantity > 0
        }
    }
    
    
   
    private var isDescriptionValid: Observable<Bool>{
        return viewModel.otherFood.map{$0.note}.asObservable().map(){[self](description) in
            return  description.count >= 0 && description.count <= 250
            
        }
    }
    
    
   
}
