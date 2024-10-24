//
//  PrintingQueueViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/06/2024.
//

import UIKit
import RealmSwift
extension PrintingQueueViewController{
    func chectSchemaVersion(){
        let configCheck = Realm.Configuration();
        do {
             let fileUrlIs = try schemaVersionAtURL(configCheck.fileURL!)
            print("schema version \(fileUrlIs)")
        } catch  {
            print(error)
        }
    }
    
    
    func migrateLocalDB(){

    }
}
