//
//  AddFood_RebuildViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/09/2023.
//

import UIKit
import RxRelay
import RxSwift
import RxDataSources


class AddFoodViewController: BaseViewController {
    var viewModel = AddFoodViewModel()
    var router = AddFoodRouter()
    var order:OrderDetail = OrderDetail.init()

    var is_gift = -1 // 0 = gọi món bình thường | 1 = Tặng món vào hoá đơn| -1 Cả hai
    let refreshControl = UIRefreshControl()
    

    @IBOutlet weak var view_category: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var textfield_search: UITextField!

    @IBOutlet weak var view_btn_filter_food: UIView!
    @IBOutlet weak var view_btn_filter_buffet_ticket: UIView!
    @IBOutlet weak var view_btn_buffet: UIView!
    @IBOutlet weak var view_btn_filter_drink: UIView!
    @IBOutlet weak var view_btn_filter_other: UIView!
    @IBOutlet weak var view_btn_filter_service: UIView!
    @IBOutlet weak var view_btn_filter_cancel_food: UIView!
    
    @IBOutlet weak var btnFilterFood: UIButton!
    @IBOutlet weak var btnFilterDrink: UIButton!
    @IBOutlet weak var btnFilterService: UIButton!
    @IBOutlet weak var btnBuffetTicket: UIButton!
    @IBOutlet weak var btnFilterOther: UIButton!
    @IBOutlet weak var btnFilterCancelFood: UIButton!
    @IBOutlet weak var view_nodata_order: UIView! // hiển thị icon không có dữ liệu
    @IBOutlet weak var containerButtonView: UIView!
    @IBOutlet weak var heightOfContainerBtnView: NSLayoutConstraint!

  
    var underlineView:UIView = UIView()
    
    var spinner = UIActivityIndicatorView(style: .medium){
        didSet{
            spinner.color = ColorUtils.blue_brand_700()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tableView.bounds.width, height: CGFloat(55))
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewModel.bind(view: self, router: router)
        viewModel.order.accept(order)
        

        registerCellAndBindTableView()
        bindViewModel()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstSetup()

    }
    
    
    private func firstSetup(){
        /*
            Chỉ duy nhất 1 trường hợp là bàn booking mà ở trạng thái đã set up thì chỉ được order món nước và khác, các trường hợp còn lại thì thực hiện actionFilterFood
         */
        lbl_header.text = String(format: is_gift == ACTIVE ? "TẶNG MÓN - %@" : "GỌI MÓN - %@", viewModel.order.value.table_name)
        view_category.isHidden = true

        /*
            tab dịch vụ chỉ hiển thị đối với GPBH2 trở lên
            tab buffet chỉ hiển thị đối với GPBH2 trở lên
         */
        if permissionUtils.GPBH_1 {
            view_btn_filter_cancel_food.isHidden = true
            view_btn_filter_service.isHidden = true
            view_btn_buffet.isHidden = true
            view_btn_filter_buffet_ticket.isHidden = true
        }else if permissionUtils.GPBH_2 || permissionUtils.GPBH_3{
            
            view_btn_buffet.isHidden = permissionUtils.is_enale_buffet ? false : true
            

            if let buffet = order.buffet{
                view_btn_filter_buffet_ticket.isHidden = false
                btnBuffetTicket.setTitle(buffet.buffet_ticket_name, for: .normal)
            }else{
                view_btn_filter_buffet_ticket.isHidden = true
            }
            
            
            
            if is_gift == ACTIVE{
                var APIParameter = viewModel.APIParameter.value
                APIParameter.is_allow_employee_gift = is_gift
                viewModel.APIParameter.accept(APIParameter)
                view_btn_filter_buffet_ticket.isHidden = true
                view_btn_buffet.isHidden = true
            }
            
            
            if viewModel.order.value.table_id == 0{//take away
                view_btn_buffet.isHidden = true
                view_btn_filter_buffet_ticket.isHidden = true
            }
            
        }

        if viewModel.order.value.booking_status == STATUS_BOOKING_SET_UP {
            addUnderLineView(btn: btnFilterDrink)
            actionFilterDrink(btnFilterDrink)
            view_btn_filter_food.isHidden = true
            view_btn_filter_other.isHidden = false
            view_btn_filter_service.isHidden = true
            view_btn_buffet.isHidden = true
        }else{
            actionFilterAllFood()
        }
            
        
        textfield_search.rx.controlEvent(.editingChanged)
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .withLatestFrom(textfield_search.rx.text)
            .subscribe(onNext:{ [self]  query in
                       
                       self.viewModel.clearData()
                       
                       var APIParameter = viewModel.APIParameter.value
                       APIParameter.key_word = query ?? ""
                       viewModel.APIParameter.accept(APIParameter)
         
                        switch APIParameter.category_type{
                            
                            case.buffet_ticket:
                                getBuffetTickets()
                            
                            default:
                                healthCheckForFood()
                        }

        }).disposed(by: rxbag)
    }
    
