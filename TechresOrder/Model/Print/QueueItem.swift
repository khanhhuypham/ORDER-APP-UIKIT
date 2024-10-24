//
//  QueueItem.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/08/2024.
//

import UIKit
import RealmSwift


struct WIFIQueuedItem{
    var id:ObjectId
    var data:Data
    var items:[Food]
    var printer:Printer
    var isLastItem:Bool
    var isFinished:Bool
    
    init(wifiQueuedItem:WIFIQueuedItemObject){
        
        self.id = wifiQueuedItem.id
        self.data = wifiQueuedItem.data
        var arr:[Food] = []
        for item in wifiQueuedItem.items{
            arr.append(Food(itemObject: item))
        }
        self.items = arr
        
        if let printer = wifiQueuedItem.printer{
            self.printer = Printer(printerObject:printer)
        }else{
            self.printer = Printer()
        }
       
        self.isLastItem = wifiQueuedItem.isLastItem
        self.isFinished = wifiQueuedItem.isFinished
    }
}



struct TSCQueuedItem{
    var id:ObjectId
    var data:[Data]
    var printer:Printer
    var isLastItem:Bool
    var isFinished:Bool
    
    init(tscQueuedItem:TSCQueuedItemObject){
        self.id = tscQueuedItem.id
        var arr:[Data] = []
        for data in tscQueuedItem.data{
            arr.append(data)
        }
        self.data = arr        
        if let printer = tscQueuedItem.printer{
            self.printer = Printer(printerObject:printer)
        }else{
            self.printer = Printer()
        }
       
        self.isLastItem = tscQueuedItem.isLastItem
        self.isFinished = tscQueuedItem.isFinished
    }
}







