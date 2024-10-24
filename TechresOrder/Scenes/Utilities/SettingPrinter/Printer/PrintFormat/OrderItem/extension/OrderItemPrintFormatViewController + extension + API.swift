//
//  OrderItemPrintFormatViewController + extension + API.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/12/2023.
//

import UIKit
import RxSwift
import ObjectMapper
extension OrderItemPrintFormatViewController {
    
    func updateAlReadyPrinted(order:OrderDetail,alreadyPrintedItems:[Int]) {
        
        if viewModel.alreadyPrintedNumber.value == viewModel.printNumber.value{
            progressBar.setProgress(1, animated: true)
            progressBarTimer.invalidate()
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                self.actionBack("")
                (self.completeHandler ?? {})()
            }
        }
        
//        viewModel.updateReadyPrinted(alreadyPrintedItems: alreadyPrintedItems).subscribe(onNext: { [self](response) in
//                    
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//
//                if viewModel.alreadyPrintedNumber.value == viewModel.printNumber.value{
//                    progressBarTimer.invalidate()
//                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
//                        self.actionBack("")
//                        (self.completeHandler ?? {})()
//                    }
//                }
//            }else{
//                showErrorMessage(content: response.message ?? "error")
//                self.viewModel.cancelAllWorkItems()
//            }
//        }).disposed(by: rxbag)
    }

}
    
