//
//  UIImageView+Extension.swift
//  ALOLINE
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 11/10/2022.
//  Copyright © 2022 Android developer. All rights reserved.
//


import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setKingfisherImageView(image: String?, placeholder: String = "") {
        var path = ""
        if let url = image {
            path = url
        }
                
        if placeholder.isEmpty {
            self.kf.indicatorType = .activity
            let indicator = self.kf.indicator?.view as? UIActivityIndicatorView
            //indicator?.style = .whiteLarge
            indicator?.color = ColorUtils.orange_brand_900()
        }
        
        self.kf.setImage(
            with: URL(string: path),
            placeholder: UIImage(named: placeholder),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}


extension Double {
   

    var toString:String{
        let number = NumberFormatter()
        number.usesGroupingSeparator = true
        number.numberStyle = .decimal
        number.groupingSeparator = ","
        number.decimalSeparator = "."
        number.groupingSize = 3
        number.maximumFractionDigits = 2
        return number.string(from: NSNumber(value: self)) ?? "0"
    }
    
}


extension Float {
    
    
    var toString:String{
        let number = NumberFormatter()
        number.usesGroupingSeparator = true
        number.groupingSeparator = ","
        number.groupingSize = 3
        
        return number.string(from: NSNumber(value: self)) ?? "0"
    }
}


extension Int {
    
    var toString:String{
        let number = NumberFormatter()
        number.usesGroupingSeparator = true
        number.groupingSeparator = ","
        number.groupingSize = 3
        return number.string(from: NSNumber(value: self)) ?? "0"
    }
    
}
