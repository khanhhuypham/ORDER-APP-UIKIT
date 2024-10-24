//
//  ProjectIDManager.swift
//  aloline-phamkhanhhuy
//
//  Created by Pham Khanh Huy on 16/02/2024.
//

import UIKit
import Moya

var environmentMode = EnvironmentMode.develop

enum EnvironmentMode {
    
    case develop
    
    case staging
    
    case production
    
    var value: Int {
        switch self {
            case .develop:
                return 0
            case .staging:
                return 1
            case .production:
                return 2
        }
    }
    
    var baseUrl: String {
        switch self {
            
            case .develop:
                return "https://beta.api.gateway.overate-vntech.com"
            
            case .staging:
                return "https://staging.api.gateway.overate-vntech.com"
            
            case .production:
                return "https://api.gateway.overate-vntech.com"
        }
    }
    
    
    
    
    var realTimeUrl: String {
        switch self {
            case .develop:
                return "https://beta.realtime.order.techres.vn"
            case .staging:
                return "http://172.16.10.144:1483"
            case .production:
                return "https://realtime.order.techres.vn"
        }
    }
    
    
    var realTimeChatUrl: String {
        switch self {
            case .develop:
                return "https://beta.realtime.chat.techres.vn"
            case .staging:
                return "https://staging.realtime.chat.techres.vn"
            case .production:
                return "https://realtime.chat.techres.vn"
        }
    }
    
    
    
    
    var PROJECT_OAUTH: Int {
        switch self {
            case .develop:
                return 8003
            case .staging:
                return 8003
            case .production:
                return 8003
        }
    }
    
    var PROJECT_ID_ORDER_SMALL: Int {
        return 8004
    }
    
    var PROJECT_ID_ORDER: Int {
        return 8005
    }
    
    var PROJECT_ID_DASHBOARD: Int {
        return 8011
    }
    
    var PROJECT_ID_BUSINESS_REPORT: Int {
        return 1453
    }
    
    var PROJECT_ID_FINANCE_REPORT: Int {
        return 1454
    }
    
    
    var PROJECT_UPLOAD_SERVICE: Int {
        return 9007
    }
    
    var PROJECT_HEALTH_CHECK_SERVICE: Int {
        return 1408
    }
    
    var PROJECT_ID_LOG: Int {
        return 9018
    }
    
    var PROJECT_ID_VERSION_APP: Int {
        return 8001
    }
    
    var PROJECT_ID_FOR_PRINT_ITEM: Int {
        return 1407
    }
    
    var PROJECT_ID_FOR_MEESSAGE_SERVICE: Int { 9025}
    
    var PROJECT_ID_FOR_CONVERSATION_SERVICE: Int { 9024}
    
    
    var PROJECT_ID_FOR_APP_FOOD: Int { 1432}
}


enum ProjectID:Int {
     
    case PROJECT_OAUTH
    
    case PROJECT_ID_ORDER_SMALL
    
    case PROJECT_ID_ORDER
    
    case PROJECT_ID_DASHBOARD
    
    case PROJECT_ID_BUSINESS_REPORT
    
    case PROJECT_ID_FINANCE_REPORT
    
    case PROJECT_UPLOAD_SERVICE
    
    case PROJECT_HEALTH_CHECK_SERVICE
    
    case PROJECT_ID_LOG
    
    case PROJECT_ID_VERSION_APP
    
    case PROJECT_ID_FOR_PRINT_ITEM
    
    case PROJECT_ID_FOR_MEESSAGE_SERVICE
    
    
    case PROJECT_ID_FOR_CONVERSATION_SERVICE
    
    case PROJECT_ID_FOR_APP_FOOD
    
    var value:Int{
        switch self {
            case .PROJECT_OAUTH:
                return environmentMode.PROJECT_OAUTH
            
            case .PROJECT_ID_ORDER_SMALL:
                return environmentMode.PROJECT_ID_ORDER_SMALL
          
            case .PROJECT_ID_ORDER:
                return environmentMode.PROJECT_ID_ORDER
            
            
            case .PROJECT_ID_DASHBOARD:
                return environmentMode.PROJECT_ID_DASHBOARD
            
            case .PROJECT_ID_BUSINESS_REPORT:
                return environmentMode.PROJECT_ID_BUSINESS_REPORT
            
            case .PROJECT_ID_FINANCE_REPORT:
                return environmentMode.PROJECT_ID_FINANCE_REPORT
            
            case .PROJECT_UPLOAD_SERVICE:
                return environmentMode.PROJECT_UPLOAD_SERVICE
            
            case .PROJECT_HEALTH_CHECK_SERVICE:
                return environmentMode.PROJECT_HEALTH_CHECK_SERVICE
            
            case .PROJECT_ID_LOG:
                return environmentMode.PROJECT_ID_LOG
            
            case .PROJECT_ID_VERSION_APP:
                return environmentMode.PROJECT_ID_VERSION_APP
            
            case .PROJECT_ID_FOR_PRINT_ITEM:
                return environmentMode.PROJECT_ID_FOR_PRINT_ITEM
            
            case .PROJECT_ID_FOR_MEESSAGE_SERVICE:
                return environmentMode.PROJECT_ID_FOR_MEESSAGE_SERVICE
            
            case .PROJECT_ID_FOR_CONVERSATION_SERVICE:
                return environmentMode.PROJECT_ID_FOR_CONVERSATION_SERVICE
            
            case  .PROJECT_ID_FOR_APP_FOOD:
       
                return environmentMode.PROJECT_ID_FOR_APP_FOOD
        
        }
    }
}

enum Method:Int {
    case GET
    case POST
    case PUT
    
    var value:Int{
        switch self {
            case .GET:
                return 0
            
            case .POST:
                return 1
          
            case .PUT:
                return 1
          
        }
    }
}







