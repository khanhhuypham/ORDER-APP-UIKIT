//
//  CreateFood_rebuildViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 08/11/2023.
//

import UIKit
import TagListView
import Photos
class CreateFoodViewController: BaseViewController {
    
    var viewModel = CreateFoodViewModel()
    var router = CreateFooddRouter()
    /*
         is_addition = DEACTIVE <=> món chính
         is_addition = ACTIVE <=> món bán kèm
     */
    var is_addition = DEACTIVE
    var createFoodModel = CreateFood.init()
    
    var imagecover:[UIImage] = []
    var resources_path:[URL] = []
    var selectedAssets:[PHAsset] = []
    var delegate:TechresDelegate?
    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var scroll_view: UIScrollView!
    
    @IBOutlet weak var food_avatar: UIImageView!


    @IBOutlet weak var textfield_of_food_name: UITextField!
    
    
    @IBOutlet weak var lbl_food_price: UILabel!
    
    @IBOutlet weak var btn_show_category_list: UIButton!
    
    @IBOutlet weak var btn_show_unit_list: UIButton!
    
    //======== Món bán kèm==========
    
    
    @IBOutlet weak var view_of_addition_food: UIView!
    @IBOutlet weak var taglist: TagListView!
    
    @IBOutlet weak var height_of_taglist: NSLayoutConstraint!
    @IBOutlet weak var embeddedDropDown: embeddedDropDown!
    
    //========checkbox bán theo kg==========
    
    @IBOutlet weak var view_of_selling_by_weight: UIView!
    @IBOutlet weak var btn_stick_checkbox_sell_by_weight: UIButton!
    
    //========checkbox thêm vào menu==========
    
    @IBOutlet weak var view_of_adding_to_menu: UIView!
    @IBOutlet weak var btn_stick_checkbox_add_to_menu: UIButton!
    
    //========checkbox trạng thái món ==========
    @IBOutlet weak var view_of_food_status: UIView!
    @IBOutlet weak var btn_stick_checkbox_food_status: UIButton!
    
    //========checkbox giá theo thời vụ ==========
    @IBOutlet weak var btn_stick_checkbox_temporaryPrice: UIButton!
    @IBOutlet weak var view_of_temporary_price: UIView!
    
    
    @IBOutlet weak var lbl_from_date_of_temporary_price: UILabel!
    @IBOutlet weak var lbl_to_date_of_temporary_price: UILabel!
    
    
    @IBOutlet weak var btn_increase_price: UIButton!
    @IBOutlet weak var btn_decrease_price: UIButton!
    
    @IBOutlet weak var btn_enter_increasing_price: UIButton!
    @IBOutlet weak var btn_enter_decreasing_price: UIButton!
    @IBOutlet weak var btn_enter_increasing_percent: UIButton!
    @IBOutlet weak var btn_enter_decreasing_percent: UIButton!
    
    @IBOutlet weak var textfield_enter_increasing_price: UITextField!
    @IBOutlet weak var textfield_enter_decreasing_price: UITextField!
    @IBOutlet weak var textfield_enter_increasing_percent: UITextField!
    @IBOutlet weak var textfield_enter_decreasing_percent: UITextField!
    
    @IBOutlet weak var view_of_enter_increasing_price: UIView!
    @IBOutlet weak var view_of_enter_decreasing_price: UIView!
    @IBOutlet weak var view_of_enter_increasing_percent: UIView!
    @IBOutlet weak var view_of_enter_decreasing_percent: UIView!
    
    //========checkbox in phiếu bếp/bar==========
    @IBOutlet weak var stackview_of_print_chef_bar: UIStackView!
    @IBOutlet weak var btn_stick_checkbox_print_chef_bar: UIButton!
    @IBOutlet weak var btn_show_printer: UIButton!
    @IBOutlet weak var view_of_choosing_printer_list: UIView!
    
    //========checkbox in stamp==========
    
    @IBOutlet weak var btn_stick_checkbox_print_stamp: UIButton!
    
    //========checkbox thuế==========
    
    @IBOutlet weak var btn_stick_checkbox_tax: UIButton!
    @IBOutlet weak var view_of_choosing_tax: UIView!
    @IBOutlet weak var btn_show_vat_list: UIButton!
    
    //========btn cập nhật==========
    @IBOutlet weak var btn_update: UIButton!
    
