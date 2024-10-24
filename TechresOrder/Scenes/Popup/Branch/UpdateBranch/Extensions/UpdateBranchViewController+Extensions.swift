//
//  UpdateBranchViewController+Extensions.swift
//  TECHRES-ORDER
//
//  Created by macmini_techres_04 on 14/09/2023.
//

import Foundation
import ZLPhotoBrowser
import JonAlert
import ObjectMapper
import Kingfisher

extension UpdateBranchViewController {
    func setupValid() {
        
        _ = txt_Branche_phone.rx.text.map{(str) in
            if str!.count > 11 {
                self.showWarningMessage(content: "Độ dài tối đa 11 ký tự")
            }
            return String(str!.prefix(11))
        }.map({(str) -> Branch in
            self.txt_Branche_phone.text = str
            if (self.txt_Branche_phone.text?.first != "0"){
                self.txt_Branche_phone.text = "0"
            }
            var cloneEmployeeInfor = self.viewModel.dataArray.value
            cloneEmployeeInfor.phone = str ?? ""
            return cloneEmployeeInfor
        }).bind(to: viewModel.dataArray).disposed(by: rxbag)
        
        _ = txt_Branches_address.rx.text.map{(str) in
            if str!.count > 255 {
                self.showWarningMessage(content: "Độ dài tối đa 255 ký tự")
            }
            return String(str!.prefix(255))
        }.map({(str) -> Branch in
            self.txt_Branches_address.text = str
            var cloneEmployeeInfor = self.viewModel.dataArray.value
            cloneEmployeeInfor.street_name = str ?? ""
            return cloneEmployeeInfor
        }).bind(to: viewModel.dataArray).disposed(by: rxbag)
        
    }

}

extension UpdateBranchViewController {
    
    //CALL API
    func getInfoBranches() {
        viewModel.getInfoBranches().subscribe(onNext: { [weak self] (response) in
            if response.code == RRHTTPStatusCode.ok.rawValue {
                if let dataBranches = Mapper<Branch>().map(JSONObject: response.data) {
                    self!.viewModel.dataArray.accept(dataBranches)
                    self!.setupProfile()
                }
            }else {
                
                JonAlert.showSuccess(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối")
            }
            
            
        }).disposed(by: rxbag)
      
    }
    func updateBranches() {
        viewModel.updateBranches().subscribe(onNext: { [weak self] (response) in
            if response.code == RRHTTPStatusCode.ok.rawValue {
                if let branch = Mapper<Branch>().map(JSONObject: response.data) {
                    ManageCacheObject.saveCurrentBranch(branch)
                    self?.viewModel.makeToPopViewController()
                    JonAlert.showSuccess(message: "Cập nhật thông tin chi nhánh thành công")
                }
            }else {
                
                JonAlert.showSuccess(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối")
            }
            
            
        }).disposed(by: rxbag)
    }
    
    func setupProfile(){
      
        var dataImage = viewModel.dataArray.value
        txt_Branche_Name.text = viewModel.dataArray.value.name
        txt_Branche_phone.text = viewModel.dataArray.value.phone
        txt_Branches_address.text = viewModel.dataArray.value.street_name
        txt_city.text = viewModel.dataArray.value.city_name
        txt_district.text = viewModel.dataArray.value.district_name
        txt_ward.text = viewModel.dataArray.value.ward_name
        dataImage.image_logo_url = viewModel.dataArray.value.image_logo
        dataImage.banner_image_url = viewModel.dataArray.value.banner
        viewModel.dataArray.accept(dataImage)
        dLog(viewModel.dataArray.value)
        if typecheck == 0 {
            image_Logo.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: viewModel.dataArray.value.image_logo_url)), placeholder:  UIImage(named: "image_defauft_medium"))
            banner_image.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: viewModel.dataArray.value.banner)), placeholder:  UIImage(named: "image_defauft_medium"))
        }
          
        viewModel.selectedArea.accept(
            [
                "CITY" : Area(id: viewModel.dataArray.value.city_id, name: viewModel.dataArray.value.city_name, is_select: ACTIVE),
                "DISTRICT" :Area(id: viewModel.dataArray.value.district_id, name: viewModel.dataArray.value.district_name, is_select: ACTIVE),
                "WARD" : Area(id: viewModel.dataArray.value.ward_id, name: viewModel.dataArray.value.ward_name, is_select: ACTIVE)
            ]
        )
    }
}

