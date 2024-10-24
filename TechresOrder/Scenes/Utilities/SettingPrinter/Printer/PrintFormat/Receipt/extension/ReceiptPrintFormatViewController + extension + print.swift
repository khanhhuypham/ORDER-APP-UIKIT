//
//  ReceiptPrintFormatViewController + extension + print.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/12/2023.
//

import UIKit

extension ReceiptPrintFormatViewController {
    
    func performWorkItem(printer:Printer){
        
        switch printer.connection_type{
            case .wifi:
                printWIFI(printer: printer)
                break
            case .blueTooth:
                printBLE(printer: printer)
                break
            default:
                messageBox("Thiết bị đang sử dụng chỉ hỗ trợ đối với máy in rời", withTitle: "Cảnh báo", withAutoDismiss: true)
                break
        }
        
        
        if let WifiWorkItem = viewModel.WifiWorkItem.value{
            WifiWorkItem.connectionWork.perform()
        }
        
    
        if let BLEWorkItem = viewModel.BLEWorkItem.value{
            BLEWorkItem.connectionWork.perform()
        }
    }
    
    private func printBLE(printer:Printer,islastItem:Bool = true){
              
        let connectionWork = DispatchWorkItem(block: { [self] in
            if let BLEPrinter = Constants.BLEPrinter.first(where: {$0.name == printer.printer_name}){
                BLEPrinterUtility?.bleManager.connectDevice(BLEPrinter)
            }else{
                let error = NSError(domain: "Phạm khánh Huy gà", code: 0, userInfo: [NSLocalizedDescriptionKey : "Không tìm Thấy thiết bị Bluetooth để kết nối"])
                let dictionary = [
                    "error":error,
                    PRINTER_NOTIFI.IS_PRINT_WIFI: false
                ]
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: PRINTER_NOTIFI.CONNECT_FAIL),object: dictionary)
            }
        })
        
        let image = renderImage() ?? UIImage()
        
        let printWork = DispatchWorkItem(block: { [self] in
            PrinterUtils.shared.printBLEData(printer: printer, id: UUID().uuidString, images: [image])
        })
        
        viewModel.BLEWorkItem.accept(BLEWorkItem(connectionWork: connectionWork,printWork: printWork,images: 1))
    }

    
    private func printWIFI(printer:Printer,islastItem:Bool = true){
  
 
        let id = UUID()
        
        let image = renderImage()
        
        let connectionWork = DispatchWorkItem(block: { [self] in
            let dictionaryItem:[String : Any] = ["id":id]
            POSPrinterUtility?.isPrintLive = true
            POSPrinterUtility?.connectType = .WIFI
            POSPrinterUtility?.wifiConnect(printer, queuedItem: dictionaryItem)
        })
        
        let printWork = DispatchWorkItem(block: { [self] in
            PrinterUtils.shared.printWifiData(id:id.uuidString, printer:printer, img:image ?? UIImage(), isLastItem:islastItem)
        })
                
        let wifiWorkItem = WIFIWorkItem(id: id,image: image,printer: printer,connectionWork: connectionWork, printWork: printWork)
        
        viewModel.WifiWorkItem.accept(wifiWorkItem)
    }
    
    
    
    
    
    
    
    private func renderImage() -> UIImage?{
        guard let screenImg = MediaUtils.captureViewScreenshot(viewToCapture: contentView) else{
            return nil
        }
       
        let width = CGFloat(570)
        let scaledRatio = width/screenImg.size.width
        
        return MediaUtils.resizeImage(image: screenImg, targetSize:CGSize(width: screenImg.size.width*scaledRatio, height: screenImg.size.height*scaledRatio))
        
    }
    

    
}

 
