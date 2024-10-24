//
//  ChatChannel + extension + socket.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 15/05/2024.
//

import UIKit
import ObjectMapper
extension ChatChannelViewController {
    
    func setupSocket(consersationID:String){
        receiveSocketMessage()
        joinConversationRoom(consersationID:consersationID)
    }
    
   private func joinConversationRoom(consersationID:String) {
        var connection = JoinRoom()
       connection.conversation_id = viewModel.conversationId.value
        if let socket = SocketChatIOManager.shared.socketChat {
            socket.emit(CHAT_SOCKET_KEY.JOIN_ROOM, connection.toJSON())
        } else {
            dLog("<===== Socket config Error =====>")
        }
    }
    
    func leaveConversationRoom() {
        var connection = JoinRoom()
        connection.conversation_id = viewModel.conversationId.value
        if let socket = SocketChatIOManager.shared.socketChat {
            socket.emit(CHAT_SOCKET_KEY.LEAVE_ROOM, connection.toJSON())
        } else {
            dLog("<===== Socket config Error =====>")
        }
    }
    
    private func receiveSocketMessage(){
        //MARK: Listen Finish Message
        SocketChatIOManager.shared.socketChat!.on(CHAT_SOCKET_KEY.LISTEN_FINISH_SUPPORT) { data, ack in
            self.leaveConversationRoom()
            self.viewModel.makePopViewController()
        }
        //MARK: Listen Join Room
        SocketChatIOManager.shared.socketChat!.on(CHAT_SOCKET_KEY.LISTEN_JOIN_ROOM) { data, ack in
            dLog("Join room successfully: \(data)")
        }
        //MARK: Listen Message Text
        SocketChatIOManager.shared.socketChat!.on(CHAT_SOCKET_KEY.LISTEN_MESSAGE_TEXT) { data, ack in
            if let res = Mapper<MessageResponse>().map(JSONObject: data[0]) {
                self.handleMessageLocal(msg: res)
            }
        }
        // Listen Message Image
        SocketChatIOManager.shared.socketChat!.on(CHAT_SOCKET_KEY.LISTEN_MESSAGE_IMAGE) { data, ack in
            if let res = Mapper<MessageResponse>().map(JSONObject: data[0]) {
                self.handleMessageLocal(msg: res)
            }
        }
        //MARK: Listen Message Video
        SocketChatIOManager.shared.socketChat!.on(CHAT_SOCKET_KEY.LISTEN_MESSAGE_VIDEO) { data, ack in
            if let res = Mapper<MessageResponse>().map(JSONObject: data[0]) {
                self.handleMessageLocal(msg: res)
            }
        }
        //MARK: Listen Message Sticker
        SocketChatIOManager.shared.socketChat!.on(CHAT_SOCKET_KEY.LISTEN_MESSAGE_STICKER) { data, ack in
            dLog(data)
        }
        //MARK: Listen Message File
        SocketChatIOManager.shared.socketChat!.on(CHAT_SOCKET_KEY.LISTEN_MESSAGE_FILE) { data, ack in
            if let res = Mapper<MessageResponse>().map(JSONObject: data[0]) {
                self.handleMessageLocal(msg: res)
            }
        }
        //MARK: Listen Message Audio
        SocketChatIOManager.shared.socketChat!.on(CHAT_SOCKET_KEY.LISTEN_MESSAGE_AUDIO) { data, ack in
            dLog(data)
        }
        //MARK: Listen Message Typing On
        SocketChatIOManager.shared.socketChat!.on(CHAT_SOCKET_KEY.LISTEN_TYPING_ON_MESSAGE) { data, ack in
            dLog(data)
        }
        //MARK: Listen Message Typing Off
        SocketChatIOManager.shared.socketChat!.on(CHAT_SOCKET_KEY.LISTEN_TYPING_OFF_MESSAGE) { data, ack in
            dLog(data)
        }
    }
    
    
    func sendMessageText() {
        var message = MessageEmit()
//        message.thumb = thumbnailChat
        message.key_error = "\(NSDate().timeIntervalSince1970)"
        message.message_reply_id = message_reply_id
        message.tag = arrayTag
        
        var textMessage = textField_input_msg.text ?? ""
        
        for item in arrayTag {
            if item.user_id == ALL {
                textMessage = textMessage.replacingOccurrences(of: "@All", with: item.key)
            } else {
                textMessage = textMessage.replacingOccurrences(of: "@" + item.user_name, with: item.key)
            }
        }
        
        message.message = textMessage
        
        if message_reply_id.isEmpty {
            if let socket = SocketChatIOManager.shared.socketChat{
                socket.emit(CHAT_SOCKET_KEY.MESSAGE_TEXT, message.toJSON())
            }
            message.event_emit_local = CHAT_SOCKET_KEY.MESSAGE_TEXT
        } else {
            if let socket = SocketChatIOManager.shared.socketChat{
                socket.emit(CHAT_SOCKET_KEY.MESSAGE_REPLY, message.toJSON())
            }
            message.event_emit_local = CHAT_SOCKET_KEY.MESSAGE_REPLY
        }
//        ManageCacheObject.setMessageReSent(message)
        sendMessageLocal(messageType: message_reply_id.isEmpty ? messageType.text : messageType.reply,
                         message: message.message,
                         tags: message.tag,
                         thumb: message.thumb,
                         links: message.link
        )
        
        
    
        
        textField_input_msg.text = ""
//        message_reply_id = ""
//        arrayTag.removeAll()
//        arrayNameUserTag.removeAll()
//        thumbnailChat = ThumbnailChat()
        btn_more_option.isHidden = false
        btn_audio.isHidden = false
        btn_choose_media.isHidden = false
        btn_send_msg.isHidden = true
    
    }
    
    
    func handleMessageLocal(msg: MessageResponse) {
        if viewModel.conversationId.value == msg.conversation.conversation_id {
            var list = viewModel.messageList.value
            if (msg.user.user_id == ManageCacheObject.getCurrentUser().id) {
                for ( i,item ) in list.enumerated() {
                    if item.status_message == .active {
                        list[i].status_message = .deactive
                        list[i].message_id = msg.message_id
                        list[i].user = msg.user
                        list[i].message_object_interacted.message_id = msg.message_object_interacted.message_id
                        list[i].sticker.sticker_id = msg.sticker.sticker_id
                        list[i].created_at = msg.created_at
                    }
                }
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
            } else {
                list.insert(msg, at: 0)
            }
            viewModel.messageList.accept(list)
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
        }
    }
    
    
    func sendMessageLocal(
        messageType:messageType,
        message:String? = nil,
        tags:[TagChatRequest]? = nil,
        thumb:ThumbnailChat? = nil,
        links:[String]? = nil,
        sticker:String? = nil,
        medias:[Media]? = nil,
        size_audio: Int = 0
    ){
        var list = viewModel.messageList.value
        
        var newMessage = MessageResponse()
        
        
        
        if let message = message{
            newMessage.message = message
        }
        
        
        if let tags = tags{
            var newTags:[TagChat] = []
            var tag = TagChat()
            for item in tags {
                tag.key = item.key
                tag.user.user_id = item.user_id
                tag.user.name = item.user_name
                newTags.append(tag)
            }
            newMessage.tag = newTags
        }
        
        if let thumb = thumb, let links = links{
            dLog(thumb)
            dLog(links)
        }
        
        
        if let medias = medias{
            var mediaArray:[MediaChat] = []
           
            for media in medias {
                var mediaChat = MediaChat()
                mediaChat.url_local = media.url?.absoluteString ?? ""
                mediaChat.original.name = media.name ?? ""
                mediaChat.original.size = messageType == .file ? (media.size ?? 0) : size_audio
                mediaArray.append(mediaChat)
            }
            newMessage.media = mediaArray
        }
     
    
        if let sticker = sticker{
            newMessage.sticker.url_local = sticker
        }
        
      
        newMessage.message_type = messageType
        newMessage.user.user_id = ManageCacheObject.getCurrentUser().id
        newMessage.status_message = .active
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        inputDateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Assuming input is in GMT
        if let date = inputDateFormatter.date(from: TimeUtils.getFullCurrentDate()) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            outputDateFormatter.timeZone = TimeZone(secondsFromGMT: -7 * 3600) // -7 hours
            newMessage.created_at = outputDateFormatter.string(from: date)
        }
    
        list.insert(newMessage, at: 0)
        
        viewModel.messageList.accept(list)
    }
}
