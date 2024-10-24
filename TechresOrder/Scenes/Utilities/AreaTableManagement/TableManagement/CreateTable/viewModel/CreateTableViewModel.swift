//
//  CreateTableViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class CreateTableViewModel: BaseViewModel {
    private(set) weak var view: CreateTableViewController?


    var table = BehaviorRelay<Table>(value: Table())
    var area_array = BehaviorRelay<[Area]>(value: [])

    func bind(view: CreateTableViewController){
        self.view = view
    }
 
}

extension CreateTableViewModel{

    func createTable() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.createTable(
                branch_id: Constants.branch.id,
                table_id: table.value.id,
                table_name:table.value.name,
                area_id:table.value.area_id,
                total_slot:table.value.slot_number,
                status:table.value.status
            ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