extension UpdateBranchViewController {
    func chooseAvatar() {
       let config = ZLPhotoConfiguration.default()
       config.maxSelectCount = 1
       config.maxVideoSelectCount = 1
       config.useCustomCamera = false
//       config.sortAscending = false
       config.allowSelectVideo = false
       config.allowEditImage = true
       config.allowEditVideo = false
       config.allowSlideSelect = false
       config.maxSelectVideoDuration = 60 * 100//100 phut
        let ps = ZLPhotoPreviewSheet()
        if isCheck {
            self.imagecover.removeAll()
            self.selectedAssets.removeAll()
            ps.selectImageBlock = { [weak self] results, isOriginal in
                // your code
                self?.image_Logo.image = results[0].image
                self?.imagecover.append(results[0].image)
                self?.selectedAssets.append(results[0].asset)
                self!.generateFileUpload()
            }
            ps.showPhotoLibrary(sender: self)
            typecheck = 1
        }else {
            self.imagecover2.removeAll()
            self.selectedAssets2.removeAll()
            ps.selectImageBlock = { [weak self] results, isOriginal in
                // your code
                self?.banner_image.image = results[0].image
                self?.imagecover2.append(results[0].image)
                self?.selectedAssets2.append(results[0].asset)
                self!.generateFileUpload()
            }
            ps.showPhotoLibrary(sender: self)
            typecheck = 2
        }
        
       
       
    }

    
    func generateFileUpload(){
        var medias_requests = [Media]()
        var media_request = Media()
        var media_request2 = Media()
        if imagecover.count > 0 {
          

            let widthImageAvatar = Int(self.imagecover[0].size.width)
            let heightImageAvatar = Int(self.imagecover[0].size.height)
           
            
            media_request.type = .image // Set the type property to TYPE_IMAGE
            media_request.name = Utils.getImageFullName(asset: self.selectedAssets[0])
            media_request.size = 1
            media_request.is_keep = 1 // lưu lại mãi mãi. Nếu 0 sẽ bị xoá sau 1 thời gian ( trường hợp trong group chat)
            media_request.width = widthImageAvatar
            media_request.height = heightImageAvatar
            
            medias_requests.append(media_request)
           
            dLog(media_request)
            dLog(medias_requests)
        }
        if imagecover2.count > 0 {
            let widthImageAvatar2 = Int(self.imagecover2[0].size.width)
            let heightImageAvatar2 = Int(self.imagecover2[0].size.height)
          
            
            media_request2.type = .image // Set the type property to TYPE_IMAGE
            media_request2.name = Utils.getImageFullName(asset: self.selectedAssets2[0])
            media_request2.size = 1
            media_request2.is_keep = 1 // lưu lại mãi mãi. Nếu 0 sẽ bị xoá sau 1 thời gian ( trường hợp trong group chat)
            media_request2.width = widthImageAvatar2
            media_request2.height = heightImageAvatar2
            medias_requests.append(media_request2)
            dLog(media_request)
            dLog(medias_requests)
        }
       
       
        self.viewModel.medias.accept(medias_requests)
    }
    
    
    func updateProfileWithAvatar(){
        getGenerateFile()
    }
        
