//
//  WorkItem.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/06/2024.
//

import UIKit
import RealmSwift


struct TSCWorkItem {
    
    var objectId:ObjectId? = nil
    var id:UUID? = nil
    var printer:Printer? = nil
    var orderId:String = ""
    var islastItem:Bool = true
    var connectionWork:DispatchWorkItem
    var printWork:DispatchWorkItem
    var image:[UIImage] = []
    
    init(printer:Printer,connectionWork:DispatchWorkItem,printWork:DispatchWorkItem,images:[UIImage]){
        self.printer = printer
        self.connectionWork = connectionWork
        self.printWork = printWork
        self.image = images
    }
    
    
    init(objectId:ObjectId,connectionWork:DispatchWorkItem,printWork:DispatchWorkItem){
        self.objectId = objectId
        self.connectionWork = connectionWork
        self.printWork = printWork
      
    }
   

}




struct WIFIWorkItem {
    var objectId:ObjectId? = nil
    var id:UUID? = nil
    var image:UIImage? = nil
    var printer:Printer? = nil
    var printItems:[Food]? = nil
    var islastItem:Bool? = nil
    var isProcessing:Bool = false
    var connectionWork:DispatchWorkItem
    var printWork:DispatchWorkItem
    
    init(objectId:ObjectId,connectionWork:DispatchWorkItem,printWork:DispatchWorkItem){
        self.objectId = objectId
        self.connectionWork = connectionWork
        self.printWork = printWork
    }
    
    
    init(id:UUID,image:UIImage? = nil,printer:Printer? = nil,printItems:[Food]? = nil,islastItem:Bool? = nil,connectionWork:DispatchWorkItem,printWork:DispatchWorkItem){
        self.id = id
        self.image = image
        self.printer = printer
        self.printItems = printItems
        self.islastItem = islastItem
        self.connectionWork = connectionWork
        self.printWork = printWork
    }
    
    
}


struct BLEWorkItem {
    var id:UUID? = nil
    var connectionWork:DispatchWorkItem
    var printWork:DispatchWorkItem
    var images:Int
    
    init(connectionWork:DispatchWorkItem,printWork:DispatchWorkItem,images:Int){
        self.connectionWork = connectionWork
        self.printWork = printWork
        self.images = images
    }
    
}
















