//
//  TechresShopCartViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit
import RxRelay
import RxSwift
class TechresShopCartViewModel {
    
    private(set) weak var view: TechresShopCartViewController?
    
    public var deviceArray : BehaviorRelay<[TechresDevice]> = BehaviorRelay(value: [])
    
    func bind(view: TechresShopCartViewController){
        self.view = view
    }
    
    
}
