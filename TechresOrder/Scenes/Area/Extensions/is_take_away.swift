//
//  AreaViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 15/02/2023.
//

import UIKit
import JonAlert
import ObjectMapper
extension AreaViewController{
    func getAreas(){

        viewModel.getAreas().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
        
                if var data  = Mapper<Area>().mapArray(JSONObject: response.data){
                  


                    data.insert(Area(id: -1, name: "Tất cả khu vực", is_select: ACTIVE), at: 0)
                    
                    
                    
                    if permissionUtils.is_allow_take_away{
                        data.insert(Area(id: -2, name: "Mang về", is_select: DEACTIVE), at: 1)
                    }

                    
                    let selectedArea = self.viewModel.area_array.value.filter{$0.is_select == ACTIVE}
                    
                    if selectedArea.count > 0{
                        
                        data = data.map{(value) in
                            var area = value
                            area.is_select = selectedArea[0].id == value.id ? ACTIVE : DEACTIVE
                            return area
                        }
                    }
                    
                    self.viewModel.area_array.accept(data)

                    self.getTables(areaId: data.filter{$0.is_select==ACTIVE}.first?.id ?? -1)
                }
               
            }
            
        }).disposed(by: rxbag)
    }
    
    func getTables(areaId:Int){
        if areaId == -2{
            var table = Table()
            table.id = 0
            table.name = "MV"
            table.is_take_away = ACTIVE
            viewModel.table_array.accept([table])
        }else{
            
            viewModel.getTables(areaId: areaId).subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    if let tables = Mapper<Table>().mapArray(JSONObject: response.data){
                        self.viewModel.table_array.accept(tables)
                        self.view_no_data.isHidden = self.viewModel.table_array.value.count > 0 ? true : false
                    }
                }
            }).disposed(by: rxbag)
        }
    }
    

    
    func closeTable(){
        viewModel.closeTable().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                Toast.show(message: "Đóng bàn thành công", controller: self)
                self.getTables(areaId: self.viewModel.area_array.value.filter{$0.is_select==ACTIVE}.first?.id ?? -1)
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
}


extension AreaViewController: DialogConfirmDelegate{
    func presentModalDialogConfirmViewController(dialog_type:Int, title:String, content:String) {
        let vc = DialogConfirmViewController()
        vc.dialog_type = dialog_type
        vc.dialog_title = title
        vc.content = content
        vc.delegate = self
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func accept() {
        closeTable()
    }
    func cancel() {
    }
}
