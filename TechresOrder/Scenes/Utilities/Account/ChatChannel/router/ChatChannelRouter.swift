//
//  ChatChannelRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/05/2024.
//

import UIKit

class ChatChannelRouter: NSObject {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = ChatChannelViewController(nibName: "ChatChannelViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToChatInfoViewController(conversation_id: String){
        let vc = InfoChatRouter().viewController as! InfoChatViewController
        vc.conversation_id = conversation_id
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToWebLinkViewController(title:String,link:String){
        let vc = WebLinkViewController()
        vc.link = link
        vc.title_header = title
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
}
