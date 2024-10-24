//
//  ItemImageVideoStoreCollectionViewCell.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 29/12/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa

class ItemImageVideoStoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image_media: UIImageView!
    @IBOutlet weak var icon_play_video: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image_media.image = nil
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        image_media.round(with: .both, radius: 8)
    }

    var data: MediaStore? {
        didSet {
            let media = data?.media.type == TYPE_IMAGE ? data?.media.original.url ?? "" : data?.media.thumb.url ?? ""
            image_media.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: media)),
                                    placeholder: UIImage(named: "image_defauft_medium"))
            icon_play_video.isHidden = data?.media.type == TYPE_IMAGE
        }
    }
}
