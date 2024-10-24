//
//  ImageCollectionViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 18/05/2024.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var link:String? = nil {
        didSet{
            image.kf.setImage(with: URL(string: self.link ?? ""), placeholder: UIImage(named: "image_defauft_medium"))
        }
    }

}
