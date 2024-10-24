//
//  CreateCategoryPopupViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/11/2023.
//

import UIKit
import RxRelay
import RxSwift

class CreateCategoryPopupViewModel: BaseViewModel {
    private(set) weak var view: CreateCategoryPopupViewController?
    var category = BehaviorRelay<Category>(value: Category()!)
    
    func bind(view: CreateCategoryPopupViewController){
        self.view = view
    }

}

extension CreateCategoryPopupViewModel{
    func createCategory() -> Observable<APIResponse> {
        dLog(category.value)
        return appServiceProvider.rx.request(.createCategory(
            name: category.value.name,
            code: category.value.code,
            description: category.value.description,
            categoryType: category.value.categoryType.value,
            status:category.value.status))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func updateCategory() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateCategory(
            id: category.value.id,
            name: category.value.name,
            code: category.value.code,
            description:category.value.description,
            categoryType: category.value.categoryType.value,
            status:category.value.status))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