    private func bindViewModel() {
        viewModel.isValidDataArray
            .subscribe({ [weak self] isValid in
                guard let strongSelf = self, let isValid = isValid.element else { return }
                if isValid {
                    strongSelf.containerButtonView.isHidden = false
                    strongSelf.heightOfContainerBtnView.constant = 80
                } else {
                    strongSelf.containerButtonView.isHidden = true
                    strongSelf.heightOfContainerBtnView.constant = 0
                }
        }).disposed(by: rxbag)
    }


    private func actionFilterAllFood(){
        var APIParameter = viewModel.APIParameter.value
        APIParameter.category_type = .all
        APIParameter.is_out_stock = ALL
        APIParameter.is_sell_by_weight = ALL
        APIParameter.key_word = ""
        viewModel.APIParameter.accept(APIParameter)
    
        textfield_search.text = APIParameter.key_word
        viewModel.clearData()
        
        healthCheckForFood()
    }
    
    
    @IBAction func actionFilterDetailOFBuffetTicket(_ sender: UIButton) {
        
        guard let buffet = order.buffet else {
            return
        }
        
        var APIParameter = viewModel.APIParameter.value
        APIParameter.category_type = .food
        APIParameter.is_out_stock = ALL
        APIParameter.is_sell_by_weight = ALL
        viewModel.APIParameter.accept(APIParameter)
        view_category.isHidden = true
        viewModel.clearData()
        addUnderLineView(btn: sender)
        healthCheckForBuffet(buffet: buffet)
    }
    
    @IBAction func actionFilterService(_ sender: UIButton) {
        var APIParameter = viewModel.APIParameter.value
        APIParameter.category_type = .service
        APIParameter.is_out_stock = ALL
        APIParameter.is_sell_by_weight = ALL
        APIParameter.key_word = ""
        viewModel.APIParameter.accept(APIParameter)
        addUnderLineView(btn: sender)
        textfield_search.text = APIParameter.key_word
        view_category.isHidden = false
        viewModel.clearData()
        healthCheckForFood()
       
    }
    
    @IBAction func actionFilterFood(_ sender: UIButton) {
        
        var APIParameter = viewModel.APIParameter.value
        APIParameter.category_type = .food
        APIParameter.is_out_stock = ALL
        APIParameter.is_sell_by_weight = ALL
        APIParameter.key_word = ""
        viewModel.APIParameter.accept(APIParameter)
        addUnderLineView(btn: sender)
        textfield_search.text = APIParameter.key_word
        view_category.isHidden = false
        viewModel.clearData()
        healthCheckForFood()


    }
    
    

    
   
