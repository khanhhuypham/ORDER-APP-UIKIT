//
//  LocalDataBaseUtils.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/06/2024.
//

import UIKit
import RealmSwift



class LocalDataBaseUtils: NSObject {
    

    static func removeAllQueuedItem() {
        do {
            let realm = try Realm()
            
            try realm.write {
                // Delete all instances of Dog from the realm.
                let queuedItem = realm.objects(WIFIQueuedItemObject.self)
                realm.delete(queuedItem)
            }
        
        } catch let error {
            dLog(error.localizedDescription)
        }
        
        
        
        do {
            let realm = try Realm()
            
            try realm.write {
                // Delete all instances of Dog from the realm.
                let queuedItem = realm.objects(TSCQueuedItemObject.self)
                realm.delete(queuedItem)
            }
        
        } catch let error {
            dLog(error.localizedDescription)
        }
        
        
    }
    
    
    static func CheckFinishedQueuedItem() {
        do {
            let realm = try Realm()

            let queue = realm.objects(WIFIQueuedItemObject.self)
            
            let finishedQueuedItem = queue.where {
                $0.isFinished == true
            }
            
            try realm.write {
                realm.delete(finishedQueuedItem)
            }
                
        } catch let error {
            dLog(error.localizedDescription)
        }
        
        
        
        do {
            let realm = try Realm()

            let queue = realm.objects(TSCQueuedItemObject.self)
            
            let finishedQueuedItem = queue.where {
                $0.isFinished == true
            }
            
            try realm.write {
                realm.delete(finishedQueuedItem)
            }
                
        } catch let error {
            dLog(error.localizedDescription)
        }
        
        
        
    }


}
