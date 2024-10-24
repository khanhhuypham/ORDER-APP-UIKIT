//
//  LinkStoreViewModel.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 03/01/2024.
//  Copyright © 2024 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class LinkStoreViewModel: NSObject {
    
    private(set) weak var view: LinkStoreViewController?
    private var router: LinkStoreRouter?
    
    public var dataArray : BehaviorRelay<[MediaStore]> = BehaviorRelay(value: [])
    
    // List Media
    public var type : BehaviorRelay<Int> = BehaviorRelay(value: 4) // Tin nhắn TechRes
    public var media_type : BehaviorRelay<String> = BehaviorRelay(value: "\(TYPE_LINK)")
    public var object_id : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var from : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var limit : BehaviorRelay<Int> = BehaviorRelay(value: 20)
    public var position : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func bind(view: LinkStoreViewController, router: LinkStoreRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func makeToWebViewController(title_header: String, link_website: String){
        router?.navigateToWebViewController(title_header: title_header, link_website: link_website)
    }
}

extension LinkStoreViewModel {
    func getListMedia() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getListMedia(type: type.value, media_type: media_type.value, object_id: object_id.value, from: from.value, to: to.value, limit: limit.value, position: position.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
}
