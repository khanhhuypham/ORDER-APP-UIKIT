//
//  SocketIOManager.swift
//  Techres-Sale
//
//  Created by kelvin on 4/19/19.
//  Copyright © 2019 vn.printstudio.res.employee. All rights reserved.
//

import UIKit
import SocketIO
import ObjectMapper

class SocketIOManager: NSObject {
    //singleton
    private static var shareSocketRealtime: SocketIOManager = {
        let socketManager = SocketIOManager()
        return socketManager
    }()
    
    class func shared() -> SocketIOManager {
           return shareSocketRealtime
    }
    
    
    var managerRealTime: SocketManager?
    
    var socketRealTime:SocketIOClient?
    
    private var managerRealTimeOfLogin:SocketManager?

    var socketRealTimeOfLogin:SocketIOClient?
    
    
    override init() {
        super.init()
        
        if let url = URL(string: ManageCacheObject.isLogin() ? ManageCacheObject.getConfig().realtime_domain : APIEndPoint.REALTIME_SERVER) {
            
            let auth = ["token": String(format: "Bearer %@", ManageCacheObject.getCurrentUser().access_token)]
//               dLog(auth)
            self.managerRealTime = SocketManager(socketURL: url, config: [.log(false), .compress, .reconnects(true), .extraHeaders(auth)])
            
            let namespace = "/"
           
                
            self.socketRealTime = self.managerRealTime!.socket(forNamespace: namespace)
            self.managerRealTime?.connectSocket(self.socketRealTime!, withPayload: auth)
            
            self.socketRealTime?.connect()
            
        }
        
    }
    
    
    func initSocketInstanceOfLogin() {
        if let url = URL(string: ManageCacheObject.isLogin() ? ManageCacheObject.getConfig().socket_conect_login : "https://realtime.oauth.techres.vn") {
            let auth = ["token": ManageCacheObject.getCurrentUser().jwt_token]
            self.managerRealTimeOfLogin = SocketManager(socketURL: url, config: [.log(false), .compress, .reconnects(true), .extraHeaders(auth)])
            self.socketRealTimeOfLogin = self.managerRealTimeOfLogin!.socket(forNamespace: "/")
            self.managerRealTimeOfLogin?.connectSocket(self.socketRealTimeOfLogin!, withPayload: auth)
            self.socketRealTimeOfLogin?.connect()
        }
    }
    
    
    func initSocketInstance(_ namespace: String) {
        if let url = URL(string: ManageCacheObject.isLogin() ? ManageCacheObject.getConfig().realtime_domain : APIEndPoint.REALTIME_SERVER) {
            let auth = ["token": String(format: "Bearer %@", ManageCacheObject.getCurrentUser().access_token)]
            let cofig:SocketIOClientConfiguration = [
                .log(true),
                .compress,
                .reconnects(true),
                .extraHeaders(auth),
                .forceWebsockets(true),
            ]
            
            self.managerRealTime = SocketManager(socketURL: url, config: cofig)
//            let namespace = "/"
            self.socketRealTime =  self.managerRealTime!.socket(forNamespace: namespace)
            self.managerRealTime?.connectSocket(self.socketRealTime!, withPayload: auth)
            self.socketRealTime?.connect()
        }
        
    }
    
    func establishConnection() {
      
        socketRealTime?.on("connect") {data, ack in
            dLog("connected==============: \(data.description)")
        }
        self.socketRealTime?.connect()

    }
    
    func closeConnection() {
        self.socketRealTime!.disconnect()
        socketRealTime?.on("disconnect") {data, ack in
            dLog("disconnect: \(data.description)")
            
        }
    }
    

 
}


class SocketChatIOManager: NSObject {
    
    static let shared: SocketChatIOManager = {
        let socketManager = SocketChatIOManager()
        return socketManager
    }()

//    class func chatSharedInstance() -> SocketIOManager {
//       return share
//    }
        
    var managerChat: SocketManager?
    var socketChat: SocketIOClient?
        
    override init() {
        super.init()
        if let url = URL(string:  APIEndPoint.REALTIME_CHAT_SERVER) {
            dLog(String(format: "==>> LOGIN SOCKET SERVER: %@", ManageCacheObject.getCurrentUser().access_token))
            let config = [
                .log(true),
                .connectParams([
                    "device" : Utils.getUDID()
                ]),
                .compress,
                .reconnects(false),
                .extraHeaders([

                    "Authorization": ManageCacheObject.getCurrentUser().access_token,
                    "Accept": "application/json"
                ])
            ] as SocketIOClientConfiguration
            self.managerChat = SocketManager(socketURL: url, config: config)
            self.socketChat = managerChat?.defaultSocket
        }
    }
    
    func initSocketChatInstance() {
        if let url = URL(string: APIEndPoint.REALTIME_CHAT_SERVER) {
            dLog(String(format: "==>> LOGIN SOCKET SERVER INIT INSTANCE: %@", ManageCacheObject.getCurrentUser().access_token))
            let config = [
                .log(true),
                .connectParams([
                    "device" : Utils.getUDID()
                ]),
                .compress,
                .reconnects(false),
                .extraHeaders([
                    "Authorization": ManageCacheObject.getCurrentUser().access_token,
                    "Accept": "application/json"
                ])
            ] as SocketIOClientConfiguration
            self.managerChat = SocketManager(socketURL: url, config: config)
            self.socketChat = managerChat?.defaultSocket
        }
    }
        
    func establishConnection() {
        socketChat?.on("connect") { data, ack in
            dLog("Connected: \(data.description)")
        }
        self.socketChat?.connect()
    }

    func closeConnection() {
        self.socketChat!.disconnect()
        socketChat?.on("disconnect") { data, ack in
            dLog("Disconnected: \(data.description)")
        }
    }
 
}

