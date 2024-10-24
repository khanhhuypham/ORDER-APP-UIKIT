//
//  DiscountViewController + extension + Validate.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 14/11/2023.
//

import UIKit
import RxSwift
extension DiscountViewController {
    
    func mapDataAndValidate(){
        mappData()
        isDiscountValid()
    }
    
    private func mappData(){
        _ = textfield_discount_percent_of_food.rx.text.map{[self] str in
            
            var percent = Int(str ?? "0") ?? 0
 
            if percent > 100{
                showWarningMessage(content: "Phần trăm giảm giá món ăn không được quá 100%")
                percent = 100
                textfield_discount_percent_of_food.text = String(percent)
            }
            
            return percent
        }.bind(to: viewModel.food_discount_percent).disposed(by: rxbag)
        
        _ = textfield_discount_percent_of_drink.rx.text.map{[self] str in
            var percent = Int(str ?? "0") ?? 0
          
            if percent > 100{
                showWarningMessage(content: "Phần trăm giảm giá thức uống không được quá 100%")
                percent = 100
                textfield_discount_percent_of_drink.text = String(percent)
            }
            
            return percent
        }.bind(to: viewModel.drink_discount_percent).disposed(by: rxbag)
        
        
        _ = textfield_discount_percent_on_bill.rx.text.map{[self] str in
            var percent = Int(str ?? "0") ?? 0
            if percent > 100{
                showWarningMessage(content: "Phần trăm giảm giá trên tổng bill không được quá 100%")
                percent = 100
                textfield_discount_percent_on_bill.text = String(percent)
            }
            return percent
        }.bind(to: viewModel.total_bill_discount_percent).disposed(by: rxbag)
    }
        
    private func isDiscountValid(){
        Observable.combineLatest(isDiscountByFoodValid,isDiscountByDrinkValid,isDiscountOnBillValid).map{ (a,b,c) in
            return (a || b) && c
        }.subscribe(onNext: {(valid) in
            self.btnDiscount.backgroundColor = valid ? ColorUtils.orange_brand_900() : .systemGray2
            self.btnDiscount.isEnabled = valid ? true : false
        }).disposed(by: rxbag)
    }
    
    private var isDiscountByFoodValid: Observable<Bool>{
        return viewModel.food_discount_percent.asObservable().map(){[self](percent) in
            if btnDiscountByCategory.isSelected {
                if btnDiscountFood.isSelected{
                    return  percent > 0 && percent <= 100
                }else{
                    return false
                }
            }else {
                return true
            }
        }
    }
    
    private var isDiscountByDrinkValid: Observable<Bool>{
        return viewModel.drink_discount_percent.asObservable().map(){[self](percent) in
            if btnDiscountByCategory.isSelected{
                if btnDiscountDrink.isSelected{
                    return  percent > 0 && percent <= 100
                }else{
                    return false
                }
            }else {
                return true
            }
        }
    }
    
   
    private var isDiscountOnBillValid: Observable<Bool>{
        return viewModel.total_bill_discount_percent.asObservable().map(){[self](percent) in
            if btnDiscountTotalBill.isSelected{
                return  percent > 0 && percent <= 100
            }else {
                return true
            }
            
        }
    }
    
    
   
}
