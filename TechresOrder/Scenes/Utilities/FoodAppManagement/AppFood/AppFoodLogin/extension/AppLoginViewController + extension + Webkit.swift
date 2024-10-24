//
//  AppLoginViewController + extension + Webkit.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/08/2024.
//

import UIKit
import WebKit
extension AppFoodLoginViewController:WKNavigationDelegate {
    
    func loadWebkit(){
        webView.navigationDelegate = self
        if let url = URL(string: "https://partner.business.accounts.shopee.vn/") {
           self.webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
       }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        dLog("pham khaanh huy1")

        // get all cookies
        webView.getCookies() { data in
            dLog(data)
            if let shoppeFoodTokenData = data["__shopee_partner_website_x_token_live"] as? [String:Any]{
                
                let decodedJWT = self.decodeJWT(shoppeFoodTokenData["Value"] as? String ?? "")
                
                if let header = decodedJWT.header {
                    print("Header: \(header)")
                }
                
                if let payload = decodedJWT.payload {
                    print("Payload: \(payload)")
                    self.getUserInforOfShopee(token: payload["token"] as? String ?? "")
                    
                }
                
                
            }
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        dLog("pham khaanh huy2")
//        showLoadingIndicator(true)
        
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        dLog("pham khaanh huy3")
//        showLoadingIndicator(false)
    }
    
    func decodeJWT(_ token: String) -> (header: [String: Any]?, payload: [String: Any]?) {
        let segments = token.split(separator: ".")
        guard segments.count == 3 else {
            print("Invalid JWT token")
            return (nil, nil)
        }
        
        let headerData = base64UrlDecode(String(segments[0]))
        let payloadData = base64UrlDecode(String(segments[1]))
        
        var header: [String: Any]?
        var payload: [String: Any]?
        
        if let headerData = headerData {
            header = try? JSONSerialization.jsonObject(with: headerData, options: []) as? [String: Any]
        }
        
        if let payloadData = payloadData {
            payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any]
        }
        
        return (header, payload)
    }

    
    
    func base64UrlDecode(_ base64Url: String) -> Data? {
        var base64 = base64Url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let padding = 4 - base64.count % 4
        if padding < 4 {
            base64.append(contentsOf: repeatElement("=", count: padding))
        }
        
        return Data(base64Encoded: base64)
    }
}

