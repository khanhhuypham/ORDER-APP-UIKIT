//
//  PravicyPolicyViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit
import WebKit

class WebViewViewController: BaseViewController {
    var viewModel = WebViewViewModel()
    var router = WebViewRouter()
    var header = ""
    var urlWebsite = ""
    @IBOutlet weak var view_webview: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var webView: WKWebView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        lbl_title.text = header
        if let url = URL (string: self.urlWebsite) {
           self.webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
      
    }


    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }

}

