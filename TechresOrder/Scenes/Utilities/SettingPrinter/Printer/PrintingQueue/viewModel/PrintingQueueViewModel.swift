//
//  PrintingQueueViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 25/06/2024.
//

import UIKit
import RealmSwift

protocol PrintingQueueViewModelDelegate: class {
    func viewModel(_ viewModel: PrintingQueueViewModel, needperfomAction action: PrintingQueueViewModel.Action)
}

final class PrintingQueueViewModel {

    enum Action {
        case reloadData
    }
    
    enum itemType {
        case wifi
        case tsc
    }

    private var notificationToken: NotificationToken?
    weak var delegate: PrintingQueueViewModelDelegate?
    
    var itemArray:[(type:itemType,item:Any)] = []
    
//    var wifiQueuedItems: [WIFIQueuedItemObject] = []
//    
//    var tscQueuedItems: [TSCQueuedItemObject] = []
//    
    
    private(set) weak var view: PrintingQueueViewController?
    
    
    
    func setupObserve() {
        let realm = try! Realm()
        notificationToken = realm.objects(WIFIQueuedItemObject.self).observe({ (change) in
            self.delegate?.viewModel(self, needperfomAction: .reloadData)
        })
        
        notificationToken = realm.objects(TSCQueuedItemObject.self).observe({ (change) in
            self.delegate?.viewModel(self, needperfomAction: .reloadData)
        })
        
        
    }
    
    
    func fetchData(completion: (Bool) -> ()) {
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(WIFIQueuedItemObject.self)
            
            // convert to array
//            wifiQueuedItems = Array(results)
            
            itemArray.removeAll(where: {$0.type == .wifi})
            
            for queuedItem in Array(results){
                itemArray.append((type:itemType.wifi,item:queuedItem))
            }
            
            
            // call back
            completion(true)
            
        } catch {
            // call back
            completion(false)
        }
        
        
        
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(TSCQueuedItemObject.self)
            
            // convert to array
//            tscQueuedItems = Array(results)
            
            
            itemArray.removeAll(where: {$0.type == .tsc})
            
            for queuedItem in Array(results){
                itemArray.append((type:itemType.tsc,item:queuedItem))
            }
            
            
            // call back
            completion(true)
            
        } catch {
            // call back
            completion(false)
        }
        
    }
    
    
    
    
    func deleteAll(completion: (Bool) -> ()) {
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(WIFIQueuedItemObject.self)
            
            // delete all items
            try realm.write {
                realm.delete(results)
            }
            
            // call back
            completion(true)
            
        } catch {
            // call back
            completion(false)
        }
    }
    
    func getItem(at indexPath: IndexPath) -> (type:itemType,item:Any) {
        return itemArray[indexPath.row]
    }
        
    func bind(view:PrintingQueueViewController){
        self.view = view
    }
}
