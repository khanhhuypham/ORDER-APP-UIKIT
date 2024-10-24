//
//  WebLinkViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/05/2024.
//

import UIKit
import WebKit
class WebLinkViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var title_header = "CHƯƠNG TRÌNH KHUYẾN MÃI"
    var link = "https://123-zo.vn/intro-hau.html"
    @IBOutlet weak var lbl_title_header: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
            self.spinner.startAnimating()
        }
        webView.navigationDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbl_title_header.text = title_header
    }
    
    // Implement the WKNavigationDelegate method to check for load completion.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        dLog("Web page loaded successfully.")
        self.spinner.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        dLog("Failed to load web page: \(error.localizedDescription)")
        self.spinner.stopAnimating()
    }
   
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
