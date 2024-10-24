//
//  ChatChannelViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/05/2024.
//

import UIKit
import UniformTypeIdentifiers
import MobileCoreServices

class ChatChannelViewController: BaseViewController {

    var viewModel = ChatChannelViewModel()
    var router = ChatChannelRouter()
    var message_reply_id = ""
    var arrayTag: [TagChatRequest] = []

    var previewItemURL: URL? = nil

    var heightOfKeyBoard:CGFloat = 0
    var isLastPage:Bool = false
    var isFirstPage:Bool = false
    var isResetData:Bool = false
    

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField_input_msg: UITextField!
    
    @IBOutlet weak var view_loading_more: UIView!
    @IBOutlet weak var loading_more_message: UIActivityIndicatorView!
    @IBOutlet weak var btn_scroll_bottom_table: UIButton!
    
    @IBOutlet weak var btn_audio: UIButton!
    @IBOutlet weak var btn_more_option: UIButton!
    @IBOutlet weak var btn_choose_media: UIButton!
    @IBOutlet weak var btn_send_msg: UIButton!
    @IBOutlet weak var view_option: UIView!
    @IBOutlet weak var constraint_bottom_root_view_chat: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        registerCellAndBindTable()
        createGroupSupport()
        tableView.delegate = self
        
        firstSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
            self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: self.tableView.bounds.size.width - 3)
        }
    }

    
    
    @IBAction func actionback(_ sender: Any) {
        leaveConversationRoom()
        viewModel.makePopViewController()
    }
    
    @IBAction func actionChatInfo(_ sender: Any) {
        viewModel.makeChatInfoViewController()
    }
    
    @IBAction func actionSendMsg(_ sender: Any) {
        sendMessageText()
    }
    
    
    @IBAction func actionShowImageBrowser(_ sender: Any) {
        presentImageBrowserViewController()
    }
    
    
    @IBAction func actionOption(_ sender: Any) {
        btn_more_option.isSelected.toggle()

        if btn_more_option.isSelected {
            
//            constraint_bottom_root_view_chat.constant = heightOfKeyBoard
            UIView.animate(withDuration: 0.3, delay: 0.2, options: [], animations: { [self] in
                self.view.endEditing(true)
                view_option.isHidden = false
                view.layoutIfNeeded()
            })
          
            
        } else {
          
            UIView.animate(withDuration: 0.4) { [self] in
//                constraint_bottom_root_view_chat.constant = 0
                view_option.isHidden = true
                textField_input_msg.becomeFirstResponder()
                view.layoutIfNeeded()
            }
   
        }
    }
    
    
    @IBAction func actionDocument(_ sender: Any) {
        if #available(iOS 14.0, *) {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.content])
            documentPicker.delegate = self
            present(documentPicker, animated: true, completion: nil)
        } else {
            let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeContent as String], in: .import)
            documentPicker.delegate = self
            present(documentPicker, animated: true, completion: nil)
        }
        view_option.isHidden = true
        view.layoutIfNeeded()
        btn_more_option.isSelected = false
    }
    

    
//    @objc func keyboardShow(_ notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
//            
//            
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                let mainWindow = windowScene.windows.first
//                let bottomPadding = mainWindow?.safeAreaInsets.bottom
//                
//                heightOfKeyBoard = keyboardSize.height - (bottomPadding ?? 0)
////                constraint_bottom_root_view_chat.constant = 0
//                btn_more_option.isSelected = false
//                view_option.isHidden = true
//                view.layoutIfNeeded()
//            }
//            
//          
//        }
//    }
//    
//    @objc func keyboardHide(_ notification: NSNotification) {
//        
//    }
    
    
    
    private func firstSetup(){
        btn_send_msg.isHidden = true
        textField_input_msg.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        btn_scroll_bottom_table.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        
        let tapTable: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAllView))
        tapTable.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapTable)
    }
    
    @objc func dismissAllView() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.view_option.isHidden = true
            self.btn_more_option.isSelected = false
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        if textField.text?.count ?? 0 > 0{
            btn_more_option.isHidden = true
            btn_choose_media.isHidden = true
            btn_send_msg.isHidden = false
        }else{
            btn_more_option.isHidden = false
            btn_choose_media.isHidden = false
            btn_send_msg.isHidden = true
        }
    }
}

