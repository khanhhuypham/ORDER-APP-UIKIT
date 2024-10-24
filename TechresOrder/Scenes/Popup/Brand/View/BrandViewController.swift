//
//  BrandViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import ObjectMapper
import RxRelay
import RxSwift

class BrandViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textFieldSearch: UITextField!
    var viewModel = BrandViewModel()
    var key_word = ""
    var delegate:BrandDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCell()
        bindTableViewData()
        fetBrands()


    }
    

}
extension BrandViewController{
        func registerCell() {
            let brandTableViewCell = UINib(nibName: "BrandTableViewCell", bundle: .main)
            tableView.register(brandTableViewCell, forCellReuseIdentifier: "BrandTableViewCell")
            
            self.tableView.estimatedRowHeight = 100
            self.tableView.rowHeight = 80
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

            
            tableView.rx.modelSelected(Brand.self) .subscribe(onNext: { [self] element in
                print("Selected \(element)")
                ManageCacheObject.saveCurrentBrand(element)
                self.dismiss(animated: true,completion: {
                    self.delegate?.callBackChooseBrand(brand: Brand())
                })
            })
            .disposed(by: rxbag)
            
        }
}
extension BrandViewController{
    
    private func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "BrandTableViewCell", cellType: BrandTableViewCell.self))
           {  (row, brand, cell) in
               cell.data = brand
               cell.viewModel = self.viewModel
           }.disposed(by: rxbag)
       }
}


extension BrandViewController{
    private func fetBrands(){
        viewModel.status.accept(ACTIVE)
        viewModel.key_word.accept(key_word)
        
        viewModel.getBrands().subscribe(onNext: { (response) in

            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let brands = Mapper<Brand>().mapArray(JSONObject: response.data) {
    
                    if(brands.count > 0){
                        self.viewModel.dataArray.accept(brands.filter({$0.is_office == DEACTIVE}))
                    }else{
                        self.viewModel.dataArray.accept([])
                    }
                }

            }else{
                dLog(response.message ?? "")						
            }
         
        }).disposed(by: rxbag)
    }
    
        
    
}

	
