//
//  InfoChatViewController.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 08/11/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import Kingfisher
import Photos
import HXPhotoPicker
import RxCocoa
import RxSwift

class InfoChatViewController: BaseViewController {

    var viewModel = InfoChatViewModel()
    var router = InfoChatRouter()
    
    @IBOutlet weak var lbl_title_view: UILabel!
    @IBOutlet weak var lbl_name_group: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var view_image_media_one: UIView!
    @IBOutlet weak var image_icon_play_media_one: UIImageView!
    @IBOutlet weak var image_media_one: UIImageView!
    @IBOutlet weak var view_image_media_two: UIView!
    @IBOutlet weak var image_icon_play_media_two: UIImageView!
    @IBOutlet weak var image_media_two: UIImageView!
    @IBOutlet weak var view_image_media_three: UIView!
    @IBOutlet weak var image_icon_play_media_three: UIImageView!
    @IBOutlet weak var image_media_three: UIImageView!
    @IBOutlet weak var view_image_media_four: UIView!
    @IBOutlet weak var image_icon_play_media_four: UIImageView!
    @IBOutlet weak var image_media_four: UIImageView!
    @IBOutlet weak var view_no_media: UIView!
    
    var conversation_id = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        viewModel.conversation_id.accept(conversation_id)
        viewModel.object_id.accept(conversation_id)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListMedia()
    }

    
    @IBAction func actionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionToMediaStore(_ sender: Any) {
        viewModel.makeToMediaStoreViewController()
    }
    
}
