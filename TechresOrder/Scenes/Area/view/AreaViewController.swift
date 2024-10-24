//
//  AreaViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import SNCollectionViewLayout
import ObjectMapper
import MSPeekCollectionViewDelegateImplementation
import JonAlert


class AreaViewController: BaseViewController {
    var viewModel = AreaViewModel()
    private var router = AreaRouter()

    
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var areaStackView: UIStackView!
    @IBOutlet weak var areaStackViewItem4: UIView!
    @IBOutlet weak var areaStackViewItem3: UIView!
    @IBOutlet weak var areaStackViewItem2: UIView!
    @IBOutlet weak var areaStackViewItem1: UIView!
    @IBOutlet weak var areacollectionView: UICollectionView!
    

    @IBOutlet weak var point_view: UIStackView!

    @IBOutlet weak var lbl_target_amount: UILabel!
    @IBOutlet weak var lbl_target_point: UILabel!
    @IBOutlet weak var tableCollectionView: UICollectionView!
    
    @IBOutlet weak var view_no_data: UIView!
    
    
    @IBOutlet weak var block_view: UIView!
    @IBOutlet weak var image_block: UIImageView!
    @IBOutlet weak var lbl_content_of_block_view: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        viewModel.bind(view: self, router: router)

        setupAreaCollectionView()
        setupTableCollectionView()
       
   
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableCollectionView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.getAreas()
        refreshControl.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        

      
        if permissionUtils.GPBH_1{
            point_view.isHidden = true
            isBlockViewHidden(true)
            getAreas()
            
        }else if permissionUtils.GPBH_2 || permissionUtils.GPBH_3 {
            
            if permissionUtils.GPBH_2_o_3 {
                isBlockViewHidden(false,icon: UIImage(named: "icon-locked-function"),content: "Giải pháp bán hàng bạn đang sử dụng chỉ có thể order trên máy Thu Ngân")
                return
            }
            
            point_view.isHidden = true
        
            if permissionUtils.GPQT_2_and_above {
            
                if !permissionUtils.Checking {//if user hasn't yet checked in
                    isBlockViewHidden(false,icon: UIImage(named: "img-no-data"),content: "Vui lòng Check-in để sử dụng cách tính năng của app Order")
                    return
                }
                
                getCurrentPoint(employee_id: ManageCacheObject.getCurrentUser().id)
                point_view.isHidden = true
            }
            
            isBlockViewHidden(true)
            getAreas()
            
        }
        
        
        
        lbl_target_point.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_target_point))
        lbl_target_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_bonus_salary))
    }
    
    
    private func isBlockViewHidden(_ isHidden:Bool,icon:UIImage? = nil,content:String? = nil){

        block_view.isHidden = isHidden
        if icon != nil && content != nil{
            image_block.image = icon
            lbl_content_of_block_view.text = content
        }
    }
    

    private func setupAreaCollectionView(){
        NSLayoutConstraint.activate([
            self.areaStackViewItem1.widthAnchor.constraint(equalTo: self.areaStackView.widthAnchor, multiplier: 0.25),
            self.areaStackViewItem2.widthAnchor.constraint(equalTo: self.areaStackView.widthAnchor, multiplier: 0.27),
            self.areaStackViewItem3.widthAnchor.constraint(equalTo: self.areaStackView.widthAnchor, multiplier: 0.24),
            self.areaStackViewItem4.widthAnchor.constraint(equalTo: self.areaStackView.widthAnchor, multiplier: 0.24)
        ])
        registerTableCollectionViewCell()
        binđDataTableCollectionView()
    }
    
    
    private func setupTableCollectionView(){
        registerAreaCell()
        binđDataAreaCollectionView()
    }
}





//MARK: This Part of extension is to register cell for tableCollectionView and bind data
extension AreaViewController:SNCollectionViewLayoutDelegate{
    
    func registerTableCollectionViewCell(){
        let tableCollectionViewCell = UINib(nibName: "TableCollectionViewCell", bundle: .main)
        tableCollectionView.register(tableCollectionViewCell, forCellWithReuseIdentifier: "TableCollectionViewCell")
 
        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 4 // Columns for .vertical, rows for .horizontal
        tableCollectionView.collectionViewLayout = snCollectionViewLayout
        
        tableCollectionView.rx.modelSelected(Table.self) .subscribe(onNext: { element in
            
            
            if(element.order_status == ORDER_STATUS_WAITING_WAITING_COMPLETE){
                self.showWarningMessage(content: "Đơn hàng đang chờ thu tiền bạn không được phép thao tác.")
            }else if(element.status == STATUS_TABLE_MERGED){
                let message = String(format: "Bàn %@ đang được gộp với bàn %@. Bạn có muốn đóng bàn %@ hay không?", element.name, element.merge_table_name, element.name)
                self.presentModalDialogConfirmViewController(dialog_type: DEACTIVE, title: "XÁC NHẬN ĐÓNG BÀN ĐANG GỘP", content: message)
                self.viewModel.table_id.accept(element.id)
            }else if(element.status == STATUS_TABLE_BOOKING){
                self.showWarningMessage(content: "Bàn đang có khách đặt trước bạn không được phép thao tác.")
            }else{
                if(element.order_id > 0){
                    self.viewModel.makeOrderDetailViewController(table: element)
                }else{
                    self.viewModel.makeNavigatorAddFoodViewController(table: element)
                }
            }
        }).disposed(by: rxbag)
    }
    
    
    func binđDataTableCollectionView(){
        viewModel.table_array.bind(to: tableCollectionView.rx.items(cellIdentifier: "TableCollectionViewCell", cellType: TableCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }

    
    
}


//MARK: This Part of extension is to register cell for areacollectionView and bind data and implement some method of protocol
extension AreaViewController:UICollectionViewDelegate{
    
    func registerAreaCell(){
        let areaCollectionViewCell = UINib(nibName: "AreaCollectionViewCell", bundle: .main)
        areacollectionView.register(areaCollectionViewCell, forCellWithReuseIdentifier: "AreaCollectionViewCell")
        areacollectionView.delegate = self
    
        areacollectionView.rx.modelSelected(Area.self).subscribe(onNext: { element in
       
            let array = self.viewModel.area_array.value.map{(value) in
                var area = value
                area.is_select = element.id == value.id ? ACTIVE : DEACTIVE
                return area
            }
            self.viewModel.area_array.accept(array)
            self.getTables(areaId: element.id)
        
        }).disposed(by: rxbag)

    }
    
    
    func binđDataAreaCollectionView(){
        viewModel.area_array.bind(to: areacollectionView.rx.items(cellIdentifier: "AreaCollectionViewCell", cellType: AreaCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
    
    func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return UICollectionViewFlowLayout.automaticSize
    }

}
