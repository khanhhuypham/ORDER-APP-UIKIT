//
//  ChatChannel + extension + api.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 10/05/2024.
//

import UIKit
import RxSwift
import ObjectMapper
import JonAlert
import RxCocoa




extension ChatChannelViewController {
    func getMessageList(){
        viewModel.getmessageList().subscribe(onNext: {(response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let messageList = Mapper<MessageResponse>().mapArray(JSONObject: response.data){
                    
                    if self.isResetData {
                        self.viewModel.messageList.accept([])
                        self.isResetData = false
                    }
                    
                    var newData = self.viewModel.messageList.value
                    if self.viewModel.conversationArrow.value == 2 {
                        newData.insert(contentsOf: messageList, at: 0)
                        self.isFirstPage = messageList.count == 0
                    } else {
                        newData.append(contentsOf: messageList)
                        self.isLastPage = messageList.count == 0
                    }
                    self.viewModel.messageList.accept(newData)
         
                }
                
                self.view_loading_more.isHidden = true
                self.loading_more_message.stopAnimating()
                
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
                dLog(response.message ?? "")
            }
            
        }).disposed(by: rxbag)
    }
    
    
    func createGroupSupport(){
        viewModel.createGroupSupport().subscribe(onNext: {(response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                if let conversation = Mapper<Conversation>().map(JSONObject: response.data){
                    self.viewModel.conversationId.accept(conversation.conversation_id)
                  
                    
                    SocketChatIOManager.shared.initSocketChatInstance()
                    SocketChatIOManager.shared.socketChat?.on("connect") { data, ack in
                        self.setupSocket(consersationID: conversation.conversation_id)
                    }
                    SocketChatIOManager.shared.socketChat?.connect()
                    
                    self.getMessageList()
                    
                }
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
            
        }).disposed(by: rxbag)
    }
    
    
    
}
