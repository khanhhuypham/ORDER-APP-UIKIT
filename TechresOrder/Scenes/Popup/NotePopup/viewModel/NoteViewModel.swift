//
//  NoteViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 10/02/2023.
//

import UIKit
import RxSwift
import RxRelay

class NoteViewModel: BaseViewModel {
    
    private(set) weak var view: NoteViewController?
    
    // Khai báo biến để hứng dữ liệu từ VC
    var note = BehaviorRelay<String>(value: "")
    public var order_detail_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)

    // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
    var isValidNote: Observable<Bool> {
        return self.note.asObservable().map { note in
            note.count >= 1 &&
            note.count <= 50
        }
    }
    // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
    var isValid: Observable<Bool> {
        return isValidNote
    }

}
extension NoteViewModel{
    func notes() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.notes(branch_id: Constants.branch.id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func notesByFood() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.notesByFood(food_id: order_detail_id.value, branch_id: Constants.branch.id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