    func getGenerateFile(){
        viewModel.getGenerateFile().subscribe(onNext: {(response) in
            dLog(response.toJSON())
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                // Call API Generate success...
                 let media_objects = Mapper<MediaObject>().mapArray(JSONArray: response.data as! [[String : Any]])
                var upload_requests = [MediaRequest]()
                // CALL API UPDATE PROFILE
                var dataBranches = self.viewModel.dataArray.value
                var checkArray = 0
                if self.imagecover.count > 0 {
                 dLog("vap")
                    dataBranches.image_logo_url = media_objects[0].thumb?.url! ?? ""
                   
                  
                 
                    let upload_request = MediaRequest()
                    upload_request?.media_id = media_objects[0].media_id
                    upload_request?.name = media_objects[0].original?.name
                    upload_request?.image = self.imagecover[0]
                    upload_request?.data = self.imagecover[0].jpegData(compressionQuality: 0.5)
                    upload_request?.type = TYPE_IMAGE// Hình ảnh
                    upload_requests.append(upload_request!)
                    checkArray = 1
                }
                dLog(self.imagecover2.count)
                if self.imagecover2.count > 0 {
//                    var cloneEmployeeInfor = self.viewModel.supplierInfor.value
                    dLog("vao day roi")
                    let upload_request2 = MediaRequest()
                    if media_objects[checkArray].thumb?.url != nil {
                        dataBranches.banner_image_url = media_objects[checkArray].thumb?.url! ?? ""
                        
                        upload_request2?.media_id = media_objects[checkArray].media_id
                        upload_request2?.name = media_objects[checkArray].original?.name
                    }
                    upload_request2?.image = self.imagecover2[0]
                    upload_request2?.data = self.imagecover2[0].jpegData(compressionQuality: 0.5)
                    upload_request2?.type = TYPE_IMAGE// Hình ảnh
                    upload_requests.append(upload_request2!)
                }
                self.viewModel.dataArray.accept(dataBranches)
              self.updateBranches()
                /*
                    Nếu user thay đổi ảnh thì ta sẽ
                        gọi API để tạo file ảnh từ server trước, sau đó accept qua cho biến avatar và
                        gọi API update or create profile và upload ảnh lên server, sau khi update thành công thì
                        thấy đổi avatar của user (trong cache)
                    */
            
                self.viewModel.upload_request.accept(upload_requests)
            
                
            
                self.uploadMedia()
                           
            }else{
                Toast.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", controller: self)
            }
        }).disposed(by: rxbag)
    }
    
    
    func uploadMedia(){
        viewModel.uploadImageWidthAlamofire()
    }
    
}
extension UpdateBranchViewController: AccountInforDelegate {
    func presentAddressDialogOfAccountInforViewController(areaType:String) {
        let addressDialogOfAccountInforViewController = AddressDialogOfAccountInforViewController()
        addressDialogOfAccountInforViewController.delegate = self
        addressDialogOfAccountInforViewController.view.backgroundColor = ColorUtils.blackTransparent()

        switch areaType{
            case "CITY":
                addressDialogOfAccountInforViewController.selectedArea = viewModel.selectedArea.value
                addressDialogOfAccountInforViewController.areaType = areaType
                break
            case "DISTRICT":
             
                addressDialogOfAccountInforViewController.selectedArea = viewModel.selectedArea.value
                addressDialogOfAccountInforViewController.areaType = areaType
                break
            case "WARD":
                addressDialogOfAccountInforViewController.areaType = areaType
                addressDialogOfAccountInforViewController.selectedArea = viewModel.selectedArea.value
                break
        default:
            return
        }

        let nav = UINavigationController(rootViewController: addressDialogOfAccountInforViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    // 3
                    sheet.detents = [.large()]
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
           
            present(nav, animated: true, completion: nil)

        }
    func callBackToAcceptSelectedArea(selectedArea:[String:Area]) {
        var cloneSelectedArea = viewModel.selectedArea.value
        var dataSelectedArea = viewModel.dataArray.value
        cloneSelectedArea.updateValue(selectedArea["CITY"]!, forKey: "CITY")
        cloneSelectedArea.updateValue(selectedArea["DISTRICT"]!, forKey: "DISTRICT")
        cloneSelectedArea.updateValue(selectedArea["WARD"]!, forKey: "WARD")
        viewModel.selectedArea.accept(cloneSelectedArea)
        dataSelectedArea.city_id = selectedArea["CITY"]!.id
        dataSelectedArea.district_id = selectedArea["DISTRICT"]!.id
        dataSelectedArea.ward_id = selectedArea["WARD"]!.id
        dataSelectedArea.city_name = selectedArea["CITY"]!.name
        dataSelectedArea.district_name = selectedArea["DISTRICT"]!.name
        dataSelectedArea.ward_name = selectedArea["WARD"]!.name
        viewModel.dataArray.accept(dataSelectedArea)
        
        lbl_city.text = selectedArea["CITY"]!.name
        lbl_district.text = selectedArea["DISTRICT"]!.name
        lbl_ward.text = selectedArea["WARD"]!.name
    }
}
