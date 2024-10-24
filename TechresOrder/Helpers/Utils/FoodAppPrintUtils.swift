//
//  FoodAppPrintUtils.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/08/2024.
//

import UIKit
import RxSwift
import ObjectMapper
import AVFoundation

class FoodAppPrintUtils:NSObject {
    var player: AVAudioPlayer?
    
    let rxbag = DisposeBag()
    
    var foodApptTimer: Timer?
    
    var refreshFoodApptTimer: Timer?
    
    var isProcessing:Bool = false
    
    static let shared: FoodAppPrintUtils = {
        let foodAppPrintUtils = FoodAppPrintUtils()
        return foodAppPrintUtils
    }()
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self,selector:#selector(printFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.ERROR_FROM_PRINT_FUNCTION_OF_FOOD_APP),object: nil)
    }
    
    deinit{
        foodApptTimer?.invalidate()
        foodApptTimer = nil
        
        refreshFoodApptTimer?.invalidate()
        refreshFoodApptTimer = nil
        
        NotificationCenter.default.removeObserver(self)
        
    }
    @objc func printFail(_ notification: Notification){
        isProcessing = false
    }

}


extension FoodAppPrintUtils {
    
    func performPrintOrderForFoodAppOnBackground(){

        if permissionUtils.GPBH_1 || permissionUtils.GPBH_2_o_1 {
            
            foodApptTimer?.invalidate()
            foodApptTimer = nil
            isProcessing = false
            foodApptTimer = Timer.scheduledTimer(withTimeInterval:10, repeats: true) { [weak self] _ in
                dLog(self?.isProcessing)
                if let _ = self?.getTopUIViewcontroller(){
                    if (self?.isProcessing ?? false) == false && Constants.isLogin{
                        self?.getOrderListOfFoodApp()
                    }
                }
            }
                
            refreshFoodApptTimer?.invalidate()
            refreshFoodApptTimer = nil
            refreshFoodApptTimer = Timer.scheduledTimer(withTimeInterval:60*30, repeats: true) { [weak self] _ in
                self?.getConformedOrderListOfFoodApp()
            }
        }
    }
    
    
    func stopPrintOrderForFoodAppOnBackground(){
        foodApptTimer?.invalidate()
        foodApptTimer = nil
        
        refreshFoodApptTimer?.invalidate()
        refreshFoodApptTimer = nil
        isProcessing = false
    }
    
  
}

//MARK: call api
extension FoodAppPrintUtils {
    
    private func getOrderListOfFoodApp(){
        appServiceProvider.rx.request(.getOrderListOfFoodApp(
            isAppFood: ACTIVE,
            branch_id: Constants.branch.id,
            restaurant_id: Constants.restaurant_id,
            area_id: ALL,
            is_have_restaurant_order: DEACTIVE,
            channel_order_food_id: ALL,
            restaurant_brand_id: Constants.brand.id,
            customer_order_status: "0,8")
        )
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { (response) in
            
            self.isProcessing = true
            
            if let res = Mapper<FoodAppOrderResponse>().map(JSONObject: response.data){

              
                if !res.list.isEmpty && self.getTopUIViewcontroller() != nil{
                    self.confirmOrdersOfFoodApp(ids: res.list.map{$0.id})
                }else{
                    self.isProcessing = false
                }
              
                
            }else{
                dLog(response.message)
                self.isProcessing = false
            }
            
        }).disposed(by: rxbag)
    }
    

            
    private func confirmOrdersOfFoodApp(ids:[Int]){
        appServiceProvider.rx.request(.postBatchConfirmOrderOfFoodApp(branch_id: Constants.branch.id, ids: ids))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self).subscribe(onNext: { (response) in
                dLog(response)
              if let items = Mapper<FoodAppOrder>().mapArray(JSONObject: response.data){

                  
                  if let topVc = self.getTopUIViewcontroller(){
                      
//                      dLog(items.count)
//                      var count = 0
//                      for item in items.map{$0.details}{
//                          count += item.count
//                      }
//                      dLog(count)
                  
                      self.playSound()
                      PrinterUtils.shared.PrintFoodAppItems(
                          presenter:topVc,
                          isCustomerOrder:true,
                          printers:Constants.printers.filter{$0.type == .cashier_of_food_app || $0.type == .stamp_of_food_app},
                          orders:items,
                          completetHandler: {
                              self.isProcessing = false
                          }
                      )

                      
                  }else{

                      self.isProcessing = false
                  }
              }else{
                  self.isProcessing = false
              }

            }).disposed(by: rxbag)
        
    }

    
    
    private func getTopUIViewcontroller() -> UIViewController?{
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if !topController.isKind(of: FoodAppPrintFormatViewController.self) ||
                !topController.isKind(of: OrderItemPrintFormatViewController.self) ||
                !topController.isKind(of: ReceiptPrintFormatViewController.self) ||
                !topController.isKind(of: UIAlertController.self)
            {
                return topController
            }
        
        // topController should now be your topmost view controller
        }
        return nil
    }
    
    func isPrinterOfFoodAppValid() -> Bool{
        
        
        if let topVc = self.getTopUIViewcontroller(){
            let printers = Constants.printers.filter{$0.type == .cashier_of_food_app || $0.type == .stamp_of_food_app}
            
            if printers.filter{$0.is_have_printer == ACTIVE}.isEmpty{
                topVc.showAleartViewwithTitle("Cảnh báo", message:"Không tìm thấy máy in đang hoạt động cho chức năng In hóa đơn hoặc In nhãn dán của App Food",withAutoDismiss: true)
                self.isProcessing = false
                return false
            }else{
                return true
            }
        }else{
            self.isProcessing = false
            return false
        }
        
    }
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "app_food_noti", withExtension: "caf") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.caf.rawValue)

                /* iOS 10 and earlier require the following line:
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

                guard let player = player else { return }

                player.play()

            } catch let error {
                print(error.localizedDescription)
            }
        
        
    }

}



//MARK: call api refresh order
extension FoodAppPrintUtils {
    
    func getConformedOrderListOfFoodApp(){
        appServiceProvider.rx.request(.getOrderListOfFoodApp(
            isAppFood: -1,
            branch_id: Constants.branch.id,
            restaurant_id: Constants.restaurant_id,
            area_id: ALL,
            is_have_restaurant_order: ACTIVE,
            channel_order_food_id: ALL,
            restaurant_brand_id: Constants.brand.id,
            customer_order_status: "0,8")
        )
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { (response) in

            if let res = Mapper<FoodAppOrderResponse>().map(JSONObject: response.data){
                
                self.postRefreshOrderOfFoodApp(channelOrders:res.list)
            }
        
        }).disposed(by: rxbag)
    }
    
    private func postRefreshOrderOfFoodApp(channelOrders:[FoodAppOrder]){
        
        var items:[[String:Any]] = []
        
        for order in channelOrders{
            items.append([
                "id":order.id,
                "channel_order_food_id": order.channel_order_food_id,
                "channel_order_code": order.channel_order_code,
                "channel_order_id": order.channel_order_id
            ])
        }
        
        appServiceProvider.rx.request(.postRefreshOrderOfFoodApp(
            restaurant_id:Constants.restaurant_id,
            restaurant_brand_id:Constants.brand.id,
            branch_id:Constants.branch.id,
            channel_orders:items
        ))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { (response) in
            

            
        }).disposed(by: rxbag)
    }

}
