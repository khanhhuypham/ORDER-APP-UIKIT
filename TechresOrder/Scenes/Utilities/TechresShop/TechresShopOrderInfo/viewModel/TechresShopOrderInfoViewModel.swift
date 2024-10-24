//
//  TechresShopOrderInfoViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit
import RxSwift
import RxRelay
class TechresShopOrderInfoViewModel: NSObject {
    
    private(set) weak var view: TechresShopOrderInfoViewController?
    
    public var orderArray : BehaviorRelay<[TechresShopOrder]> = BehaviorRelay(value: [])
    
    func bind(view: TechresShopOrderInfoViewController){
        self.view = view
    }
    
}
