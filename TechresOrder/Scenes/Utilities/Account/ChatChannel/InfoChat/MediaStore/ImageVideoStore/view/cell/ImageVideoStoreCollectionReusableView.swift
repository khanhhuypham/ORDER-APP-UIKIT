//
//  ImageVideoStoreCollectionReusableView.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 25/3/24.
//  Copyright © 2024 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class ImageVideoStoreCollectionReusableView: UICollectionReusableView {
    public var lbl_time : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14) ?? .systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#28282B")
        return label
    }()
    
    func configure(){
        backgroundColor = .white
        addSubview(lbl_time)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lbl_time.frame = CGRect(x: 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
}
