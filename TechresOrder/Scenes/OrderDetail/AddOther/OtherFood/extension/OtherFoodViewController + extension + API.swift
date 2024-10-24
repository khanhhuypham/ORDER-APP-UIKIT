
import RxSwift
import RxRelay
import ObjectMapper
import JonAlert
extension OtherFoodViewController{
    func getPrinterList(){
        viewModel.getPrinterList().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
             
                if var printers  = Mapper<Printer>().mapArray(JSONObject: response.data){
                    printers = printers.filter{$0.type == .chef} // Chỉ lấy loại bếp nấu
                    
                    self.viewModel.printers.accept(printers)
                    
                    if printers.count > 0{
                        var otherFood = self.viewModel.otherFood.value
                        otherFood.restaurant_kitchen_place_id = printers[0].id
                        self.viewModel.otherFood.accept(otherFood)
                        self.lbl_printer_name.text = printers[0].name
                    }
                  
                }

            }
        }).disposed(by: rxbag)
        
    }

    func addOtherFoodsToOrder(){
        viewModel.addOtherFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Thêm món thành công...",duration: 2.0)
                self.popViewController()
                
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
            }
         
        }).disposed(by: rxbag)
    }
    
}
