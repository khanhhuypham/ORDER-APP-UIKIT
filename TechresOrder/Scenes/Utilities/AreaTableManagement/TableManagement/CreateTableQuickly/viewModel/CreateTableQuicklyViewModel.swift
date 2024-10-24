//
//  CreateTableQuicklyViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 19/01/2024.
//

import UIKit
import RxSwift
import RxRelay
class CreateTableQuicklyViewModel: BaseViewModel {
    
    private(set) weak var view: CreateTableQuicklyViewController?
    

    var parameter = BehaviorRelay<(
        name:String,
        numberFrom:Int,
        numberTo:Int,
        slot:Int
    )>(value: (
        name:"",
        numberFrom:0,
        numberTo:0,
        slot:0
    ))
    
    
    
    var areaList = BehaviorRelay<[Area]>(value:[])
    
    func bind(view: CreateTableQuicklyViewController){
        self.view = view
    }
    
}
extension CreateTableQuicklyViewModel{
    
    func createTableList() -> Observable<APIResponse> {
        let p = parameter.value
        var tables:[CreateTableQuickly] = []
        
        for i in (p.numberFrom...p.numberTo){
            tables.append(CreateTableQuickly.init(name: String(format: "%@%d",p.name,i), total_slot: p.slot))
        }
        var areaId = 0
        if areaList.value.filter{$0.is_select == ACTIVE}.count > 0{
            dLog(areaList.value.filter{$0.is_select == ACTIVE}[0])
            areaId = areaList.value.filter{$0.is_select == ACTIVE}[0].id
        }
        
        
        
        return appServiceProvider.rx.request(.postCreateTableList(
            branch_id: ManageCacheObject.getCurrentBranch().id,
            area_id: areaId,
            tables: tables
        ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
            
    
}
