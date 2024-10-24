//
//  CreateNoteMaterialViewModel.swift
//  TECHRES-ORDER
//
//  Created by macmini_techres_01 on 27/07/2023.
//

import Foundation
import RxSwift
class CreateNoteMaterialViewModel : BaseViewModel{
    var note = BehaviorRelay<String>(value: "")
    
    var isValidNote: Observable<Bool> {
        dLog(fullNameText)
        return self.fullNameText.asObservable().map { full_name in
            full_name.count >= Constants.PROFILE_FORM_REQUIRED.requiredFullNameMinLength &&
            full_name.count <= Constants.PROFILE_FORM_REQUIRED.requiredFullNameMaxLength
        }
    }
}
extension CreateNoteMaterialViewModel{
    
}
