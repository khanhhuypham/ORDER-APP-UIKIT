//
//  DialogRegisterAccountViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2023.
//

import UIKit

class DialogRegisterAccountViewController: UIViewController {

    @IBOutlet weak var main_view: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGesture.cancelsTouchesInView = false
        UIApplication.shared.windows.first?.addGestureRecognizer(tapGesture)

    }

    
    
    @IBAction func actionRouteToZalo(_ sender: Any) {
        openLink(url: "https://zalo.me/0925123123")
        
    }
    
    @IBAction func actionRouteToFaceBook(_ sender: Any) {
        openLink(url: "https://m.me/techres.order")
    }
    
    @IBAction func actionCallHotLine(_ sender: Any) {
  
        openLink(url: "tel://0941695140")
    }
    
    @objc private func handleTapOutSide(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: main_view)
        if !main_view.bounds.contains(tapLocation) {
               // Handle touch outside of the view
               dismiss(animated: true, completion: nil)
           }
    }
   
    @IBAction func actionSkip(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    func openLink(url:String) {
        if let url = URL(string: url),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    print("successfully route to ", url)
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
    }
    
}
