//
//  ExtraFoodViewController + Extension + validate.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/04/2024.
//

import UIKit
import RxSwift
    

extension ExtraFoodViewController {
    func isExtraChargetValid(){
        Observable.combineLatest(isPriceValid,isDescriptionValid).map{(a,b) in
            return a && b
        }.subscribe(onNext: {(valid) in
            self.btnSubmit.backgroundColor = valid ? ColorUtils.orange_brand_900() : .systemGray2
            self.btnSubmit.isUserInteractionEnabled = valid ? true : false
        }).disposed(by: rxbag)
    }
    

    private var isPriceValid: Observable<Bool>{
        return viewModel.charge.map{$0.price}.asObservable().map(){[self](price) in
            return price >= 1000
        }
    }
    
    
    
    private var isDescriptionValid: Observable<Bool>{
        return viewModel.charge.map{$0.description}.asObservable().map(){[self](des) in
            return  des.count > 0 && des.count <= 255
            
        }
    }
    
}
