//
//  CreateFood_rebuildViewController + extension + mapData.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/11/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import Photos
import ZLPhotoBrowser
import JonAlert


extension CreateFoodViewController {
    func chooseAvatar() {
        let config = ZLPhotoConfiguration.default()
        config.maxSelectCount = 1
        config.maxVideoSelectCount = 1
        config.useCustomCamera = false
        config.allowSelectVideo = false
        config.allowEditImage = true
        config.allowEditVideo = false
        config.allowSlideSelect = false
        config.maxSelectVideoDuration = 60 * 100//100 phut
        let ps = ZLPhotoPreviewSheet()
        ps.selectImageBlock = { [weak self] results, isOriginal in
            // your code
            self?.food_avatar.image = results[0].image
            self?.imagecover.append(results[0].image)
            self?.selectedAssets.append(results[0].asset)
            self!.generateFileUpload()
        }
        ps.showPhotoLibrary(sender: self)
    }

    func generateFileUpload(){
        if imagecover.count > 0{
            var medias_requests = [Media]()
            let widthImageAvatar = Int(self.imagecover[0].size.width)
            let heightImageAvatar = Int(self.imagecover[0].size.height)

            var media_request = Media()
            media_request.type = .image
            media_request.name = Utils.getImageFullName(asset: self.selectedAssets[0])
            media_request.size = 1
            media_request.is_keep = 1 // lưu lại mãi mãi. Nếu 0 sẽ bị xoá sau 1 thời gian ( trường hợp trong group chat)
            media_request.width = widthImageAvatar
            media_request.height = heightImageAvatar
            media_request.type = .image// hình ảnh
            medias_requests.append(media_request)
            self.viewModel.medias.accept(medias_requests)
        }
    }
    

    
    func callAPIWithAvatar(){
            viewModel.getGenerateFile().subscribe(onNext: {(response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    // Call API Generate success...
                     let media_objects = Mapper<MediaObject>().mapArray(JSONArray: response.data as! [[String : Any]])
                
                    
                    if(media_objects.count > 0){
                        // CALL API UPDATE PROFILE
                        var createModel = self.viewModel.createFoodModel.value
                        createModel.avatar = media_objects[0].thumb?.url ?? ""
                        self.viewModel.createFoodModel.accept(createModel)
                        
                        var mediass_request = [mediass]()
                      
                       
                        // call api create or update food after upload image to server media
                        
                        createModel.id > 0 ? self.updateFood() : self.createFood()
                        
                        
                        // CALL API UPLOAD IMAGE TO SERVER
                        var upload_requests = [MediaRequest]()

                        // repair media request
                        var medias = mediass()
                        medias?.media_id = media_objects[0].media_id!
                        medias?.content = ""
                        mediass_request.append(medias!)

                        let upload_request = MediaRequest()

                        upload_request?.media_id = media_objects[0].media_id
                        upload_request?.name = media_objects[0].original?.name
                        upload_request?.image = self.imagecover[0]
                        upload_request?.data = self.imagecover[0].jpegData(compressionQuality: 0.5)
                        upload_request?.type = 0// type image | 1= type video
                        upload_requests.append(upload_request!)
                       
                        self.viewModel.upload_request.accept(upload_requests)
                        self.uploadMedia()
                    }
                }else{
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                    dLog(response.message)
                }
            }).disposed(by: rxbag)
        }
    
    
    public func uploadMedia(){
        viewModel.uploadImageWidthAlamofire()
    }
}
