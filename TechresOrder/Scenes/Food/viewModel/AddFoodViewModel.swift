//
//  AddFood_RebuildViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/09/2023.
//

import UIKit
import RxSwift
import RxRelay
import RxDataSources



class AddFoodViewModel: BaseViewModel {
    
    private(set) weak var view: AddFoodViewController?
    private var router: AddFoodRouter?
    
    public var sectionArray = BehaviorRelay<[SectionModel<FOOD_CATEGORY,Any>]>(value:[
        SectionModel(model: FOOD_CATEGORY.food,items: [])
    ])
    
    public var order : BehaviorRelay<OrderDetail> = BehaviorRelay(value: OrderDetail.init())
    public var categoryArray : BehaviorRelay<[Category]> = BehaviorRelay(value: [])
    public var buffetTicketType = BehaviorRelay<BuffetTicketType>(value: .adult)
    
    

    public var selectedFoods : BehaviorRelay<[Food]> = BehaviorRelay(value: [])
    public var selectedBuffet : BehaviorRelay<Buffet?> = BehaviorRelay(value: nil)
    
    public var APIParameter : BehaviorRelay<(
        category_id:Int,
        category_type:FOOD_CATEGORY,
        is_allow_employee_gift:Int,	
        is_sell_by_weight:Int,
        is_out_stock:Int,
        is_use_point:Int,
        key_word:String,
        limit:Int,
        page:Int,
        isGetFullData:Bool,
        isAPICalling:Bool
    )> = BehaviorRelay(value: (
            category_id:-1,
            category_type:.all,
            is_allow_employee_gift:-1,
            is_sell_by_weight:0,
            is_out_stock:-1,
            is_use_point:0,
            key_word:"",
            limit:50,
            page:1,
            isGetFullData:false,
            isAPICalling:false
        )
    )
    
   
    func clearData(){
        var p = APIParameter.value
        p.page = 1
        p.isGetFullData = false
        p.isAPICalling = false
        APIParameter.accept(p)
        
        if APIParameter.value.category_type == .buffet_ticket{
            sectionArray.accept(
                [SectionModel(model:FOOD_CATEGORY.buffet_ticket, items:[])]
            )
            
        }else{
            sectionArray.accept(
                [SectionModel(model:FOOD_CATEGORY.food, items:[])]
            )
        }
    
    }
    
    
    func setElement(element:Any,categoryType:FOOD_CATEGORY){
        guard var section = sectionArray.value.first else {return}
        var index:Int?
        switch categoryType{
            
            case .buffet_ticket:
                var list = section.items as! [Buffet]
                let item = element as! Buffet
            
                for (i,data) in list.enumerated(){
             
                    if data.id != item.id {
                        list[i].deSelect()
                        index = i
                    }else{
                        list[i] = item
                        //========================  save selected item ============
                        self.selectedBuffet.accept(item)
                    }
                }

                section.items = list
                
                    
            default:
                var list = section.items as! [Food]
                var selectedFoods = selectedFoods.value
                let item = element as! Food
                if let position = list.firstIndex(where:{$0.id == item.id}){
                    list[position] = item
                    index = nil
                }
            
                section.items = list
                
            
                //========================  save selected item ============
                if let p = selectedFoods.firstIndex(where:{$0.id == item.id}){
                  
                    
                    if item.is_selected == ACTIVE{
                        selectedFoods[p] = item
                    }else{
                        selectedFoods.remove(at: p)
                    }
                    
                }else{
                    selectedFoods.append(item)
                }
            
                self.selectedFoods.accept(selectedFoods)
            
        }
    
        sectionArray.accept([section])
        
        if index != nil {
            view?.tableView.reloadRows(at: [IndexPath(row: index ?? 0, section: 0)], with: .fade)
        }

    }
    
    
    
    
    func getBuffet(id:Int) -> Buffet?{
        guard let section = sectionArray.value.first else {return nil}
        let list = section.items as! [Buffet]
       
        
        if let position = list.firstIndex(where:{$0.id == id}){
            return list[position]
        }
        
        return nil
    }
    
    func getFood(id:Int) -> Food?{
        guard let section = sectionArray.value.first else {return nil}
        let list = section.items as! [Food]

        if let position = list.firstIndex(where:{$0.id == id}){
            return list[position]
        }
        return nil
    }
    


