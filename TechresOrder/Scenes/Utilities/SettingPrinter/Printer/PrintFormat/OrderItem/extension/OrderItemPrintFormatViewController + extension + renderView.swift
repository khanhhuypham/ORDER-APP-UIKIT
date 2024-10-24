//
//  OrderItemPrintFormatViewController + extension + render + print.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/12/2023.
//

import UIKit
import RealmSwift

extension OrderItemPrintFormatViewController {
    
    func renderSreen(printer:Printer,order:OrderDetail,printItems:[Food]) -> UIImage{
        view_of_print_food.isHidden = true
        view_of_print_stamp.isHidden = true
        
        switch printer.type{
            case .stamp:
                view_of_print_stamp.isHidden = false
            
                if printer.printer_paper_size == 50{
                    view_of_stamp_2.removeFromSuperview()
                }

                mapDataForStampPrint(printer:printer,order:order,printItems:printItems)
                break
            
            default:
                view_of_print_food.isHidden = false
                mapDataForFoodPrint(printer:printer,order:order,printItems:printItems)
                break
        }
        
        view.layoutIfNeeded()

        return MediaUtils.captureViewScreenshot(viewToCapture: generalView) ?? UIImage()
    }
    
}

