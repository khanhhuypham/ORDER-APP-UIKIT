//
//  TermOfUseViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit
import WebKit

class TermOfUseViewController: BaseViewController {
    var viewModel = TermOfUseViewModel()
    var router = TermOfUseRouter()
    
    @IBOutlet weak var view_webview: UIView!
    
    var urlWebsite = "https://techres.vn/quy-dinh-su-dung/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        loadWebview()
    }

    func backTap() {
        viewModel.makePopViewController()
    }
    
    func loadWebview(){
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view_webview.addSubview(webView)
        if let url = URL(string: self.urlWebsite){
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
        
      
    }
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }

  
}