    func bind(view: AddFoodViewController, router: AddFoodRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makeOrderDetailViewController(){
        router?.navigateToOrderDetailViewController(order: order.value)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
        
}

// MARK: VALIDATE
extension AddFoodViewModel {
    var isValidDataArray: Observable<Bool> {
        return sectionArray.asObservable().map { sections in
            // Check if any section contains active items based on section model
            return sections.contains { section in
                
                switch section.model {
                    
                    case .food, .drink, .other, .service, .seafood:
                        // Check items in 'food' section
                        if let foodItems = section.items as? [Food] {
                            return foodItems.contains{$0.is_selected == ACTIVE}
                        }
                        return false

                    case .buffet_ticket:
                        // Check items in 'buffet' section with additional condition
                        if let buffetItems = section.items as? [Buffet] {
                            return buffetItems.contains{$0.isSelected == ACTIVE}
                        }
                        return false
                    
                    default:
                        return false
                }
            }
        }
    }

}


extension AddFoodViewModel {
    
    //MARK: API lấy danh sách danh mục
    func getCategories() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.categoriesManagement(
            brand_id:Constants.brand.id,
            status: ACTIVE,
            category_types: APIParameter.value.category_type == .all ? "" : String(APIParameter.value.category_type.rawValue)
        ))
           .filterSuccessfulStatusCodes()
           .mapJSON().asObservable()
           .showAPIErrorToast()
           .mapObject(type: APIResponse.self)
    }
    
    //MARK: API lấy danh sách món ăn
    func foods() -> Observable<APIResponse> {
       
        return appServiceProvider.rx.request(.foods(
            branch_id: Constants.branch.id,
            area_id: permissionUtils.GPBH_1 ? -1 : order.value.area_id,
            category_id: APIParameter.value.category_id,
            category_type: APIParameter.value.category_type.rawValue,
            is_allow_employee_gift: APIParameter.value.is_allow_employee_gift,
            is_sell_by_weight: APIParameter.value.is_sell_by_weight,
            is_out_stock: APIParameter.value.is_out_stock,
            key_word: APIParameter.value.key_word,
            limit: APIParameter.value.limit,
            page:APIParameter.value.page
        ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    

    //MARK: API thêm món ăn vào order
    func addFoods(items:[FoodRequest]) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(
            .addFoods(
                branch_id: Constants.branch.id,
                order_id: order.value.id,
                foods: items,
                is_use_point: APIParameter.value.is_use_point
            ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }

    func addGiftFoods(items:[FoodRequest]) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(
            .addGiftFoods(
                branch_id: Constants.branch.id,
                order_id: order.value.id,
                foods: items,
                is_use_point: APIParameter.value.is_use_point
        ))
           .filterSuccessfulStatusCodes()
           .mapJSON().asObservable()
           .showAPIErrorToast()
           .mapObject(type: APIResponse.self)
    }
    //MARK: API order tại bàn
    func createDineInOrder() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.openTable(
            table_id: order.value.table_id))    
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    //MARK: API tạo order mới, trong trường hợp mang về.
    func createTakeOutOder() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(
            .postCreateOrder(
                branch_id: Constants.branch.id,
                table_id: order.value.table_id,
                note: ""
            ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
  
    
    func healthCheckDataChangeFromServer() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(
            .healthCheckChangeDataFromServer(
                branch_id: Constants.branch.id,
                restaurant_brand_id: Constants.brand.id,
                restaurant_id: Constants.restaurant_id
            ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}

//MARK: define API for buffet
extension AddFoodViewModel{
    
   
    func healthCheckForBuffet(buffet:Buffet) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(
            .healthCheckForBuffet(
                restaurant_brand_id: Constants.brand.id,
                branch_id: Constants.branch.id,
                restaurant_id: Constants.restaurant_id,
                buffet_ticket_id: buffet.buffet_ticket_id
            ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    
    //MARK: API lấy danh sách vé buffet
    func getBuffetTickets() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getBuffetTickets(
            brand_id: Constants.brand.id,
            status: ACTIVE,
            key_search:APIParameter.value.key_word,
            limit: APIParameter.value.limit,
            page: APIParameter.value.page)
        )
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func getDetailOfBuffetTicket(buffet:Buffet) -> Observable<APIResponse> {
        
        
        return appServiceProvider.rx.request(
            .getDetailOfBuffetTicket(
                branch_id: Constants.branch.id,
                category_id: APIParameter.value.category_id,
                buffet_ticket_id: buffet.buffet_ticket_id,
                key_search: APIParameter.value.key_word,
                limit: APIParameter.value.limit,
                page: APIParameter.value.page
            ))
                     .filterSuccessfulStatusCodes()
                     .mapJSON().asObservable()
                     .showAPIErrorToast()
                     .mapObject(type: APIResponse.self)
    }
    
    
    func createBuffetTickets(buffet:Buffet) -> Observable<APIResponse> {
        
        return appServiceProvider.rx.request(.postCreateBuffetTicket(
            branch_id:Constants.branch.id,
            order_Id: order.value.id,
            buffet_id: buffet.id,
            adult_quantity: buffet.adult_quantity,
            adult_discount_percent: buffet.adult_discount_percent,
            child_quantity: buffet.child_quantity,
            chilren_discount_percent: buffet.child_discount_percent
        ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    

}
