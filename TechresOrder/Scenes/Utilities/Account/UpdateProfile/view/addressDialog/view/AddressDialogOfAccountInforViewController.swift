
import UIKit
import RxSwift
import RxRelay
import ObjectMapper
import JonAlert
class AddressDialogOfAccountInforViewController: BaseViewController {
    var viewModel = AddressDialogOfAccountInforViewModel()
    var router = AddressDialogOfAccountInforRouter()
    @IBOutlet weak var text_field_search: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_choose_area: UILabel!
    var delegate:AccountInforDelegate?
    var areaType = ""
    var selectedArea:[String:Area] = [String:Area]()

    
    @IBOutlet weak var height_of_btn_bar: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        registerCell()
        bindTableViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstSetup()
        height_of_btn_bar.constant += Utils.getAreaBottomPadding()
    }
    
    
    private func firstSetup(){
        viewModel.beingSelectedArea.accept(selectedArea)
        switch areaType {
            case "CITY":
                getCitiesList()
                lbl_choose_area.text = "CHỌN THÀNH PHỐ"
                break
            case "DISTRICT":
                getDistrictsList()
                lbl_choose_area.text = "CHỌN QUẬN HUYỆN"
                break
            default:
                getWardList()
                lbl_choose_area.text = "CHỌN PHƯỜNG XÃ"
                break
        }
        
        text_field_search.rx.controlEvent(.editingChanged)
             .withLatestFrom(text_field_search.rx.text)
               .subscribe(onNext:{ [self] query in
                   let cloneAreaDataFilter = viewModel.areaDataFilter.value
                   if !query!.isEmpty{
                       var filteredWarehouseMaterialList = cloneAreaDataFilter.filter({
                           (value) -> Bool in
                           let str1 = query!.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
                           let str2 = value.name.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
                           return str2.contains(str1)
                       })
                       viewModel.areaData.accept(filteredWarehouseMaterialList)
                   }else{
                       viewModel.areaData.accept(cloneAreaDataFilter)
                   }
        }).disposed(by: rxbag)
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {        
        dismiss(animated: true)
    }

    @IBAction func actionConfirm(_ sender: Any) {
        
        var isValid = true
        //Check whether user's selection is valid or not
        
        if(viewModel.beingSelectedArea.value["CITY"]!.id == 0 && viewModel.beingSelectedArea.value["CITY"]!.name == ""){
            showWarningMassage(content: "vui Lòng chọn thêm tỉnh/thành phố")
            isValid = false
        }else if (viewModel.beingSelectedArea.value["DISTRICT"]!.id == 0 && viewModel.beingSelectedArea.value["DISTRICT"]!.name == ""){
            showWarningMassage(content: "vui Lòng chọn thêm quận/huyện")
            isValid = false
        }else if (viewModel.beingSelectedArea.value["WARD"]!.id == 0 && viewModel.beingSelectedArea.value["WARD"]!.name == ""){
            showWarningMassage(content: "vui Lòng chọn thêm phường/xã")
            isValid = false
        }
    
        if(isValid){
            delegate?.callBackToAcceptSelectedArea(selectedArea: viewModel.beingSelectedArea.value)
            dismiss(animated: true)
        }
        
    }
    
}



