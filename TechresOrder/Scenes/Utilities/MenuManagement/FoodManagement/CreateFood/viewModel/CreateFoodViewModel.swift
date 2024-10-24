//
//  CreateFood_rebuildViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 08/11/2023.
//

import UIKit
import RxSwift
import RxRelay

class CreateFoodViewModel: BaseViewModel {
    private(set) weak var view: CreateFoodViewController?
    private var router:CreateFooddRouter?
    var branch_id = BehaviorRelay<Int>(value: ManageCacheObject.getCurrentBranch().id)
    var brand_id = BehaviorRelay<Int>(value: ManageCacheObject.getCurrentBrand().id)
    var status = BehaviorRelay<Int>(value: ACTIVE)
    

    var createFoodModel = BehaviorRelay<CreateFood>(value: CreateFood.init())
    /*
         is_addition = DEACTIVE <=> món chính
         is_addition = ACTIVE <=> món bán kèm
     */
    var is_addition = BehaviorRelay<Int>(value: 0)
    var dateType = BehaviorRelay<Int>(value: 0)
    /*
        popupType = 1 <=> danh mục
        popupType = 2 <=> đơn vị
        popupType = 3 <=> printer
        popupType = 4 <=> vat
     */
    var popupType = BehaviorRelay<Int>(value: 0)

    public var categoryList = BehaviorRelay<[Category]>(value: [])
    public var unitList = BehaviorRelay<[Unit]>(value: [])
    public var additionFoodList:BehaviorRelay<[Food]> = BehaviorRelay(value: [])
    public var printerList = BehaviorRelay<[Printer]>(value: [])
    public var vatList = BehaviorRelay<[Vat]>(value: [])
    
    
    func bind(view: CreateFoodViewController, router: CreateFooddRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    

    
}
extension CreateFoodViewModel{
    
    func getPrinters() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.kitchenes(branch_id: branch_id.value, brand_id: brand_id.value, status:status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getCategories() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.categoriesManagement(brand_id:brand_id.value,status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getUnits() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.units)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func createFood() -> Observable<APIResponse> {
        dLog(createFoodModel.value.toJSON())
        return appServiceProvider.rx.request(.createFood(branch_id: branch_id.value, foodRequest: createFoodModel.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func updateFood() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateFood(branch_id: branch_id.value, foodRequest: createFoodModel.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func getVAT() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.vats)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func getFoodsManagement() -> Observable<APIResponse> {// món bán kèm
        return appServiceProvider.rx.request(.foodsManagement(branch_id:branch_id.value, is_addition: 1, status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}
