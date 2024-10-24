//
//  ChatChannelViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/05/2024.
//

import UIKit
import RxSwift
import RxRelay
import Moya

class ChatChannelViewModel: BaseViewModel {
    private(set) weak var view: ChatChannelViewController?
    private var router: ChatChannelRouter?
    
    var conversationId:BehaviorRelay<String> = BehaviorRelay(value: "")
    var conversationArrow:BehaviorRelay<Int> = BehaviorRelay(value: 1)
    var conversationPosition:BehaviorRelay<String> = BehaviorRelay(value: "")
    var messageList = BehaviorRelay<[MessageResponse]>(value: [])
    

    
    func bind(view: ChatChannelViewController, router: ChatChannelRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    func makeWebLinkViewController(title:String,link:String){
        router?.navigateToWebLinkViewController(title:title,link: link)
    }
    
    func makeChatInfoViewController(){
        router?.navigateToChatInfoViewController(conversation_id: conversationId.value)
    }
    
}

extension ChatChannelViewModel {
    
    
    
    
    func createGroupSupport() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postCreateGroupSuppport)
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    
    
    
    func getmessageList() -> Observable<APIResponse>{
        return appServiceProvider.rx.request(.getMessageList(
            conversation_id: conversationId.value,
            arrow: conversationArrow.value,
            limit: 20,
            position: conversationPosition.value
        ))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    
    func getGenerateFile(medias:[Media]) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.generateFileNameResource(medias:medias))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
}
