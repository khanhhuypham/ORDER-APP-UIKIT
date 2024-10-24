//
//  ChatChannel + extension + upLoadMedia.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 27/05/2024.
//

import UIKit
import ObjectMapper
import SocketIO
import RxCocoa

extension ChatChannelViewController{
    
    func getGenerateMedia(medias:[Media], fileData:Data? = nil){
        viewModel.getGenerateFile(medias:medias).subscribe(onNext: {(response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                let media_objects = Mapper<MediaObject>().mapArray(JSONArray: response.data as! [[String : Any]])
                
                var message = MessageEmit()
                message.key_error = "\(NSDate().timeIntervalSince1970)"
                
                var mediaArray:[MediaUpload] = []
            
                
                if let socket = SocketChatIOManager.shared.socketChat, let media = medias.first {
                    
                    switch media.type {
                        case .image:
                            for ( i,img) in media_objects.enumerated() {
                                
                                mediaArray.append(MediaUpload(
                                    media_id: img.media_id,
                                    name: img.original?.name,
                                    path_media: medias[i].url,
                                    type: .image
                                ))
                                
                                message.media = media_objects.map{$0.media_id ?? ""}
                            }
                        
                            socket.emit(CHAT_SOCKET_KEY.MESSAGE_IMAGE, message.toJSON())
                            
                        case .video:
                          
                        if let video = media_objects.first, let media = medias.first{
                            mediaArray.append(MediaUpload(media_id: video.media_id, name: video.original?.name, path_media: media.url, type: .video))
                                message.media = media_objects.map{$0.media_id ?? ""}
                            }
                            socket.emit(CHAT_SOCKET_KEY.MESSAGE_VIDEO, message.toJSON())
                            
                        case .audio:
                            socket.emit(CHAT_SOCKET_KEY.MESSAGE_AUDIO, message.toJSON())
                        
                        case .file:
                            if let file = media_objects.first,let data = fileData, let media = medias.first{
                                mediaArray.append(MediaUpload(media_id: file.media_id, name: file.original?.name, path_media: media.url, data: data, type: .file))
                                message.media = media_objects.map{$0.media_id ?? ""}
                            }
                        
                            socket.emit(CHAT_SOCKET_KEY.MESSAGE_FILE, message.toJSON())
                        
                        case .link:
                            break
                        
                        default:
                            break
                    }
                
                }
                
                
                if mediaArray.count > 0{
                    MediaUtils.uploadDataWidthAlamofire(data: mediaArray)
                }
                        
              
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại")
            }
        }).disposed(by: rxbag)
    }
    
}
