//
//  DialogSelectMonthViewModel.swift
//  ORDER
//
//  Created by Kelvin on 14/05/2023.
//

import UIKit
import RxRelay
import RxSwift

class DialogSelectMonthViewModel: BaseViewModel {
    public var dataArray : BehaviorRelay<[Int]> = BehaviorRelay(value: [])
    
}
