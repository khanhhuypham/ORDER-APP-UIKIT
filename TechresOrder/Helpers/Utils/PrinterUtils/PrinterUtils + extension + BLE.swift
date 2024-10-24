//
//  PrinterUtils + extension + BLE.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/07/2024.
//

import UIKit


extension PrinterUtils: POSBLEManagerDelegate{
    func getBLEDevice(){
        BLEPrinterUtility?.bleManager.startScan()
    }
    
    func poSbleUpdatePeripheralList(_ peripherals: [Any]!, rssiList: [Any]!) {
        
        Constants.BLEPrinter = peripherals as? [CBPeripheral] ?? []
        
        
        
        
//        for peripheral in list ?? []{
//            
//            if let _ = (dataSource.firstIndex{ $0.identifier != peripheral.identifier }) {
//                dataSource.append(peripheral)
//            }
//         
//            
//        }
        
        
        
      
    }
    
    
    func poSbleConnect(_ peripheral: CBPeripheral!) {
        
    }
    
    func poSbleFail(toConnect peripheral: CBPeripheral!, error: Error!) {
        BLEPrinterUtility?.bleManager.disconnectRootPeripheral()
    }
    
    
    
    
    
    //=============================================================  PRINT BLE DATA  =====================================================================================================
    
    func printBLEData(printer:Printer,id:String,images:[UIImage]){
        
        let width:CGFloat = CGFloat(570)
        
        for (i,img) in images.enumerated(){
            
            let scaledRatio = width/img.size.width
           
            guard
                let image = MediaUtils.resizeImage(image: img, targetSize:CGSize(width: img.size.width*scaledRatio, height: img.size.height*scaledRatio)),
                let _ = image.cgImage else {
                  return
            }
            
            let receiptHeight = image.size.height
               
            let cropHeight = 500

            var arrImages = [UIImage]()
                    
            var y = 0
            
            while y < Int(receiptHeight) {

                let h = Int(y + cropHeight) >= Int(receiptHeight) ? Int(receiptHeight) - y : cropHeight
                
                let leftTop = CGRect(x: 0, y: y, width: Int(image.size.width), height: h)
                
                let leftHeightTop = image.cgImage?.cropping(to: leftTop)
                
                arrImages.append(UIImage(cgImage: leftHeightTop!))
                y += cropHeight
              
            }
            
            for (j, item) in arrImages.enumerated() {
                
                let receipttop = Receipt(.init(maxWidthDensity: 580, fontDensity: 10, encoding: .utf8))
                <<~ .style(.clear)
                <<< ImageItem(item.cgImage!, grayThreshold: 28)

                var dictionaryItem:[String : Any] = [:]
                
                if (j == arrImages.count - 1){
                    dLog("asd")
                    receipttop <<~ .page(.printAndFeed(lines: 2))
                    dictionaryItem = ["id":id,"isLastItem": i == images.count - 1]
                }
           
                BLEPrinterUtility?.print(with: Data(receipttop.data),printedItems:dictionaryItem)
                
            }
            
        }

    }
    

}
