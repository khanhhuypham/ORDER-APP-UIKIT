//
//  TechresShopOrderViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit
import RxRelay
class TechresShopOrderViewModel: NSObject {
    
    
    private(set) weak var view: TechresShopOrderViewController?
    
    public var deviceArray : BehaviorRelay<[TechresDevice]> = BehaviorRelay(value: [])
    
    func bind(view: TechresShopOrderViewController){
        self.view = view
    }
    
}
