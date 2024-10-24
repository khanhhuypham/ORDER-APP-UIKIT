//
//  DialogChooseTableViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/01/2024.
//


import UIKit
import SNCollectionViewLayout
import ObjectMapper
import MSPeekCollectionViewDelegateImplementation
import JonAlert

class DialogChooseTableViewController: BaseViewController {
    var viewModel = DialogChooseTableViewModel()

 
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var areacollectionView: UICollectionView!
    
    @IBOutlet weak var view_hint: UIView!
    @IBOutlet weak var tableCollectionView: UICollectionView!
    @IBOutlet weak var btn_confirm: UIButton!
    
    @IBOutlet weak var view_no_data: UIView!
    
    var order:Order = Order()!
    var delegate:TechresDelegate?
    var moveTableDelegate:OrderMoveFoodDelegate?
    var option:OrderAction = .moveTable
    
    
    
    var isSplittingSingleItem:Int = DEACTIVE // BIến này chỉ dành cho chức năng tách món
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        viewModel.bind(view: self)
        viewModel.order.accept(order)
        firsSetUp()
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAreas()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        if viewModel.isAPICalling.value{
            return
        }
      
        switch self.option{
           
            case .mergeTable:
                var target_table_ids = [Int]()
                viewModel.table_array.value.enumerated().forEach { (index, value) in
                    if(value.is_selected == 1){
                        target_table_ids.append(value.id)
                    }
                }
                
                self.mergeTable(target_table_ids:target_table_ids)
            

            case .splitFood:
                break
            default:
                break
            
        }
    
       
    }
    
    private func firsSetUp(){
        switch option {
         
            case .moveTable:
                lbl_title.text = String(format: "CHUYỂN TỪ BÀN %@ SANG", order.table_name).uppercased()
                btn_confirm.isHidden = true
                view_hint.isHidden = true
                viewModel.status.accept(String(format: "%d", STATUS_TABLE_CLOSED))
                break
            
            case .mergeTable:
                lbl_title.text = String(format: "GỘP BÀN %@ ", order.table_name).uppercased()
                btn_confirm.isHidden = false
                view_hint.isHidden = false
                viewModel.status.accept(String(format: "%d,%d,%d", STATUS_TABLE_CLOSED, STATUS_TABLE_USING, STATUS_TABLE_BOOKING))
                break
            
            case .splitFood:
                lbl_title.text = String(format: "TÁCH MÓN TỪ BÀN %@ SANG", order.table_name).uppercased()
                btn_confirm.isHidden = true
                view_hint.isHidden = false
                viewModel.status.accept(String(format: "%d,%d,%d", STATUS_TABLE_CLOSED, STATUS_TABLE_USING, STATUS_TABLE_BOOKING))
                break
            
            
            case .cancelOrder:
                break
        
        default:
            break
        }
        
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
    
    private func setupAreaCollectionView(){
        registerTableCollectionViewCell()
        binđDataTableCollectionView()
    }
    
    
    private func setupTableCollectionView(){
        registerAreaCell()
        binđDataAreaCollectionView()
    }
}



//MARK: This Part of extension is to register cell for tableCollectionView and bind data
extension DialogChooseTableViewController:SNCollectionViewLayoutDelegate{
    
    func registerTableCollectionViewCell(){
        let tableCollectionViewCell = UINib(nibName: "DialogChooseTableCollectionViewCell", bundle: .main)
        tableCollectionView.register(tableCollectionViewCell, forCellWithReuseIdentifier: "DialogChooseTableCollectionViewCell")
 
        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 4 // Columns for .vertical, rows for .horizontal
        tableCollectionView.collectionViewLayout = snCollectionViewLayout
        
        tableCollectionView.rx.modelSelected(Table.self) .subscribe(onNext: { element in
            
            dLog(element.toJSON())
            switch self.option{
                case .moveTable,.splitFood:
                    var table = Table()
                    table.id = self.order.table_id
                    table.name = self.order.table_name
                    self.presentModalConfirmMoveTableViewController(destinationTable: table,targetTable: element)
                case .mergeTable:
                
                    var tables = self.viewModel.table_array.value
                    tables.enumerated().forEach { (index, value) in
                        if(element.id == value.id){
                            tables[index].is_selected = element.is_selected == DEACTIVE ? ACTIVE : DEACTIVE
                        }
                    }
                    self.viewModel.table_array.accept(tables)
                    break
                
              
                default:
                    break
                
            }
            
        }).disposed(by: rxbag)
    }
    
    
    func binđDataTableCollectionView(){
        viewModel.table_array.bind(to: tableCollectionView.rx.items(cellIdentifier: "DialogChooseTableCollectionViewCell", cellType: DialogChooseTableCollectionViewCell.self))
        { (index, element, cell) in
            cell.option = self.option
            cell.data = element
         }.disposed(by: rxbag)
    }

    
    
}


//MARK: This Part of extension is to register cell for areacollectionView and bind data and implement some method of protocol
extension DialogChooseTableViewController:UICollectionViewDelegate{
    
    func registerAreaCell(){
        let areaCollectionViewCell = UINib(nibName: "AreaCollectionViewCell", bundle: .main)
        areacollectionView.register(areaCollectionViewCell, forCellWithReuseIdentifier: "AreaCollectionViewCell")
        areacollectionView.delegate = self
    
        areacollectionView.rx.modelSelected(Area.self).subscribe(onNext: { element in
       
            var areas = self.viewModel.area_array.value
            areas.enumerated().forEach { (index, value) in
                areas[index].is_select = element.id == value.id ? ACTIVE : DEACTIVE
            }
            self.viewModel.area_array.accept(areas)
            self.getTables(areaId: element.id)
        
        }).disposed(by: rxbag)

    }
    
    
    func binđDataAreaCollectionView(){
        viewModel.area_array.bind(to: areacollectionView.rx.items(cellIdentifier: "AreaCollectionViewCell", cellType: AreaCollectionViewCell.self)) { (index, element, cell) in
           
            dLog(cell.isSelected)
            cell.data = element
         }.disposed(by: rxbag)
    }
    
    func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return UICollectionViewFlowLayout.automaticSize
    }

}


