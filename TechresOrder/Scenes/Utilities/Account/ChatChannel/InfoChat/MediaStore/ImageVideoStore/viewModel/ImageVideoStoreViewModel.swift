//
//  ImageVideoStoreViewModel.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 29/12/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import Moya

class ImageVideoStoreViewModel: NSObject {
    
    private(set) weak var view: ImageVideoStoreViewController?
    private var router: ImageVideoStoreRouter?
    
    public var dataArray : BehaviorRelay<[MediaStore]> = BehaviorRelay(value: [])
    
    // List Media
    public var type : BehaviorRelay<Int> = BehaviorRelay(value: 4) // Tin nhắn TechRes
    public var media_type : BehaviorRelay<String> = BehaviorRelay(value: "\(TYPE_IMAGE), \(TYPE_VIDEO)")
    public var object_id : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var from : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var limit : BehaviorRelay<Int> = BehaviorRelay(value: 20)
    public var position : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func bind(view: ImageVideoStoreViewController, router: ImageVideoStoreRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
extension ImageVideoStoreViewModel {
    func getListMedia() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getListMedia(type: type.value, media_type: media_type.value, object_id: object_id.value, from: from.value, to: to.value, limit: limit.value, position: position.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
}