extension AddressDialogOfAccountInforViewController{
    func registerCell() {
        let cityCell = UINib(nibName: "AddressDialogOfAccountInforTableViewCell", bundle: .main)
        tableView.register(cityCell, forCellReuseIdentifier: "AddressDialogOfAccountInforTableViewCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rx.setDelegate(self).disposed(by: rxbag)
        tableView.rx.modelSelected(Area.self) .subscribe(onNext: { [self] element in
            
            /*The logic is: if user click on the old-area, we will keep the their previous set of areas, else
                user click on new area, we will set the next options to nil (null)
             */
            switch areaType{
                case "CITY":
                    if(element.id != viewModel.beingSelectedArea.value["CITY"]!.id){
                        var cloneBeingSelectedArea = viewModel.beingSelectedArea.value
                        var obj = element
                        obj.is_select = ACTIVE
                        cloneBeingSelectedArea.updateValue(obj, forKey: "CITY")
                        cloneBeingSelectedArea.updateValue(Area()!, forKey: "DISTRICT")
                        cloneBeingSelectedArea.updateValue(Area()!, forKey: "WARD")
                        viewModel.beingSelectedArea.accept(cloneBeingSelectedArea)
                    }
                    areaType = "DISTRICT"
                    lbl_choose_area.text = "CHỌN QUẬN HUYỆN"
                    getDistrictsList()
                  
                    break

                case "DISTRICT":
                    if(element.id != viewModel.beingSelectedArea.value["DISTRICT"]!.id){
                        var cloneBeingSelectedArea = viewModel.beingSelectedArea.value
                        var obj = element
                        obj.is_select = ACTIVE
                        cloneBeingSelectedArea.updateValue(obj, forKey: "DISTRICT")
                        cloneBeingSelectedArea.updateValue(Area()!, forKey: "WARD")
                        viewModel.beingSelectedArea.accept(cloneBeingSelectedArea)
                    }
                    areaType = "WARD"
                    lbl_choose_area.text = "CHỌN PHƯỜNG XÃ"
                    getWardList()
                    break

                default:
                    if(element.id != viewModel.beingSelectedArea.value["WARD"]!.id){
                        var cloneBeingSelectedArea = viewModel.beingSelectedArea.value
                        var obj = element
                        obj.is_select = ACTIVE
                        cloneBeingSelectedArea.updateValue(obj, forKey: "WARD")
                        viewModel.beingSelectedArea.accept(cloneBeingSelectedArea)
                    }
                    reRenderDataArray(dataArray: viewModel.areaData.value, selectedAreaId: element.id)
                    break
            }
        })
        .disposed(by: rxbag)

    }
    
    func bindTableViewData() {
        viewModel.areaData.bind(to: tableView.rx.items(cellIdentifier: "AddressDialogOfAccountInforTableViewCell", cellType: AddressDialogOfAccountInforTableViewCell.self))
        {  (row, area, cell) in
            cell.area = area
        }.disposed(by: rxbag)

    }
    
    private func reRenderDataArray(dataArray:[Area],selectedAreaId:Int){
        var cloneDataArray = dataArray
        if var position = dataArray.firstIndex(where: {data in data.is_select == ACTIVE}){
            cloneDataArray[position].is_select = DEACTIVE
        }
        
        if var position = cloneDataArray.firstIndex(where: {data in data.id == selectedAreaId}){
            cloneDataArray[position].is_select = ACTIVE
        }
        viewModel.areaData.accept(cloneDataArray)
    }
    
    private func showWarningMassage(content:String){
        JonAlert.show(
        message: content ?? "",
        andIcon: UIImage(named: ""),
        duration: 2.0)
    }
    
    
    
}

extension AddressDialogOfAccountInforViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: call API here
extension AddressDialogOfAccountInforViewController{
    func getCitiesList(){
        viewModel.getCitiesList().subscribe(onNext: { [self]
            (response) in
            if (response.code == RRHTTPStatusCode.ok.rawValue){
                if  var dataFromServer = Mapper<Area>().mapArray(JSONObject: response.data){
               
                    if let position = dataFromServer.firstIndex(where: {area in area.id == viewModel.beingSelectedArea.value["CITY"]!.id}){
                        dataFromServer[position].is_select = ACTIVE
                    }
                    viewModel.areaDataFilter.accept(dataFromServer)
                    viewModel.areaData.accept(dataFromServer)
                }
            }else{

                JonAlert.showError(message: response.message ?? "Lỗi kết nối server",duration:2.0)
                
            }
        })
    }
    
    func getDistrictsList(){
        viewModel.getDistrictsList().subscribe(onNext: { [self]
            (response) in
            if (response.code == RRHTTPStatusCode.ok.rawValue){
                if var dataFromServer = Mapper<Area>().mapArray(JSONObject:response.data){
                    if let position = dataFromServer.firstIndex(where: {area in area.id == viewModel.beingSelectedArea.value["DISTRICT"]!.id}){
                        dataFromServer[position].is_select = ACTIVE
                    }
                    viewModel.areaDataFilter.accept(dataFromServer)
                    viewModel.areaData.accept(dataFromServer)
                    
                }
            }else {
                JonAlert.showError(message: response.message ?? "Lỗi kết nối server",duration:2.0)
            }
            
        })
    }
    
    
    func getWardList(){
        viewModel.getWardsList().subscribe(onNext: { [self]
            (response) in
            if(response.code  == RRHTTPStatusCode.ok.rawValue){
                if var dataFromServer = Mapper<Area>().mapArray(JSONObject:response.data){
                    
                    if let position = dataFromServer.firstIndex(where: {area in area.id == viewModel.beingSelectedArea.value["WARD"]!.id}){
                        dataFromServer[position].is_select = ACTIVE
                    }
                    viewModel.areaDataFilter.accept(dataFromServer)
                    viewModel.areaData.accept(dataFromServer)
                }
            }else {
                JonAlert.showError(message: response.message ?? "Lỗi kết nối server",duration:2.0)
            }
        })
    }
    
}
