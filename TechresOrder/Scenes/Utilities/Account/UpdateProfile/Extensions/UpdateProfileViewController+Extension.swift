//
//  UpdateProfileViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 04/02/2023.
//

import UIKit
import ObjectMapper
import ZLPhotoBrowser
//import ActionSheetPicker_3_0
import JonAlert
import RxRelay

extension UpdateProfileViewController{
    func setProfile(account:Account){
        
        avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: ManageCacheObject.getCurrentUser().avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
        lbl_name.text = account.name
        lbl_username.text = ManageCacheObject.getCurrentUser().username
        lbl_role.text = ManageCacheObject.getCurrentUser().employee_role_description
        lbl_brand.text = ManageCacheObject.getCurrentUser().branch_name
        lbl_branch.text = ManageCacheObject.getCurrentUser().branch_name
        
        lbl_id.text = account.identity_card
        lbl_birthday.text = account.birthday
//        lbl_gender.text = account.gender == ACTIVE ? "Nam" : "Nữ"
        
      
        textfield_email.text = account.email
        textfield_phone.text = account.phone_number
        textView_address.text = account.address
        
        
        var options:[UIAction] = []
        
        for type in Gender.allCases {
            
            let option = UIAction(title: type.name, image: nil, identifier: nil, handler: { _ in

                self.btn_choose_gender.menu = self.handleSelection(type: type, menu:self.btn_choose_gender.menu!)
            })

            options.append(option)
        }
        

        btn_choose_gender.menu = UIMenu(title: "Giới tính", children: options)
        btn_choose_gender.menu = handleSelection(type: account.gender, menu:btn_choose_gender.menu!)
      
        
        
        lbl_city.text = account.city_name.count == 0 ? "Chọn thành phố của bạn" : account.city_name
        lbl_district.text = account.district_name.count == 0 ? "Chọn quận bạn đang sinh sống" : account.district_name
        lbl_ward.text = account.ward_name.count == 0 ? "Chọn phường/xã bạn đang sinh sống" : account.ward_name
        
        
    
        viewModel.selectedArea.accept(
            [
                "CITY" : Area(id: account.city_id, name: account.city_name, is_select: ACTIVE),
                "DISTRICT" :Area(id: account.district_id, name: account.district_name, is_select: ACTIVE),
                "WARD" : Area(id: account.ward_id, name: account.ward_name, is_select: ACTIVE)
            ]
        )
    }
    
    
    private func handleSelection(type: Gender, menu:UIMenu) -> UIMenu{

        lbl_gender.text = String(format: "%@", type.name)
        var profile = self.viewModel.profile.value
        profile.gender = type
        viewModel.profile.accept(profile)
 
        menu.children.enumerated().forEach{(i, action) in
            guard let action = action as? UIAction else {
                return
            }
            action.state = action.title == type.name ? .on : .off
        }
    
        return menu
    }
    

    func chooseAvatar() {
        let config = ZLPhotoConfiguration.default()
        config.maxSelectCount = 1
        config.maxVideoSelectCount = 1
        config.useCustomCamera = false
        config.allowSelectVideo = false
        config.allowEditImage = true
        config.allowEditVideo = false
        config.allowSlideSelect = true
        config.allowSelectGif = true
        config.maxSelectVideoDuration = 60 * 100//100 phut
        

        let ps = ZLPhotoPreviewSheet()
        ps.selectImageBlock = { [weak self] results, isOriginal in
            self?.avatar.image = results[0].image
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
    
    func getGenerateFile(){
            viewModel.getGenerateFile().subscribe(onNext: {(response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    // Call API Generate success...
                     let media_objects = Mapper<MediaObject>().mapArray(JSONArray: response.data as! [[String : Any]])
                    
                    dLog(media_objects[0].thumb)
                    /*
                        Nếu user thay đổi ảnh thì ta sẽ
                            gọi API để tạo file ảnh từ server trước, sau đó accept qua cho biến avatar và
                            gọi API update profile và upload ảnh lên server, sau khi update thành công thì
                            thấy đổi avatar của user (trong cache)
                        */
                    var mediass_request = [mediass]()
                    // CALL API UPLOAD IMAGE TO SERVER
                    var upload_requests = [MediaRequest]()
                    let upload_request = MediaRequest()
                    upload_request?.media_id = media_objects[0].media_id
                    upload_request?.name = media_objects[0].original?.name
                    upload_request?.image = self.imagecover[0]
                    upload_request?.data = self.imagecover[0].jpegData(compressionQuality: 0.5)
                    upload_request?.type = TYPE_IMAGE// Hình ảnh
                    upload_requests.append(upload_request!)
                    self.viewModel.upload_request.accept(upload_requests)
                    self.uploadMedia()
                    
                    // CALL API UPDATE PROFILE

                    var profile = self.viewModel.profile.value
                    profile.avatar = media_objects[0].thumb?.url! ?? ""
                    self.viewModel.profile.accept(profile)
                    
                    self.updateProfile()
                     
                }else{
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.",duration: 2.0)
                    dLog(response.message)
                }
            }).disposed(by: rxbag)
        }
    
    func updateProfileWithAvatar(){
        getGenerateFile()
    }
    
    func updateProfileWithoutAvatar(){
        updateProfile()
    }
    
    func uploadMedia(){
        viewModel.uploadImageWidthAlamofire()
    }
    
}
// HANDLE CHOOSE CITY
extension UpdateProfileViewController{
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
}


extension UpdateProfileViewController:AccountInforDelegate{
    func callBackToAcceptSelectedArea(selectedArea:[String:Area]) {
        var profile = viewModel.profile.value
        profile.city_id = selectedArea["CITY"]!.id
        profile.district_id = selectedArea["DISTRICT"]!.id
        profile.ward_id = selectedArea["WARD"]!.id
        viewModel.profile.accept(profile)
        
        lbl_city.text = selectedArea["CITY"]!.name
        lbl_district.text = selectedArea["DISTRICT"]!.name
        lbl_ward.text = selectedArea["WARD"]!.name
    }
}

