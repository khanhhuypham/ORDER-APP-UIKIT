//
//  BaseViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import Moya
import ObjectMapper

class BaseViewModel {
    // Dispose Bag
        public var medias : BehaviorRelay<[Media]> = BehaviorRelay(value: [])
        public var upload_request : BehaviorRelay<[MediaRequest]> = BehaviorRelay(value: [])
        public var areaId : BehaviorRelay<Int> = BehaviorRelay(value: -1)
        
    

        var isMessageShowing  = BehaviorRelay<Bool>(value: false)
        // Dispose Bag
        let disposeBag = DisposeBag()
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data",
            "Method": "\(Constants.METHOD_TYPE.POST)",
            "ProjectId": String(Constants.PROJECT_IDS.PROJECT_UPLOAD_SERVICE),
            "Authorization":" Bearer \(ManageCacheObject.getCurrentUser().access_token)"
        ]

        let successHandler: ((AFDataResponse<Any>) -> Void)? = {res in
            dLog(res)
        }

        let errorHandler: ((Error) -> Void)? = {err in
            dLog(err)
        }

        let progressHandler: ((Double) -> Void)? = {err in
            dLog(err)
        }
        
    }

extension BaseViewModel{
    func getCurrentPoint(employee_id:Int) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.currentPoint(employee_id: employee_id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
   
}


// ========== HANDLE UPLOAD MEDIA ==========
extension BaseViewModel{
    func getGenerateFile() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.generateFileNameResource(medias: medias.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }

    func uploadImageWidthAlamofire(){
            self.uploadWithData(serverUrl: URL(string: String(format: "%@%@",APIEndPoint.GATEWAY_SERVER_URL, "/api/v2/media/upload/"))!, headers: headers, progressing: progressHandler, success: successHandler, failure: errorHandler)
    }
    

    
    func getPrintItemFromOrder(orderId:Int) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.foodsNeedPrint(order_id: orderId))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func getOrderDetail(orderId:Int) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.order(order_id: orderId, branch_id: ManageCacheObject.getCurrentBranch().id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
        
}

extension BaseViewModel {
    func uploadWithData(serverUrl: URL, headers: HTTPHeaders, progressing: ((Double) -> Void)?, success:  ((AFDataResponse<Any>) -> Void)?, failure: ((Error) -> Void)?)  {
        dLog("\(serverUrl.absoluteString)")
        let upload_requests = upload_request.value
        
            AF.upload(multipartFormData: { (multipartData) in
                for i in 0 ..< upload_requests.count{
                    dLog("Upload Request Data: \(upload_requests[i].toJSON())")

                  
                    if(upload_requests[i].type == 1){
                        do {
                            multipartData.append(upload_requests[i].video_path!, withName:String(format: "medias[%d][file]", i), fileName: upload_requests[i].name!, mimeType: "file")
                            multipartData.append(upload_requests[i].media_id!.data(using: .utf8)!, withName:String(format: "medias[%d][media_id]", i))
                            multipartData.append(String(format: "%d", upload_requests[i].type!).data(using: .utf8)!, withName: String(format: "medias[%d][type]", i))
                            dLog(multipartData)
                            } catch {
                                debugPrint("Couldn't get Data from URL: \(String(describing: upload_requests[i].video_path)): \(error)")
                            }
  
                    }else if(upload_requests[i].type == 3){
                        do {
                            multipartData.append(upload_requests[i].video_path!, withName:String(format: "medias[%d][file]", i), fileName: upload_requests[i].name!, mimeType: "file")
                            multipartData.append(upload_requests[i].media_id!.data(using: .utf8)!, withName:String(format: "medias[%d][media_id]", i))
                            multipartData.append(String(format: "%d", upload_requests[i].type!).data(using: .utf8)!, withName: String(format: "medias[%d][type]", i))
                            dLog(multipartData)
                            } catch {
                                debugPrint("Couldn't get Data from URL: \(String(describing: upload_requests[i].video_path)): \(error)")
                            }
  
                    }
                    else{
                        if let imageData = upload_requests[i].image?.pngData(){
                            multipartData.append(imageData, withName:String(format: "medias[%d][file]", i), fileName: upload_requests[i].name, mimeType: "file")
                            multipartData.append(upload_requests[i].media_id!.data(using: .utf8)!, withName:String(format: "medias[%d][media_id]", i))
                            multipartData.append(String(format: "%d", upload_requests[i].type!).data(using: .utf8)!, withName: String(format: "medias[%d][type]", i))
                        }
                    }
                    
                    
                    
                }
                
            }, to: serverUrl, method: .post , headers: headers).responseJSON(queue: .main, options: .allowFragments) { (response) in
                switch response.result{
                case .success(let value):
                    dLog("Headers Upload Media: \(headers)")
                    dLog("Response Upload Media: \(value)")
                    
                    if let uploadResponse = Mapper<APIResponse>().map(JSONObject: value){
                        if (uploadResponse.code == RRHTTPStatusCode.ok.rawValue) {
                            // MARK: Gửi Notification đến các nơi đăng kí để thực thi một thứ gì đó khi Upload Success
                            NotificationCenter.default
                                              .post(name:NSNotification.Name("vn.techres.seemt.upload.success"),
                                               object: nil,
                                               userInfo: nil)
                        }
                    }

                case .failure(let error):
                    dLog("Error Upload Media: \(error.localizedDescription)")
                }
            }.uploadProgress { (progress) in
                dLog("Upload Progress: \(progress.fractionCompleted * 100)%")

                dLog("Upload Estimated Time Remaining: \(String(describing: progress.estimatedTimeRemaining))")

                dLog("Upload Total Unit count: \(progress.totalUnitCount/1024)")
                
                dLog("Upload `Completed Unit Count: \(progress.completedUnitCount/1024)")
                
//                self.updateProgress(progress: Float(progress.fractionCompleted))
            }
        
    }
}
extension BaseViewModel{

    func getFoodSyncData() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.foods(
            branch_id: ManageCacheObject.getCurrentBranch().id,
            area_id: areaId.value,
            category_id: ALL,
            category_type: ALL,
            is_allow_employee_gift: ALL,
            is_sell_by_weight: ALL,
            is_out_stock: ALL,
            key_word: "",
            limit: 500,
            page:1
        ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getAreasSyncData() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.areas(branch_id: ManageCacheObject.getCurrentBranch().id, status: ACTIVE))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    
    
    func getLastLoginDevice() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getLastLoginDevice(device_uid: Utils.getUDID(), app_type: Utils.getAppType()))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
}