    @IBAction func actionFilterDrink(_ sender: UIButton) {
        
        var APIParameter = viewModel.APIParameter.value
        APIParameter.category_type = .drink
        APIParameter.is_out_stock = ALL
        APIParameter.is_sell_by_weight = ALL
        APIParameter.key_word = ""
        viewModel.APIParameter.accept(APIParameter)
        addUnderLineView(btn: sender)
        textfield_search.text = APIParameter.key_word
        view_category.isHidden = false
        self.viewModel.clearData()
        healthCheckForFood()
    
    }
    
    
    @IBAction func actionFilterOther(_ sender: UIButton) {
        
        var APIParameter = viewModel.APIParameter.value
        APIParameter.category_type = .other
        APIParameter.is_out_stock = ALL
        APIParameter.is_sell_by_weight = ALL
        APIParameter.key_word = ""
        viewModel.APIParameter.accept(APIParameter)
        addUnderLineView(btn: sender)
        textfield_search.text = APIParameter.key_word
        self.viewModel.clearData()
        healthCheckForFood()
        view_category.isHidden = false
    }

    
    @IBAction func actionFilterCancelFood(_ sender: UIButton) {
        var APIParameter = viewModel.APIParameter.value
        APIParameter.category_type = .all
        APIParameter.is_out_stock = ACTIVE
        APIParameter.is_sell_by_weight = ALL
        APIParameter.key_word = ""
        viewModel.APIParameter.accept(APIParameter)
        addUnderLineView(btn: sender)
        textfield_search.text = APIParameter.key_word
        self.viewModel.clearData()
        healthCheckForFood()
        view_category.isHidden = true
    }
    
    @IBAction func actionFilterBuffet(_ sender: UIButton) {
        view_category.isHidden = true
    
        var APIParameter = viewModel.APIParameter.value
        APIParameter.category_type = .buffet_ticket
        viewModel.APIParameter.accept(APIParameter)
        self.viewModel.clearData()
        addUnderLineView(btn: sender)
        getBuffetTickets()
    }
    
    
    
    @IBAction func actionSave(_ sender: Any) {
 
        viewModel.order.value.id > 0
        ?  proccessAddFoodToOrder()
        :  createOrder(order: viewModel.order.value)

    }
    
    func proccessAddFoodToOrder(){
        
        if var buffetTiket = viewModel.selectedBuffet.value{
            
            if buffetTiket.ticketChildren.isEmpty{
                buffetTiket.adult_quantity = buffetTiket.quantity
            }else{
                for ticket in  buffetTiket.ticketChildren{
                    if ticket.ticketType == .adult{
                        buffetTiket.adult_quantity = ticket.quantity
                    }else if ticket.ticketType == .children {
                        buffetTiket.child_quantity = ticket.quantity
                    }
                }
            }

            createBuffetTicket(buffet: buffetTiket)
        }
        
        
        if !viewModel.selectedFoods.value.isEmpty{
        
            let items = viewModel.selectedFoods.value.map{(food) in
                var food_request = FoodRequest.init()
                food_request.id = food.id
                food_request.quantity = food.quantity
                food_request.note = food.note
                food_request.discount_percent = food.discount_percent
                //CHECK ADDITION FOOD
                food_request.addition_foods = food.addition_foods.filter{$0.is_selected == ACTIVE && $0.quantity > 0}
                // CHECK MUA 1 TANG 1
                food_request.buy_one_get_one_foods = food.food_list_in_promotion_buy_one_get_one.filter{$0.is_selected == ACTIVE && $0.quantity > 0}
                
                if food.quantity == 0{
                    dLog(food.name)
                }
                
                return food_request
            }
    
            is_gift == ADD_GIFT ? addGiftFoodsToOrder(items:items) : addFoodsToOrder(items:items)
        }
        
      
        
        
      
    }
    
 
    
    @IBAction func actionCancel(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    
    private func addUnderLineView(btn:UIButton){
        underlineView.removeFromSuperview()
        underlineView = UIView(frame: CGRect(x: 0, y: btn.frame.height - 4, width: btn.frame.size.width, height: 4))
        underlineView.backgroundColor = ColorUtils.orange_brand_900()
        btn.addSubview(underlineView)
    }

}
