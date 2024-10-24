//
//  LocalDataBaseUtils + extension + WIFI.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/08/2024.
//

import UIKit
import RealmSwift



//MARK: addition method
extension LocalDataBaseUtils{
    

    private static func insertNewItem(order:OrderDetail,printer:Printer,img:UIImage,printItems:[Food],isLastItem:Bool) -> ObjectId? {
        
        do {
            let realm = try Realm()
           
            if let printerObject = realm.object(ofType: PrinterObject.self, forPrimaryKey: printer.id),let data = img.pngData(){
                            
                let newItem = WIFIQueuedItemObject.init()
              
                newItem.orderId = order.id
                newItem.data = data
                var items:[ItemObject] = []
                for item in printItems{
                  items.append(ItemObject(item: item))
                }
                newItem.items.append(objectsIn: items)
                newItem.printer = printerObject
                newItem.isLastItem = isLastItem
                newItem.isFinished = false
            
                try realm.write {
                    realm.add(newItem)
                }
                
                return newItem.id
                
            }else{
                return ObjectId()
            }

        } catch let error {
            dLog(error.localizedDescription)
            return ObjectId()
        }
    }
    
    static func saveToLocalDataBase(order:OrderDetail,printer:Printer,img:UIImage,printItems:[Food],isLastItem:Bool) -> ObjectId?{
       return insertNewItem(order: order, printer: printer, img: img, printItems: printItems, isLastItem: isLastItem)
    }

}




//MARK: Get method
extension LocalDataBaseUtils {
    static func getQueuedWifiItemById(id:ObjectId) -> WIFIQueuedItemObject? {
        do {
            let realm = try Realm()
                     
            return realm.object(ofType: WIFIQueuedItemObject.self, forPrimaryKey: id)
             
        } catch let error {
            dLog(error.localizedDescription)
            return nil
        }
    }
    

    static func getFirstWifiQueuedItem() -> WIFIQueuedItemObject? {
        do {
            let realm = try Realm()
            
            let queuedItems = realm.objects(WIFIQueuedItemObject.self)
            
            // Query by age
            let filteredQueue = queuedItems.where {
                $0.isFinished == false
            }
            
            return Array(filteredQueue).first
            
        } catch let error {
            dLog(error.localizedDescription)
            return nil
        }
    }
    
    
    
    static func getWifiQueuedItem() -> [WIFIQueuedItemObject]? {
        do {
            let realm = try Realm()
            
            let queuedItems = realm.objects(WIFIQueuedItemObject.self)
            
            return Array(queuedItems)
            
            
        } catch let error {
            dLog(error.localizedDescription)
            return nil
        }
    }
    

    static func isOrderPerformingPrintProcess(orderId:Int) -> Bool {
        do {
            let realm = try Realm()
            
            let queue = realm.objects(WIFIQueuedItemObject.self).where{
                $0.orderId == orderId
            }
            
            let queuedItems = Array(queue)
            
            return queuedItems.count > 0 && queuedItems.filter{$0.isFinished == false}.count > 0 ? true : false
            
        } catch let error {
            dLog(error.localizedDescription)
            return false
        }
    }
    
    
}





//MARK: update method
extension LocalDataBaseUtils{
    
    static func UpdateRetryNumber(id:ObjectId) {
        do {
            let realm = try Realm()
            guard let item = realm.object(ofType: WIFIQueuedItemObject.self, forPrimaryKey: id) else{
                return
            }
            

            try realm.write {
                // Delete the related collection
                if !item.isFinished {
                    item.retryNumber += 1
                    if item.retryNumber >= 10{
                        item.isFinished = true

                    }
                }
            }
        
        } catch let error {
            dLog(error.localizedDescription)
            return
        }
    }
    
    
    static func UpdateWifiQueuedItemToFinish(id:ObjectId?) {
        do {
            let realm = try Realm()
            
            guard let item = realm.object(ofType: WIFIQueuedItemObject.self, forPrimaryKey: id) else{
                return
            }
    
            try realm.write {
                // Delete the related collection
                item.isFinished = true
              
            }
        
        } catch let error {
            dLog(error.localizedDescription)
            return
        }
    }
    
}




//MARK: remove method
extension LocalDataBaseUtils{
    
    static func removeWifiQueuedItemByOrderId(orderId:Int){
        do {
            let realm = try Realm()
        
            try realm.write {
                
                let oldItems = realm.objects(WIFIQueuedItemObject.self).where{
                    $0.orderId == orderId
                }
                
                for oldItem in oldItems{
                    oldItem.isFinished = true
                }
    
            }
                

        } catch let error {
            dLog(error.localizedDescription)
            
        }
        
        
    
    }
    
    

    static func removeQueuedItem(id:ObjectId) {
        do {
            let realm = try Realm()
            
            guard let item = realm.object(ofType: WIFIQueuedItemObject.self, forPrimaryKey: id) else{
                return
            }
    
            try realm.write {
                // Delete the related collection
                realm.delete(item)
            }
        
        } catch let error {
            dLog(error.localizedDescription)
        }
    }
    
    

   
    
}
