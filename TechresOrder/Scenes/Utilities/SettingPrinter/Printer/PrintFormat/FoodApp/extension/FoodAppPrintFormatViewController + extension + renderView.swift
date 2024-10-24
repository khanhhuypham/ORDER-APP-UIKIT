//
//  FoodAppPrintFormatViewController + extension + renderView.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//

import UIKit


extension FoodAppPrintFormatViewController {

    
    func renderStamp(printer:Printer,printItems:[OrderItemOfFoodApp] = [],infor:(total:Int,nth:Int) = (0,0)) -> UIImage{
        view_of_print_receipt.isHidden = true
        view_of_print_stamp.isHidden = false
    
        if printer.printer_paper_size == 50{
            view_of_stamp_2.removeFromSuperview()
        }

        mapDataForStampPrint(printer:printer,printItems:printItems,infor:infor)
        
        view.layoutIfNeeded()

        return MediaUtils.captureViewScreenshot(viewToCapture: generalView) ?? UIImage()
    }
    
    func renderReceipt(printer:Printer,order:FoodAppOrder) -> UIImage{
        view_of_print_stamp.isHidden = true
        view_of_print_receipt.isHidden = false
        mapDataForReceiptPrint(order: order)
        view.layoutIfNeeded()

        return MediaUtils.captureViewScreenshot(viewToCapture: generalView) ?? UIImage()
    }
    
}

