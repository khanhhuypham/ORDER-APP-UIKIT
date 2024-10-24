//
//  LocalDataBaseUtils + extension + Food App.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/08/2024.
//

import UIKit
import RealmSwift
extension LocalDataBaseUtils {
    
    
    static func saveTSCDataToDB(orderId:String,printer:Printer,imgs:[UIImage],isLastItem:Bool){

        do {
            let realm = try Realm()
            
            if let printerObject = realm.object(ofType: PrinterObject.self, forPrimaryKey: printer.id){
                
                let newItem = TSCQueuedItemObject.init()
                newItem.orderId = orderId
                
                for image in imgs{
                    newItem.data.append(image.pngData() ?? Data())
                }
            
                newItem.printer = printerObject
                newItem.isLastItem = isLastItem
                newItem.isFinished = false
            
                try realm.write {
                    realm.add(newItem)
                }
            
    
            }else{
                return
            }

        } catch let error {
            dLog(error.localizedDescription)
            return
        }
    }
    
    
    static func getTSCQueuedItemById(id:ObjectId) -> TSCQueuedItemObject? {
        do {
            let realm = try Realm()
                     
            return realm.object(ofType: TSCQueuedItemObject.self, forPrimaryKey: id)
             
        } catch let error {
            dLog(error.localizedDescription)
            return nil
        }
    }
    

    static func getFirstTSCQueuedItem() -> TSCQueuedItemObject? {
        do {
            let realm = try Realm()
            
            let queuedItems = realm.objects(TSCQueuedItemObject.self)
            
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
    
    
    
    static func UpdateRetryNumberOfTSCQueuedItem(id:ObjectId) {
        do {
            let realm = try Realm()
            guard let item = realm.object(ofType: TSCQueuedItemObject.self, forPrimaryKey: id) else{
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
    
    
    
    static func UpdateTSCQueuedItemToFinish(id:ObjectId?) {
        do {
            let realm = try Realm()
            
            guard let item = realm.object(ofType: TSCQueuedItemObject.self, forPrimaryKey: id) else{
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
