//
//  DialogChooseTableViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/01/2024.
//


import UIKit
import JonAlert
import ObjectMapper
extension DialogChooseTableViewController{
    func getAreas(){

        viewModel.getAreas().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
        
                if var data  = Mapper<Area>().mapArray(JSONObject: response.data){

                    var areaArray = data
                    var allArea = Area.init()
                    allArea?.id = -1
                    allArea?.is_select = ACTIVE
                    allArea?.name = "Tất cả khu vực"
                    areaArray.insert(allArea!, at: 0)
              
                    self.viewModel.area_array.accept(areaArray)
                    self.getTables(areaId: -1)
                }
               
            }
            
        }).disposed(by: rxbag)
    }
    
    func getTables(areaId:Int){
     
        viewModel.getTables(areaId: areaId).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let tables = Mapper<Table>().mapArray(JSONObject: response.data){
                    dLog(tables.toJSON())
                    self.viewModel.table_array.accept(tables.filter({$0.status != 1 && $0.status != 3 && $0.order_status != 1 && $0.order_status != 4}))
                    self.view_no_data.isHidden = tables.count > 0 ? true : false
                }
            }
        }).disposed(by: rxbag)
        
    }
    

}

extension DialogChooseTableViewController{
    func moveTable(target_table_id:Int){
        viewModel.moveTable(target_table_id:target_table_id).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.dismiss(animated: true,completion: {self.delegate?.callBackReload()})
            }else{
                Toast.show(message: response.message ?? "", controller: self)
            }
        }).disposed(by: rxbag)
        
    }
    
    func mergeTable(target_table_ids:[Int]){
        viewModel.isAPICalling.accept(true)
        viewModel.mergeTable(target_table_ids:target_table_ids).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                Toast.show(message: "Gộp bàn thành công", controller: self)
                self.delegate?.callBackReload()
                self.dismiss(animated: true)
              
            }else{
                JonAlert.showError(message:response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
                dLog(response.message ?? "")
            }
            
            self.viewModel.isAPICalling.accept(false)
        }).disposed(by: rxbag)
        
    }
    
}


