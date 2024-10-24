//
//  InfoChatViewModel.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 08/11/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class InfoChatViewModel: BaseViewModel {
    
    private(set) weak var view: InfoChatViewController?
    private var router: InfoChatRouter?

    public var conversation_id : BehaviorRelay<String> = BehaviorRelay(value: "")
    // List Media
    public var type : BehaviorRelay<Int> = BehaviorRelay(value: 4) // Tin nhắn TechRes
    public var media_type : BehaviorRelay<String> = BehaviorRelay(value: "\(TYPE_IMAGE), \(TYPE_VIDEO)")
    public var object_id : BehaviorRelay<String> = BehaviorRelay(value: "") // Phụ thuộc vào type (newfeed: user_id, fanpage: fanpage_id, group: group_id, chat: conversation_id)
    public var from : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var limit : BehaviorRelay<Int> = BehaviorRelay(value: 4)
    public var position : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func bind(view: InfoChatViewController, router: InfoChatRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makeToMediaStoreViewController(){
        router?.navigationToMediaStoreViewController(conversation_id: conversation_id.value)
    }
}

extension InfoChatViewModel {
    func getListMedia() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getListMedia(type: type.value, media_type: media_type.value, object_id: object_id.value, from: from.value, to: to.value, limit: limit.value, position: position.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
}
