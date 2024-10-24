//
//  ManagementTableViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import SNCollectionViewLayout
import MSPeekCollectionViewDelegateImplementation

//MARK: -- CALL API
extension TableManagementViewController{
    func getAreas(){
        viewModel.getAreas().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
      
                if let areas  = Mapper<Area>().mapArray(JSONObject: response.data){
    
                    self.areas = areas
                    if((self.areas.count) != 0){
                        var allArea = Area.init()
                        allArea?.id = -1
                        allArea?.status = ACTIVE
                        allArea?.name = "Tất cả"
                        self.areas.insert(allArea!, at: 0)
                        self.areas[0].is_select = 1
                        self.viewModel.area_array.accept(self.areas)
                        self.viewModel.area_id.accept(-1)
                        self.viewModel.exclude_table_id.accept(-1)
                        self.getTables()
                    }
                    
                }
               
            }
            
           
        }).disposed(by: rxbag)
    }
        
    func getTables(){
        viewModel.getTables().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
    
                if let tables  = Mapper<Table>().mapArray(JSONObject: response.data){

                    self.viewModel.table_array.accept(tables)
                    
                    self.view_of_no_data.isHidden = tables.count > 0
                    
                }

            }
        }).disposed(by: rxbag)
        
    }
    
}
extension TableManagementViewController{
    
    //MARK: Register Cells as you want
    func registerAreaCell(){
        let areaCollectionViewCell = UINib(nibName: "AreaCollectionViewCell", bundle: .main)
        areacollectionView.register(areaCollectionViewCell, forCellWithReuseIdentifier: "AreaCollectionViewCell")
        

        areacollectionView.rx.modelSelected(Area.self) .subscribe(onNext: { element in
//            print("Selected \(element)")
            self.viewModel.area_id.accept(element.id)
            
            var areas = self.viewModel.area_array.value
            areas.enumerated().forEach { (index, value) in
                areas[index].is_select = element.id == value.id ? ACTIVE : DEACTIVE
            }
            self.viewModel.area_array.accept(areas)
    
            self.getTables()
        })
        .disposed(by: rxbag)
        
    }
    
    //MARK: Register Cells as you want
    func registerCell(){
        let tableCollectionViewCell = UINib(nibName: "TableManageCollectionViewCell", bundle: .main)
        tableCollectionView.register(tableCollectionViewCell, forCellWithReuseIdentifier: "TableManageCollectionViewCell")
        
        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 4 // Columns for .vertical, rows for .horizontal
        tableCollectionView.collectionViewLayout = snCollectionViewLayout

        
        tableCollectionView.rx.modelSelected(Table.self) .subscribe(onNext: { element in
       
            self.presentModalCreateTableViewController(table: element)
        })
        .disposed(by: rxbag)
        
    }
    func binđDataAreaCollectionView(){
     
        viewModel.area_array.bind(to: areacollectionView.rx.items(cellIdentifier: "AreaCollectionViewCell", cellType: AreaCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
    
    func binđDataCollectionView(){
     
        viewModel.table_array.bind(to: tableCollectionView.rx.items(cellIdentifier: "TableManageCollectionViewCell", cellType: TableManageCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
}
extension TableManagementViewController: TechresDelegate{
    func presentModalCreateTableViewController(table:Table = Table()) {
        var areaArray = viewModel.area_array.value
        areaArray.remove(at: 0)
        
        let vc = CreateTableViewController()
        vc.table = table
        vc.areaArray = areaArray
        vc.delegate = self
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)

    }
    
    func presentModalCreateTableQuicklyViewController() {
        let vc = CreateTableQuicklyViewController()
        var areaArray = viewModel.area_array.value
        areaArray.remove(at: 0)
        vc.areaArray = areaArray
        vc.completeHandler = self.getTables
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)

    }
    
    
    func callBackReload() {
        self.getTables()
    }
      
}
