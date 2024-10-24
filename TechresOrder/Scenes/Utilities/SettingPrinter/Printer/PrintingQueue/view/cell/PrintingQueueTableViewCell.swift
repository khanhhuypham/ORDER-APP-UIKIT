//
//  PrintingQueueTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 25/06/2024.
//

import UIKit

class PrintingQueueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_printer: UILabel!
    @IBOutlet weak var lbl_orderId: UILabel!
    @IBOutlet weak var lbl_itemList: UILabel!
    @IBOutlet weak var lbl_lastItem: UILabel!
    @IBOutlet weak var lbl_retried_number: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func actionPrint(_ sender: Any) {
        if let item = self.wifidata{
            PrinterUtils.shared.print(wifiQueuedItem: WIFIQueuedItem(wifiQueuedItem: item))
        }
        
        
        if let item = self.tscdata{
            PrinterUtils.shared.print(tscQueuedItem: TSCQueuedItem(tscQueuedItem: item))
        }
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        
//        guard
//            let position = viewModel?.wifiQueuedItems.firstIndex(where: {$0.id == wifidata?.id}),
//            let item = viewModel?.getItem(at: IndexPath(row: position, section: 0))
//        else {
//            return
//        }
//        LocalDataBaseUtils.UpdateWifiQueuedItemToFinish(id: item.id)
//        
//        viewModel?.view?.fetchData()
    }
    
    
    var viewModel:PrintingQueueViewModel? = nil
    
    var wifidata: WIFIQueuedItemObject?{
        didSet{
            mapWifiItem(item:wifidata!)
        }
    }
    
    
    var tscdata: TSCQueuedItemObject?{
        didSet{
            mapTSCItem(item:tscdata!)
        }
    }
    
    private func mapTSCItem(item:TSCQueuedItemObject){
        
        var image:UIImage = UIImage()
        
        for data in item.data{
            image = MediaUtils.combineScreenshots(image, UIImage(data: data)) ?? UIImage()
        }
        
        img.image = image
        
        lbl_printer.text = item.printer?.printer_name ?? ""
        lbl_orderId.text = String(format: "#%d", item.orderId)
        var itemNames = ""
        
//        for (i,data) in item.items.enumerated(){
//            itemNames += i == item.items.count-1 ? data.name : (data.name + " \n")
//        }
        
        lbl_itemList.text = itemNames
        lbl_lastItem.text = String(format: "isLastItem: %@", item.isLastItem ? "true" : "false")
        lbl_retried_number.text = String(format: "RetriedNumber: %d/10 \n(%@)", item.retryNumber, item.isFinished ? "finished" : "unfinish")
        
    }
    

    private func mapWifiItem(item:WIFIQueuedItemObject){

        img.image = UIImage(data: item.data)

        lbl_printer.text = item.printer?.printer_name ?? ""
        lbl_orderId.text = String(format: "#%d", item.orderId)
        var itemNames = ""
        
        for (i,data) in item.items.enumerated(){
            itemNames += i == item.items.count-1 ? data.name : (data.name + " \n")
        }
        
        lbl_itemList.text = itemNames
        lbl_lastItem.text = String(format: "isLastItem: %@", item.isLastItem ? "true" : "false")
        lbl_retried_number.text = String(format: "RetriedNumber: %d/10 \n(%@)", item.retryNumber, item.isFinished ? "finished" : "unfinish")
        
    }
    
}
