//
//  SettingPrinter_ReBuildViewController + Extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/09/2023.
//

import UIKit
import ObjectMapper
import RxSwift
extension SettingPrinterViewController {
    
    func registerCellAndBindTable(){
        registerCell()
        bindTableView()
    }
    
    //MARK: Register Cells as you want
    private func registerCell(){
        let cell = UINib(nibName: "SettingPrinterTableViewCell", bundle: .main)
    
        tableView_of_printer_bill.register(cell, forCellReuseIdentifier: "SettingPrinterTableViewCell")
        tableView_of_printer_bill.rowHeight = 50
        
        tableView_Of_printer_chef_bar.register(cell, forCellReuseIdentifier: "SettingPrinterTableViewCell")
        tableView_Of_printer_chef_bar.rowHeight = 50
        
        tableView_of_printer_stamp.register(cell, forCellReuseIdentifier: "SettingPrinterTableViewCell")
        tableView_of_printer_stamp.rowHeight = 50
    }
    
   private func bindTableView(){
        
        viewModel.printersBill.bind(to: tableView_of_printer_bill.rx.items(cellIdentifier: "SettingPrinterTableViewCell", cellType: SettingPrinterTableViewCell.self))
            {(row, printer, cell) in
                cell.viewModel = self.viewModel
                cell.data = printer
            }.disposed(by: rxbag)
        
        viewModel.printersChefBar.bind(to: tableView_Of_printer_chef_bar.rx.items(cellIdentifier: "SettingPrinterTableViewCell", cellType: SettingPrinterTableViewCell.self))
            {(row, printer, cell) in
                cell.viewModel = self.viewModel
                cell.data = printer
            }.disposed(by: rxbag)
        
        viewModel.printersStamp.bind(to: tableView_of_printer_stamp.rx.items(cellIdentifier: "SettingPrinterTableViewCell", cellType: SettingPrinterTableViewCell.self))
            {(row, printer, cell) in
                cell.viewModel = self.viewModel
                cell.data = printer
            }.disposed(by: rxbag)
        
    }
     
}

//MARK: -- CALL API
extension SettingPrinterViewController {
    func getPrinters(){
        viewModel.kitchens().subscribe(onNext: { [weak self] (response) in
            guard let self = self else { return }
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let kitchens = Mapper<Printer>().mapArray(JSONObject: response.data) {
                    if(kitchens.count > 0){
                        
                        
                        var receipt_printer:[Printer] = []
                        var stamp_printer:[Printer] = []
                        var chef_bar_printer:[Printer] = []
                        
                        if self.isFoodApp{
                            receipt_printer = kitchens.filter{$0.type == .cashier_of_food_app}
                            stamp_printer = kitchens.filter{$0.type == .stamp_of_food_app}
                        }else{
                            receipt_printer = kitchens.filter{$0.type == .cashier}
                            stamp_printer = kitchens.filter{$0.type == .stamp}
                            chef_bar_printer = kitchens.filter{$0.type == .bar || $0.type == .chef}
                        }
                        
        

                        self.viewModel.printersBill.accept(receipt_printer)
                            
                        self.viewModel.printersStamp.accept(stamp_printer)

                        self.viewModel.printersChefBar.accept(chef_bar_printer)
                        
                        self.height_of_printer_stamp_view.constant = CGFloat(self.viewModel.printersStamp.value.count*50 + 60)
                        
                        self.view.layoutIfNeeded()

                        
                        ManageCacheObject.setPrinters(kitchens, cache_key: KEY_CHEF_BARS)
                        
                        LocalDataBaseUtils.updatePrinters(printersArray: kitchens)
                     
                    }else{
                        self.viewModel.printersChefBar.accept([])
                    }
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    

    
}


