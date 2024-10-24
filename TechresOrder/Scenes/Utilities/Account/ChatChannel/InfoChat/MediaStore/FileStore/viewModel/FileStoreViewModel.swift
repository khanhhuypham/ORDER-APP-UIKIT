//
//  FileStoreViewModel.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 03/01/2024.
//  Copyright © 2024 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class FileStoreViewModel: NSObject {

    private(set) weak var view: FileStoreViewController?
    private var router: FileStoreRouter?
    
    public var dataArray : BehaviorRelay<[MediaStore]> = BehaviorRelay(value: [])
    
    // List Media
    public var type : BehaviorRelay<Int> = BehaviorRelay(value: 4) // Tin nhắn TechRes
    public var media_type : BehaviorRelay<String> = BehaviorRelay(value: "\(TYPE_FILE)")
    public var object_id : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var from : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var limit : BehaviorRelay<Int> = BehaviorRelay(value: 20)
    public var position : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func bind(view: FileStoreViewController, router: FileStoreRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension FileStoreViewModel {
    func getListMedia() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getListMedia(type: type.value, media_type: media_type.value, object_id: object_id.value, from: from.value, to: to.value, limit: limit.value, position: position.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
}
