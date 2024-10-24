//
//  MediaStoreViewController.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 29/12/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxCocoa

class MediaStoreViewController: UIViewController {
    
    @IBOutlet weak var btnImageVideo: UIButton!
    @IBOutlet weak var image_and_video: UIImageView!
    @IBOutlet weak var lbl_image_video: UILabel!
    
    @IBOutlet weak var btnFile: UIButton!
    @IBOutlet weak var image_file: UIImageView!
    @IBOutlet weak var lbl_file: UILabel!
    
    @IBOutlet weak var btnLink: UIButton!
    @IBOutlet weak var image_link: UIImageView!
    @IBOutlet weak var lbl_link: UILabel!
    
    var conversation_id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonBorder(button: btnImageVideo, isSelected: true)
        pushImageVideoStoreViewController()
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionToImageVideo(_ sender: UIButton) {
        configureButtons()
        addButtonBorder(button: sender, isSelected: true)
        pushImageVideoStoreViewController()
        
    }
    
    @IBAction func actionToFile(_ sender: UIButton) {
        configureButtons()
        addButtonBorder(button: sender, isSelected: true)
        pushFileStoreViewController()
    }
    
    @IBAction func actionToLink(_ sender: UIButton) {
        configureButtons()
        addButtonBorder(button: sender, isSelected: true)
        pushLinkStoreViewController()
    }
    
    func pushImageVideoStoreViewController() {
        lbl_image_video.textColor = .systemOrange
        lbl_image_video.font = UIFont(name: "Roboto-Bold", size: 14)
        image_and_video.image = UIImage(named: "image_orange_default")
        
        lbl_file.textColor = ColorUtils.gray_400()
        lbl_file.font = UIFont(name: "Roboto-Regular", size: 14)
        image_file.image = UIImage(named: "icon-document-transparent")
        
        lbl_link.textColor = ColorUtils.gray_400()
        lbl_link.font = UIFont(name: "Roboto-Regular", size: 14)
        image_link.image = UIImage(named: "icon-link-transparent")
        
        let imageVideoStoreViewController = ImageVideoStoreViewController(nibName: "ImageVideoStoreViewController", bundle: Bundle.main)
        imageVideoStoreViewController.conversation_id = conversation_id
        addTopCustomViewController(imageVideoStoreViewController, addTopCustom: 102)
        
        removeChildViewController(FileStoreViewController.self)
        removeChildViewController(LinkStoreViewController.self)
    }
    
    func pushFileStoreViewController() {
        lbl_image_video.textColor = ColorUtils.gray_400()
        lbl_image_video.font = UIFont(name: "Roboto-Regular", size: 14)
        image_and_video.image = UIImage(named: "image 1")
        
        lbl_file.textColor = .systemOrange
        lbl_file.font = UIFont(name: "Roboto-Bold", size: 14)
        image_file.image = UIImage(named: "icon-document-orange-transparent")
        
        lbl_link.textColor = ColorUtils.gray_400()
        lbl_link.font = UIFont(name: "Roboto-Regular", size: 14)
        image_link.image = UIImage(named: "icon-link-transparent")
        
        let fileStoreViewController = FileStoreViewController(nibName: "FileStoreViewController", bundle: Bundle.main)
        fileStoreViewController.conversation_id = conversation_id
        addTopCustomViewController(fileStoreViewController, addTopCustom: 102)
        
        removeChildViewController(ImageVideoStoreViewController.self)
        removeChildViewController(LinkStoreViewController.self)
    }
    
    func pushLinkStoreViewController() {
        lbl_image_video.textColor = ColorUtils.gray_400()
        lbl_image_video.font = UIFont(name: "Roboto-Regular", size: 14)
        image_and_video.image = UIImage(named: "image 1")
        
        lbl_file.textColor = ColorUtils.gray_400()
        lbl_file.font = UIFont(name: "Roboto-Regular", size: 14)
        image_file.image = UIImage(named: "icon-document-transparent")
        
        lbl_link.textColor = .systemOrange
        lbl_link.font = UIFont(name: "Roboto-Bold", size: 14)
        image_link.image = UIImage(named: "icon-link-orange-transparent")
        
        let linkStoreViewController = LinkStoreViewController(nibName: "LinkStoreViewController", bundle: Bundle.main)
        linkStoreViewController.conversation_id = conversation_id
        addTopCustomViewController(linkStoreViewController, addTopCustom: 102)
        
        removeChildViewController(ImageVideoStoreViewController.self)
        removeChildViewController(FileStoreViewController.self)
    }
    
    private func addButtonBorder(button: UIButton, isSelected: Bool) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: button.frame.size.height - 2, width: button.frame.size.width, height: 2)
        
        if isSelected {
            bottomBorder.backgroundColor = UIColor.systemOrange.cgColor
        } else {
            bottomBorder.backgroundColor = UIColor.white.cgColor
        }
        
        button.layer.addSublayer(bottomBorder)
    }
    
    private func configureButtons() {
        addButtonBorder(button: btnImageVideo, isSelected: false)
        addButtonBorder(button: btnFile, isSelected: false)
        addButtonBorder(button: btnLink, isSelected: false)
    }
    
    private func addTopCustomViewController(_ child: UIViewController, addTopCustom: Int) {
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(addTopCustom)),
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        child.didMove(toParent: self)
    }
    
    private func removeChildViewController<T: UIViewController>(_ childType: T.Type) {
        if let viewControllerToRemove = self.children.first(where: { $0 is T }) {
            viewControllerToRemove.willMove(toParent: nil)
            viewControllerToRemove.view.removeFromSuperview()
            viewControllerToRemove.removeFromParent()
        }
    }
}