    var parentView:UIView = UIView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)

        if createFoodModel.id == 0{
            createFoodModel.temporary_price_from_date = TimeUtils.getFullCurrentDate()
            createFoodModel.temporary_price_to_date = TimeUtils.getFullCurrentDate()
            view_of_food_status.isHidden = true
        }
        viewModel.createFoodModel.accept(createFoodModel)
        setupData(createModel:createFoodModel)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object:nil)
        
        
     
        getCategories()
        getUnits()
        getPrinters()
        getVAT()
        getAdditionFoodsManagement()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionChooseAvatar(_ sender: Any) {
        chooseAvatar()
    }
    
    @IBAction func actionShowCalculator(_ sender: Any) {
        presentModalCaculatorInputMoneyViewController(result: viewModel.createFoodModel.value.price)
    }
    
    
    @IBAction func actionShowCategoryList(_ sender: Any) {
        showList(btn: btn_show_category_list,list:viewModel.categoryList.value.map{$0.name})
        /*popupType = 1 <=> danh mục*/
        viewModel.popupType.accept(1)
    }
    
    @IBAction func actionShowUnitList(_ sender: Any) {
        showList(btn: btn_show_unit_list,list:viewModel.unitList.value.map{$0.name})
        /*popupType = 2 <=> đơn vị*/
        viewModel.popupType.accept(2)
    }
    
    
    @IBAction func actionShowPrinterList(_ sender: Any) {
        let model = viewModel.createFoodModel.value
        /*category enum
            "Món ăn":0
            "Đồ uống" : 1
            "Loại khác" : 2
         */
        switch model.category_type {
            
            case 1:
                showList(btn: btn_show_printer,list:viewModel.printerList.value.filter{$0.type == .chef}.map{$0.name})
                break
            
            case 2:
                showList(btn: btn_show_printer,list:viewModel.printerList.value.filter{$0.type == .bar}.map{$0.name})
                break
        
            case 3:
                showList(btn: btn_show_printer,list:viewModel.printerList.value.filter{$0.type == .bar}.map{$0.name})
                break
            
            default:
                showList(btn: btn_show_printer,list:[])
                break
            
        }

//        showList(btn: btn_show_printer,list:viewModel.printerList.value.map{$0.name})
        /*popupType = 3 <=> printer*/
        viewModel.popupType.accept(3)
    }
    
    @IBAction func actionShowTaxList(_ sender: Any) {
        showList(btn: btn_show_vat_list,list:viewModel.vatList.value.map{$0.vat_config_name})
        /*popupType = 4 <=> vat*/
        viewModel.popupType.accept(4)
    }
    
    @IBAction func actionCheckSellByWeight(_ sender: Any) {
        btn_stick_checkbox_sell_by_weight.isSelected =  !btn_stick_checkbox_sell_by_weight.isSelected
        
        var model = viewModel.createFoodModel.value
        model.is_sell_by_weight = btn_stick_checkbox_sell_by_weight.isSelected ? ACTIVE : DEACTIVE
        viewModel.createFoodModel.accept(model)
    }
    
    @IBAction func actionAddToMenu(_ sender: Any) {
        btn_stick_checkbox_add_to_menu.isSelected = !btn_stick_checkbox_add_to_menu.isSelected
        var model = viewModel.createFoodModel.value
        model.is_addition_like_food = btn_stick_checkbox_add_to_menu.isSelected ? ACTIVE : DEACTIVE
        viewModel.createFoodModel.accept(model)
    }
    
    
    @IBAction func actionCheckFoodStatus(_ sender: Any) {
        btn_stick_checkbox_food_status.isSelected = !btn_stick_checkbox_food_status.isSelected
        

        var model = viewModel.createFoodModel.value
        model.status = btn_stick_checkbox_food_status.isSelected ? ACTIVE : DEACTIVE
        viewModel.createFoodModel.accept(model)
    }
    
    
    
    @IBAction func actionCheckTemporaryPrice(_ sender: Any) {
        btn_stick_checkbox_temporaryPrice.isSelected =  !btn_stick_checkbox_temporaryPrice.isSelected
        view_of_temporary_price.isHidden = btn_stick_checkbox_temporaryPrice.isSelected ? false : true
        
        actionChooseIncreasePrice("")
    }
            
    
    @IBAction func actionChooseFromDate(_ sender: UIButton) {
        
        let date = TimeUtils.convertStringToDate(from: viewModel.createFoodModel.value.temporary_price_from_date, format: .dd_mm_yyyy_hh_mm)
        DatePickerUtils.shared.showDatePicker(self,date: date)
        
//        showCalendar(dateString: viewModel.createFoodModel.value.temporary_price_from_date)
        viewModel.dateType.accept(1)
      
    }
    
    @IBAction func actionChooseToDate(_ sender: UIButton) {
        let date = TimeUtils.convertStringToDate(from: viewModel.createFoodModel.value.temporary_price_to_date, format: .dd_mm_yyyy_hh_mm)
        DatePickerUtils.shared.showDatePicker(self,date: date)
    
//        showCalendar(dateString: viewModel.createFoodModel.value.temporary_price_to_date)
        viewModel.dateType.accept(2)
    }
    
    
    @IBAction func actionChooseIncreasePrice(_ sender: Any) {
        btn_increase_price.isSelected = true
        btn_decrease_price.isSelected = false
        view_of_enter_increasing_price.isHidden = false
        view_of_enter_increasing_percent.isHidden = false
        view_of_enter_decreasing_price.isHidden = true
        view_of_enter_decreasing_percent.isHidden = true
    }
    
    @IBAction func actionChooseDecreasePrice(_ sender: Any) {
      
        btn_increase_price.isSelected = false
        btn_decrease_price.isSelected = true
      
        view_of_enter_increasing_price.isHidden = true
        view_of_enter_increasing_percent.isHidden = true
        view_of_enter_decreasing_price.isHidden = false
        view_of_enter_decreasing_percent.isHidden = false
    }
    
    @IBAction func actionSetTemporaryPrice(_ sender: UIButton) {
        /*
         btn_enter_increasing_price - tag = 1
         btn_enter_percent_increase - tag = 2
         btn_enter_decreasing_price - tag = 3
         btn_enter_decreasing_percent - tag = 4
         */
        
        btn_enter_increasing_price.isSelected = false
        btn_enter_increasing_percent.isSelected = false
        btn_enter_decreasing_price.isSelected = false
        btn_enter_decreasing_percent.isSelected = false
        textfield_enter_increasing_price.isUserInteractionEnabled = false
        textfield_enter_increasing_percent.isUserInteractionEnabled = false
        textfield_enter_decreasing_price.isUserInteractionEnabled = false
        textfield_enter_decreasing_percent.isUserInteractionEnabled = false
        
    

        var model = viewModel.createFoodModel.value
        switch sender.tag{
            case 1:
//                model.temporary_percent = 0
//                textfield_enter_increasing_percent.text = ""
                btn_enter_increasing_price.isSelected = true
                textfield_enter_increasing_price.isUserInteractionEnabled = true
                break
                
            case 2:
//                model.temporary_price = 0
//                textfield_enter_increasing_price.text = ""
                btn_enter_increasing_percent.isSelected = true
                textfield_enter_increasing_percent.isUserInteractionEnabled = true
                break
               
            case 3:
//                model.temporary_percent = 0
//                textfield_enter_decreasing_percent.text = ""
                btn_enter_decreasing_price.isSelected = true
                textfield_enter_decreasing_price.isUserInteractionEnabled = true
                break
            
            case 4:
//                model.temporary_price = 0
//                textfield_enter_decreasing_price.text = ""
                btn_enter_decreasing_percent.isSelected = true
                textfield_enter_decreasing_percent.isUserInteractionEnabled = true
                break
            
            default:
                break
        }
        
        viewModel.createFoodModel.accept(model)
    }
    
    
    
    
    @IBAction func actionStickCheckBoxPrintChefBar(_ sender: Any) {
        btn_stick_checkbox_print_chef_bar.isSelected =  !btn_stick_checkbox_print_chef_bar.isSelected
        view_of_choosing_printer_list.isHidden = btn_stick_checkbox_print_chef_bar.isSelected ? false : true

        var model = viewModel.createFoodModel.value
        model.is_allow_print = btn_stick_checkbox_print_chef_bar.isSelected ? ACTIVE : DEACTIVE
        viewModel.createFoodModel.accept(model)
    }
    
    
    
    
    
    
    @IBAction func actionStickCheckBoxPrintStamp(_ sender: Any) {
        btn_stick_checkbox_print_stamp.isSelected =  !btn_stick_checkbox_print_stamp.isSelected
        
        var model = viewModel.createFoodModel.value
        model.is_allow_print_stamp = btn_stick_checkbox_print_stamp.isSelected ? ACTIVE : DEACTIVE
        viewModel.createFoodModel.accept(model)
    }
    
    @IBAction func actionStickCheckBoxTax(_ sender: Any) {
        btn_stick_checkbox_tax.isSelected =  !btn_stick_checkbox_tax.isSelected
        view_of_choosing_tax.isHidden = btn_stick_checkbox_tax.isSelected ? false : true
    }
    
    	
    @IBAction func actionConfirm(_ sender: Any) {
       
    
        isCreateFoodModelValid.take(1).subscribe(onNext: { [self] isValid in
            if isValid {

                var model = viewModel.createFoodModel.value
                if !btn_stick_checkbox_temporaryPrice.isSelected{
                    model.temporary_price = 0
                    model.temporary_percent = 0
                    model.temporary_price_from_date = ""
                    model.temporary_price_to_date = ""
                }
                
                if !btn_stick_checkbox_tax.isSelected{
                    model.restaurant_vat_config_id = 0
                }
                
                model.food_addition_ids = viewModel.additionFoodList.value.filter{$0.is_selected == ACTIVE}.map{$0.id}
                
                viewModel.createFoodModel.accept(model)
                
                //nếu id của item > 0 thì user đang ở chức năng update
                if imagecover.count > 0{
                    callAPIWithAvatar()
                }else{
                    model.id > 0 ? updateFood() : createFood()
                }
            }
        }).disposed(by: rxbag)
        
    }
    
    
    
    @objc private func keyboardWillShow(notification: NSNotification ) {

        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if 
                textfield_enter_increasing_price.isFirstResponder ||
                textfield_enter_increasing_percent.isFirstResponder ||
                textfield_enter_decreasing_price.isFirstResponder ||
                textfield_enter_decreasing_percent.isFirstResponder{
                scroll_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height / 1.35)
            }
            
        }
    }
    
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if 
            textfield_enter_increasing_price.isFirstResponder ||
            textfield_enter_increasing_percent.isFirstResponder ||
            textfield_enter_decreasing_price.isFirstResponder ||
            textfield_enter_decreasing_percent.isFirstResponder{
            scroll_view.transform = .identity
        }
    }
    
}
