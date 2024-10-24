//
//  FoodAppPrintFormatViewController + extension + Print.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//



import UIKit
//import RealmSwift

extension FoodAppPrintFormatViewController {
    

    func printTSC(printer:Printer,order:FoodAppOrder){
        var printItems = order.details
        var images:[UIImage] = viewModel.TSCWorkItem.value?.image ?? []
        for (index,item) in printItems.enumerated() {
            
            if item.quantity > 1{
                for _ in 0..<Int(item.quantity) - 1{
                    printItems.insert(item, at: index + 1)
                }
                
            }
        }
       
        for _ in 1...printer.print_number{
            
            switch printer.printer_paper_size{
                
                case 30:
                    for j in stride(from: 0, to: printItems.count, by: 2) {
                        /*
                                    if we reach to the last item of array and the last item is odd number. we will get Array(itemsOfStampPrint[1...1])
                                */
                        
                        
                        let array = j == printItems.count - 1 && printItems.count%2 == 1
                        ? Array(printItems[j...j])
                        : Array(printItems[j...j+1])
                        
    
                        images.append(renderStamp(printer:printer,printItems: array,infor: (printItems.count,j)))
                    }
                
                default:
                    for (j,item) in printItems.enumerated(){
                        let image = renderStamp(printer:printer,printItems: [item],infor: (printItems.count,j))
                        images.append(image)
                    }
                
                
            }

        }
        
 
        
        let id = UUID()
        
        let dictionaryItem:[String : Any] = ["id":id]
        
        let connectionWork = DispatchWorkItem(block: { [self] in
            TSCPrinterUtility?.isPrintLive = true
            TSCPrinterUtility?.wifiConnect(printer, id:dictionaryItem)
        })

        let printWork = DispatchWorkItem(block: { [self] in
            PrinterUtils.shared.printTSCData(printer:printer,id:id.uuidString,images:images)
            
        })
        
        var TSCWorkItem = TSCWorkItem(printer:printer,connectionWork: connectionWork,printWork: printWork,images: images)
        
        viewModel.TSCWorkItem.accept(TSCWorkItem)
        
    }
    
    
    func printdata(printer:Printer,order:FoodAppOrder,islastItem:Bool = true){
        
        switch printer.connection_type{
            
            case .wifi:
                printWIFI(printer:printer,order: order, islastItem:islastItem)
            
            case .blueTooth:
//                printBLE(printer:printer, order: order, islastItem:islastItem)
                return
            
            default:
                return
        }
    }
    
    

    
    
    private func printWIFI(printer:Printer,order:FoodAppOrder,islastItem:Bool = true){
        var wifiWorkItems = viewModel.WIFIWorkItems.value
        let image = renderReceipt(printer:printer,order: order)
        let id = UUID()
       
        
        
        let connectionWork = DispatchWorkItem(block: { [self] in
            
            let dictionaryItem:[String : Any] = ["id":id,"isLastItem":islastItem]
            
            POSPrinterUtility?.isPrintLive = true
            POSPrinterUtility?.connectType = .WIFI
            POSPrinterUtility?.wifiConnect(printer, queuedItem: dictionaryItem)
          
        })
        
        let printWork = DispatchWorkItem(block: { [self] in
            PrinterUtils.shared.printWifiData(id:id.uuidString, printer:printer, img:image, isLastItem:islastItem)
        })
        
        
        let wifiWorkItem = WIFIWorkItem(id: id,image: image,printer: printer,connectionWork: connectionWork, printWork: printWork)
        
        wifiWorkItems.append(wifiWorkItem)
        
        viewModel.WIFIWorkItems.accept(wifiWorkItems)
        
        
        
    
    }
    

   
    
}
