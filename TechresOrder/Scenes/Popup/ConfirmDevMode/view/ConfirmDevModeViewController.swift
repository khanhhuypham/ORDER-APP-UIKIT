//
//  ConfirmDevModeViewController.swift
//  TECHRES-ORDER
//
//  Created by Nguyen Thanh Vinh on 20/01/2024.
//

import UIKit

class ConfirmDevModeViewController: UIViewController {
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var constraint_y_root_view: NSLayoutConstraint!
    @IBOutlet weak var text_field_pass_word: UITextField!
    
    var delegate: DevModeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
                tapGesture.cancelsTouchesInView = false
                window.addGestureRecognizer(tapGesture)
            }
        }
            
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            constraint_y_root_view.constant = 0
        } else {
            constraint_y_root_view.constant = -root_view.frame.height/2
        }
    }
    
    @objc func handleTapOutSide(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: self.root_view)
        if !root_view.bounds.contains(tapLocation) {
            // Handle touch outside of the view
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func actionBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        delegate?.callbackSetUpDevMode(pass_word: text_field_pass_word.text ?? "")
        dismiss(animated: true, completion: nil)
    }
}
