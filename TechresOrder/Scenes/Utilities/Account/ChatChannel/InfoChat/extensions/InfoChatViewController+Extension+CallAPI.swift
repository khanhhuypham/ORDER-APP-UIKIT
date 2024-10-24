////
////  InfoChatViewController+Extension+CallAPI.swift
////  TECHRES-SEEMT
////
////  Created by Huynh Quang Huy on 11/11/2023.
////  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
////
//
import UIKit
import ObjectMapper
import JonAlert
import RxCocoa
import Kingfisher

extension InfoChatViewController {
    func getListMedia(){
        viewModel.getListMedia().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue) {
                if let dataFromServer = Mapper<MediaStore>().mapArray(JSONObject: response.data) {
                    if dataFromServer.count > 0 {
                        self.view_no_media.isHidden = true
                        self.handleMediaFromServer(data: dataFromServer)
                    } else {
                        self.view_no_media.isHidden = false
                    }
                }
            } else {
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại")
            }
        }).disposed(by: rxbag)
    }
    
    func handleMediaFromServer(data: [MediaStore]){
        switch data.count {
            case 1:
                image_media_one.kf.setImage(with: URL(string: MediaUtils.getFullMediaLink(string: data[0].media.thumb.url)),
                                             placeholder: UIImage(named: "image_defauft_medium"))
                image_icon_play_media_one.isHidden = data[0].media.type == TYPE_IMAGE
                view_image_media_one.isHidden = false
                view_image_media_two.isHidden = true
                view_image_media_three.isHidden = true
                view_image_media_four.isHidden = true
                break
            case 2:
                image_media_one.kf.setImage(with: URL(string: MediaUtils.getFullMediaLink(string: data[0].media.thumb.url)),
                                             placeholder: UIImage(named: "image_defauft_medium"))
                image_media_two.kf.setImage(with: URL(string: MediaUtils.getFullMediaLink(string: data[1].media.thumb.url)),
                                             placeholder: UIImage(named: "image_defauft_medium"))
                image_icon_play_media_one.isHidden = data[0].media.type == TYPE_IMAGE
                image_icon_play_media_two.isHidden = data[1].media.type == TYPE_IMAGE
                view_image_media_one.isHidden = false
                view_image_media_two.isHidden = false
                view_image_media_three.isHidden = true
                view_image_media_four.isHidden = true
                break
            case 3:
                image_media_one.kf.setImage(with: URL(string: MediaUtils.getFullMediaLink(string: data[0].media.thumb.url)),
                                             placeholder: UIImage(named: "image_defauft_medium"))
                image_media_two.kf.setImage(with: URL(string: MediaUtils.getFullMediaLink(string: data[1].media.thumb.url)),
                                             placeholder: UIImage(named: "image_defauft_medium"))
                image_media_three.kf.setImage(with: URL(string: MediaUtils.getFullMediaLink(string: data[2].media.thumb.url)),
                                             placeholder: UIImage(named: "image_defauft_medium"))
                image_icon_play_media_one.isHidden = data[0].media.type == TYPE_IMAGE
                image_icon_play_media_two.isHidden = data[1].media.type == TYPE_IMAGE
                image_icon_play_media_three.isHidden = data[2].media.type == TYPE_IMAGE
                view_image_media_one.isHidden = false
                view_image_media_two.isHidden = false
                view_image_media_three.isHidden = false
                view_image_media_four.isHidden = true
                break
            default:
                image_media_one.kf.setImage(with: URL(string: MediaUtils.getFullMediaLink(string: data[0].media.thumb.url)),
                                             placeholder: UIImage(named: "image_defauft_medium"))
                image_media_two.kf.setImage(with: URL(string: MediaUtils.getFullMediaLink(string: data[1].media.thumb.url)),
                                             placeholder: UIImage(named: "image_defauft_medium"))
                image_media_three.kf.setImage(with: URL(string: MediaUtils.getFullMediaLink(string: data[2].media.thumb.url)),
                                             placeholder: UIImage(named: "image_defauft_medium"))
                image_media_four.kf.setImage(with: URL(string: MediaUtils.getFullMediaLink(string: data[3].media.thumb.url)),
                                             placeholder: UIImage(named: "image_defauft_medium"))
                image_icon_play_media_one.isHidden = data[0].media.type == TYPE_IMAGE
                image_icon_play_media_two.isHidden = data[1].media.type == TYPE_IMAGE
                image_icon_play_media_three.isHidden = data[2].media.type == TYPE_IMAGE
                image_icon_play_media_four.isHidden = data[3].media.type == TYPE_IMAGE
                view_image_media_one.isHidden = false
                view_image_media_two.isHidden = false
                view_image_media_three.isHidden = false
                view_image_media_four.isHidden = false
        }
    }
}
