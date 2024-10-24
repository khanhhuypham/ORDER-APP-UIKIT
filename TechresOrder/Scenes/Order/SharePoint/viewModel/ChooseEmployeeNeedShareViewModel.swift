//
//  ChooseEmployeeNeedShareViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class ChooseEmployeeNeedShareViewModel: BaseViewModel {
    private(set) weak var view: ChooseEmployeeNeedShareViewController?
//    private var router = ChooseEmployeeNeedShareRouter()
    
  
    public var order_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var is_for_share_point : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var employee_list : BehaviorRelay<[EmployeeSharePointRequest]> = BehaviorRelay(value: [])

    public var dataArray : BehaviorRelay<[Account]> = BehaviorRelay(value: [])
    public var employeesSelected : BehaviorRelay<[Account]> = BehaviorRelay(value: [])

    public var allEmployees : BehaviorRelay<[Account]> = BehaviorRelay(value: [])
    
    
    
    func bind(view: ChooseEmployeeNeedShareViewController){
        self.view = view
    }
    
}
//MARK: -- CALL API
extension ChooseEmployeeNeedShareViewModel{
    func employeeSharePoint() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.employeeSharePoint(branch_id:branch_id.value,
            order_id: order_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    
    func employees() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.employees(branch_id:branch_id.value, is_for_share_point: is_for_share_point.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    
    func sharePoint() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.sharePoint(
            order_id: order_id.value, employee_list:employee_list.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
