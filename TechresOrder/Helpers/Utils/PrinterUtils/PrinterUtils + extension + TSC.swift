//
//  PrinterUtils + extension + PrintOrderOfFoodApp_onBackGround.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/08/2024.
//

import UIKit
import RealmSwift


extension PrinterUtils {
    
    func print(tscQueuedItem:TSCQueuedItem){

        setupWorkItem(tscQueuedItem:tscQueuedItem)
        
        backGroundQueue.async(execute: {
            if let tscWorkItem = self.tscWorkItem{
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
                    
                    tscWorkItem.connectionWork.perform()
                }
            }
        })
    }
    
    
    private func setupWorkItem(tscQueuedItem:TSCQueuedItem){
        
        let id = tscQueuedItem.id.stringValue
        let printer = tscQueuedItem.printer
        
        let connectionWork = DispatchWorkItem(block: { [self] in
            TSCPrinterUtility?.isPrintLive = false
            TSCPrinterUtility?.wifiConnect(tscQueuedItem.printer,id:["id":id,"isLastItem":true])
        })
        
        
        let printWork = DispatchWorkItem(block: { [self] in
            let images = tscQueuedItem.data.map{UIImage(data: $0) ?? UIImage()}
            printTSCData(printer:printer,id:id,images:images)
        })
        
        self.tscWorkItem = TSCWorkItem(objectId:tscQueuedItem.id,connectionWork: connectionWork, printWork: printWork)
    }
    
   
    
    func canncelTSCWorkItem(id:ObjectId,isErrorOccur:Bool){
        
        if let workItem = self.tscWorkItem{
            workItem.connectionWork.cancel()
            
            workItem.printWork.cancel()
            

            if workItem.connectionWork.isCancelled{
                TSCPrinterUtility?.wifiDisconnect()
            }
            
            if isErrorOccur{
                LocalDataBaseUtils.UpdateRetryNumberOfTSCQueuedItem(id: id)
            }else{
                LocalDataBaseUtils.UpdateTSCQueuedItemToFinish(id: workItem.objectId)
            }
            
            tscWorkItem = nil
        }

    }
    
    
    //=============================================================  PRINT TSC DATA  =====================================================================================================
    
    func printTSCData(printer:Printer,id:String,images:[UIImage]){
        
        let width:CGFloat = printer.printer_paper_size == 50 ? CGFloat(360) : CGFloat(540)
        
        
        for (index,img) in images.enumerated(){
            
            let scaledRatio = width/img.size.width
           
            guard
                let image = MediaUtils.resizeImage(image: img, targetSize:CGSize(width: img.size.width*scaledRatio, height: img.size.height*scaledRatio)),
                let _ = image.cgImage else {
                  return
            }
            
            let dictionaryItem:[String : Any] = ["id":id,"isLastItem": index == images.count - 1 ? true : false]

            TSCPrinterUtility?.printPicture(image,ids:dictionaryItem)
        }
        
    }
    
}
