//
//  UIColorExtension.swift
//
//
//
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignColorableLabel: UIColor {
}

extension UIColor {
   
    class func ORGANE () -> UIColor{
        return UIColor(
            red: 244.0 / 255.0,
            green: 122.0 / 255.0,
            blue: 32.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    class func COLOR_BG () ->UIColor{
        return UIColor(
            red: 238.0 / 255.0,
            green: 238.0 / 255.0,
            blue: 238.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    class func COLOR_BLUE () ->UIColor{
        return UIColor(
            red: 63.0 / 255.0,
            green: 138.0 / 255.0,
            blue: 200.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    class func COLOR_BG_BUTTON_GREEN () ->UIColor{
        return UIColor(
            red: 57.0 / 255.0,
            green: 174.0 / 255.0,
            blue: 74.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    class func COLOR_BG_TABLEVIEW_ACCOUNT () ->UIColor{
        return UIColor(
            red: 224.0 / 255.0,
            green: 224.0 / 255.0,
            blue: 224.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    class func COLOR_BG_BORDER () ->UIColor{
        return UIColor(
            red: 240.0 / 255.0,
            green: 240.0 / 255.0,
            blue: 240.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func COLOR_BORDER_CATE_STICKER () ->UIColor{
        return UIColor(
            red: 116.0 / 255.0,
            green: 116.0 / 255.0,
            blue: 116.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    class func COLOR_BG_HEADER () ->UIColor{
        return UIColor(
//            red: 219 / 255.0,
//            green: 50 / 255.0,
//            blue: 70 / 255.0,
//            alpha: CGFloat(1.0)
            red: 0 / 255.0,
            green: 162 / 255.0,
            blue: 51 / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    class func dark_blue () ->UIColor{
        return UIColor(
            red: 54.0 / 255.0,
            green: 125.0 / 255.0,
            blue: 173.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func line_gray () ->UIColor{
        return UIColor(
            red: 211.0 / 255.0,
            green: 211.0 / 255.0,
            blue: 211.0 / 255.0,
            alpha: CGFloat(0.8)
        )
    }
    
    class func bg_Edit () ->UIColor{
        return UIColor(
            red: 73.0 / 255.0,
            green: 124.0 / 255.0,
            blue: 158.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func bg_Delete () ->UIColor{
        return UIColor(
            red: 222.0 / 255.0,
            green: 75.0 / 255.0,
            blue: 49.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func gray_Light_Text () ->UIColor{
        return UIColor(
            red: 153.0 / 255.0,
            green: 153.0 / 255.0,
            blue: 153.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func gray_Bold_Text () ->UIColor{
        return UIColor(
            red: 65.0 / 255.0,
            green: 65.0 / 255.0,
            blue: 65.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func selected () ->UIColor{
        return UIColor(
            red: 249.0 / 255.0,
            green: 249.0 / 255.0,
            blue: 249.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func selectedBold () ->UIColor{
        return UIColor(
            red: 227.0 / 255.0,
            green: 227.0 / 255.0,
            blue: 227.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    class func gray_Date_Text () ->UIColor{
        return UIColor(
            red: 85.0 / 255.0,
            green: 85.0 / 255.0,
            blue: 85.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func COLOR_BG_MAINS () ->UIColor{
        return UIColor(
            red: 51.0 / 255.0,
            green: 51.0 / 255.0,
            blue: 51.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    class func black_alpha () ->UIColor{
        return UIColor(
            red: 0.0 / 255.0,
            green: 0.0 / 255.0,
            blue: 0.0 / 255.0,
            alpha: CGFloat(0.7)
        )
    }
    
    class func gray_Line () ->UIColor{
        return UIColor(
            red: 211.0 / 255.0,
            green: 211.0 / 255.0,
            blue: 211.0 / 255.0,
            alpha: CGFloat(0.8)
        )
    }
    
    class func gray_Line_new () ->UIColor{
        return UIColor(
            red: 238.0 / 255.0,
            green: 238.0 / 255.0,
            blue: 238.0 / 255.0,
            alpha: CGFloat(0.8)
        )
    }
    
    class func UIColorFromRGB(_ colorCode: String, alpha: Float = 1.0) -> UIColor {
        let scanner = Scanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    class func COLOR_ICON_TOUCH() -> UIColor {
        return UIColor(
            red: 222.0 / 255.0,
            green: 75.0 / 255.0,
            blue: 49.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func COLOR_BLUE_BRIGHT() -> UIColor {
        return UIColor(
            red: 2.0 / 255.0,
            green: 185 / 255.0,
            blue: 252 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    
    class func BLACK_COLOR_ALPHA () ->UIColor{
        return UIColor(
            red:0.0 / 255.0,
            green: 0.0 / 255.0,
            blue: 0.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func COLOR_BG_ITEM_PAGE () ->UIColor{
        return UIColor(
            red:76.0 / 255.0,
            green: 76.0 / 255.0,
            blue: 96.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    class func BLACK_COLOR_TRANSPARENT () ->UIColor{
        return UIColor(
            red:0.0 / 255.0,
            green: 0.0 / 255.0,
            blue: 0.0 / 255.0,
            alpha: CGFloat(0.6)
        )
    }
    
    
    class func COLOR_GRAY() ->UIColor{
        return UIColor(
            red: 211.0 / 255.0,
            green: 211.0 / 255.0,
            blue: 211.0 / 255.0,
            alpha: CGFloat(0.8)
        )
    }
    
    class func COLOR_TABLE_GRAY() ->UIColor{
        return UIColor(
            red: 233.0 / 255.0,
            green: 233.0 / 255.0,
            blue: 233.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func COLOR_BUTTON_GRAY_ALERT() ->UIColor{
        return UIColor(
            red: 137.0 / 255.0,
            green: 137.0 / 255.0,
            blue: 137.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func COLOR_BG_READED_NOTIFI_CELL () ->UIColor{
        return UIColor(
            red: 242.0 / 255.0,
            green: 239.0 / 255.0,
            blue: 232.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    class func COLOR_TEXT_LABEL_READED_NOTIFI () ->UIColor{
        return UIColor(
            red: 85.0 / 255.0,
            green: 85.0 / 255.0,
            blue: 85.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    class func COLOR_TEXT_DATE_READED_NOTIFI () ->UIColor{
        return UIColor(
            red: 179.0 / 255.0,
            green: 179.0 / 255.0,
            blue: 179.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func COLOR_TITLE_BG () ->UIColor{
        return UIColor(
            red: 227.0 / 255.0,
            green: 227.0 / 255.0,
            blue: 227.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func COLOR_BODER_DEFAULT () ->UIColor{
        return UIColor(
            red: 135.0 / 255.0,
            green: 135.0 / 255.0,
            blue: 135.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func COLOR_GRAY_BACKGROUP () ->UIColor{
        return UIColor(
            red: 247.0 / 255.0,
            green: 247.0 / 255.0,
            blue: 247.0 / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func COLOR_DOT () ->UIColor{
        return UIColor(
            red: 96.0 / 255.0,
            green: 176.0 / 255.0,
            blue: 167.0 / 255.0,
            alpha: CGFloat(1.0)
            
        )
    }
    

func convertImage(_ imgView:UIImageView) -> UIImage {
        let rect : CGRect = CGRect(x: 0, y: 0, width: imgView.frame.size.width, height: imgView.frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(self.cgColor)
        context.fill(rect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    
}


extension UIColor {
    convenience init(hex: String) {
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
