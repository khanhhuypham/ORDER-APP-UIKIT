//
//  PrinterUtils + extension + PrintOrderOfTechresApp.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/08/2024.
//

import UIKit
import RxSwift
import RealmSwift

extension PrinterUtils  {
    
    
    private func appendNewWorkItem(queuedItem:WIFIQueuedItem,isLastItem:Bool=true){
        
        let id = queuedItem.id.stringValue
        let printer = queuedItem.printer
        
        let connectionWork = DispatchWorkItem(block: { [self] in
            
            let printer = queuedItem.printer
                switch printer.connection_type{
                   case .wifi:
                       POSPrinterUtility?.connectType = .WIFI
                       break
        
                   default:
                       POSPrinterUtility?.connectType = .NONE
                       break
                }
            

            POSPrinterUtility?.isPrintLive = false
            POSPrinterUtility?.wifiConnect(printer,queuedItem:["id":id,"isLastItem":isLastItem])
        })
        
        let printWork = DispatchWorkItem(block: { [self] in
            printWifiData(id:id, printer:printer, img:UIImage(data: queuedItem.data)!, isLastItem:isLastItem)
        })
        
        workItems.append(WIFIWorkItem(objectId:queuedItem.id,connectionWork: connectionWork, printWork: printWork))
    }
    
   
    func print(wifiQueuedItem:WIFIQueuedItem){

        self.appendNewWorkItem(queuedItem:wifiQueuedItem)
        
        backGroundQueue.async(execute: {
            if let firstItem = self.workItems.first{
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                    firstItem.connectionWork.perform()
                }
                
            }
        })
    }
    
    
    func canncelAllWorkItem(){

        for workItem in workItems{
            workItem.printWork.cancel()
            workItem.connectionWork.cancel()
            if workItem.connectionWork.isCancelled{
                POSPrinterUtility?.wifiDisconnect()
            }
            LocalDataBaseUtils.UpdateWifiQueuedItemToFinish(id: workItem.objectId)
            workItems.removeAll(where: {$0.objectId == workItem.objectId})
        }
        
        
    }

    
    
    func canncelWorkItem(id:ObjectId,isErrorOccur:Bool){

        if let p = workItems.firstIndex(where: {$0.objectId == id}){
            workItems[p].printWork.cancel()
            workItems[p].connectionWork.cancel()
            
            if workItems[p].connectionWork.isCancelled{
                POSPrinterUtility?.wifiDisconnect()
            }
            if isErrorOccur{
                LocalDataBaseUtils.UpdateRetryNumber(id: id)
            }else{
                LocalDataBaseUtils.UpdateWifiQueuedItemToFinish(id: id)
            }

            workItems.remove(at: p)
        }else{
            canncelAllWorkItem()
        }
    }
    
    
    
    
    
    //=============================================================  PRINT WIFI DATA  =====================================================================================================
    
    func printWifiData(id:String,printer:Printer,img:UIImage,isLastItem:Bool){
  

        let width = CGFloat(570)
        let scaledRatio = width/img.size.width

        guard
            let image = MediaUtils.resizeImage(image: img, targetSize:CGSize(width: img.size.width*scaledRatio, height: img.size.height*scaledRatio)),
            let cgImage = image.cgImage else {
              return
        }
        
        
        let receiptHeight = image.size.height

        var cropHeight = 0
           
        switch printer.type{
            
            case .cashier,.cashier_of_food_app:
                cropHeight = receiptHeight > 1500 ? Int(receiptHeight/2) :  Int(receiptHeight)
            
            default:
                cropHeight = Int(receiptHeight)
            
        }
        

        var arrImages = [UIImage]()
                
        var y = 0
        while y < Int(receiptHeight) {

            let h = Int(y + cropHeight) >= Int(receiptHeight) ? Int(receiptHeight) - y : cropHeight
            
            let leftTop = CGRect(x: 0, y: y, width: Int(image.size.width), height: h)
            
            let leftHeightTop = image.cgImage?.cropping(to: leftTop)
            
            arrImages.append(UIImage(cgImage: leftHeightTop!))
            y += cropHeight
          
        }
        
        for (index, item) in arrImages.enumerated() {
            
            let receipttop = Receipt(.init(maxWidthDensity: 580, fontDensity: 10, encoding: .utf8))
            <<~ .style(.clear)
            <<< ImageItem(item.cgImage!, grayThreshold: 28)
            
            var dictionaryItem:[String : Any] = [:]

            if (index == arrImages.count - 1){
                receipttop <<~ .page(.printAndFeed(lines: 5)) <<~ .page(.fullCut)
                dictionaryItem = ["id":id,"isLastItem": isLastItem]
            }
                       
            
            switch printer.connection_type{
                case .wifi:
                    POSPrinterUtility?.print(with: Data(receipttop.data),printedItems:dictionaryItem)
                    break

                default:
                    
                    break
            }
            
        }
    
    }



}
