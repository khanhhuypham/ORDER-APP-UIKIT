//
//  ImageUtils.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/12/2023.
//

import UIKit
import AVFoundation
import RxSwift
import RxRelay
import Alamofire
import Moya
import ObjectMapper
import Photos
class MediaUtils {
    
    private static let headers:HTTPHeaders = {
       return [
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data",
            "Method": "\(Constants.METHOD_TYPE.POST)",
            "ProjectId": String(Constants.PROJECT_IDS.PROJECT_UPLOAD_SERVICE),
            "Authorization":" Bearer \(ManageCacheObject.getCurrentUser().access_token)"
        ]
    }()

    /// Lấy tên nguyên bản trên thiết bị của ảnh
    static func getAssetFullName(asset: PHAsset) -> String {
        let resources = PHAssetResource.assetResources(for: asset)
        
        if let resource = resources.first {
            let fullName = resource.originalFilename
            return fullName
        }
        return ""
    }
    
    static func getAssetSize(asset: PHAsset) -> Int {
        var fileSize = 0
        let resources = PHAssetResource.assetResources(for: asset)
        if let resource = resources.first {
            let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
            fileSize = Int(unsignedInt64 ?? 0)
        }
        return fileSize
    }
    
    static func saveImageDataToFile(data: Data, fileExtension: String) -> URL? {
        let uniqueFilename = ProcessInfo.processInfo.globallyUniqueString
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(uniqueFilename).\(fileExtension)")
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch let error {
            dLog("Error saving image to file: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    static func captureViewScreenshot(viewToCapture: UIView) -> UIImage? {
 
        UIGraphicsBeginImageContextWithOptions(viewToCapture.bounds.size, true, 1)
        if let context = UIGraphicsGetCurrentContext() {
            viewToCapture.layer.render(in: context)
        }
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot
    }
    
    static func combineScreenshots(_ screenshot1: UIImage?, _ screenshot2: UIImage?) -> UIImage? {
        guard let screenshot1 = screenshot1, let screenshot2 = screenshot2 else {
            return nil
        }
        let combinedSize = CGSize(width: max(screenshot1.size.width, screenshot2.size.width),
                                   height: screenshot1.size.height + screenshot2.size.height)
        UIGraphicsBeginImageContextWithOptions(combinedSize, false, UIScreen.main.scale)
        screenshot1.draw(at: CGPoint.zero)
        screenshot2.draw(at: CGPoint(x: 0, y: screenshot1.size.height))
        let combinedScreenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedScreenshot
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        
        let size = image.size
           
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
           newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
           newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

//        if let data:Data = newImage?.pngData() {
//            return UIImage(data: data)
//        }
//        
        return newImage
    }
    
    static func convertImageToBlackAndWhiteFormat(yourUIImage:UIImage) -> UIImage{
        guard let currentCGImage = yourUIImage.cgImage else { return yourUIImage}
        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")

        // set a gray value for the tint color
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")

        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return yourUIImage}

        let context = CIContext()

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            return processedImage
        }
        return yourUIImage
    }
    
    
    /// Lấy Thumbnail từ URL string của Video
    static func generateThumbnailURLFromVideo(for videoURL: URL, completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        imageGenerator.appliesPreferredTrackTransform = true

        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 60) // You can adjust the time to get the thumbnail at a different point in the video

        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)

            // Save the image to a temporary file
            let tempDirectoryURL = FileManager.default.temporaryDirectory
            let tempFileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("png")

            if let data = thumbnail.pngData() {
                try data.write(to: tempFileURL)
                completion(tempFileURL)
            } else {
                completion(nil)
            }
        } catch {
            dLog("Error generating thumbnail: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    
    static func getFullMediaLink(string:String, media_type:media_type = .image) -> String {
        
        return media_type == .video
        ? (String(format: "%@%@", APIEndPoint.GATEWAY_SERVER_URL, "/s3") + string).encodeUrl()!
        : (String(format: "%@", ManageCacheObject.getConfig().api_upload_short) + string).encodeUrl()!
    }
    
    
    static func getSizeOfFile(size:Float) -> String {
        var str = ""
        
        if (size >= 1048576) && (size < 1073741824) {
            
            str = Utils.stringQuantityFormatWithNumberFloat(amount: size / 1048576) + " MB"
            
        } else if (size > 1024) && (size < 1048576) {
            
            str = Utils.stringQuantityFormatWithNumberFloat(amount: size / 1024) + " KB"
            
        } else if size <= 1024 {
            
            str = Utils.stringQuantityFormatWithNumberFloat(amount: size) + " B"
            
        } else {
            str = Utils.stringQuantityFormatWithNumberFloat(amount: size / 1073741824) + " GB"
            
        }
        return str
    }
    
    
    static func getSizeOfFile(url:URL) -> Int {
        do {
            let resources = try url.resourceValues(forKeys:[.fileSizeKey])
            let fileSize = resources.fileSize!
            return Int(fileSize)
        } catch {
            return 0
        }
    }
    
    
    
    
    /// Xem thêm/Thu gon + Tối đa kí tự + Thêm màu cho link + Thêm màu cho nhiều kí tự
    static func readLessMoreLabelText(fullText: String, maxLength: Int, label: UILabel,
                                      isTextExpanded:Bool = false, linkTexts: [String] = [],
                                      wordsToHighlight: [String] = [],
                                      colorWordsHighlight: UIColor = UIColor(hex: "0071BB")) {
        let truncatedText: String
        label.isUserInteractionEnabled = fullText.count > maxLength
        if fullText.count > maxLength {
            truncatedText = isTextExpanded ? fullText : String(fullText.prefix(maxLength) + "...")
        } else {
            truncatedText = fullText
        }
        
        let attributedText = NSMutableAttributedString(string: truncatedText)
        if fullText.count > maxLength {
            let actionText = isTextExpanded ? " Thu gọn" : " Xem thêm"
            attributedText.append(NSAttributedString(string: actionText, attributes: [
                .foregroundColor: UIColor(hex: "0071BB"),
                .font: UIFont(name: "Roboto-Bold", size: label.font.pointSize) ?? UIFont.boldSystemFont(ofSize: label.font.pointSize)
            ]))
        }
        
        for linkText in linkTexts {
            do {
                let regex = try NSRegularExpression(pattern: NSRegularExpression.escapedPattern(for: linkText))
                let matches = regex.matches(in: truncatedText, range: NSRange(truncatedText.startIndex..., in: truncatedText))
                for match in matches {
                    attributedText.addAttributes([
                        .foregroundColor: UIColor(hex: "0071BB"),
                        .font: UIFont(name: "Roboto-Regular", size: label.font.pointSize) ?? UIFont.systemFont(ofSize: label.font.pointSize),
                        .underlineStyle: NSUnderlineStyle.single.rawValue,
                        .underlineColor: UIColor(hex: "0071BB")
                    ], range: match.range)
                }
            } catch let error {
                dLog("Error creating regular expression: \(error.localizedDescription)")
            }
        }
        
        do {
            let urlDetector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let urlMatches = urlDetector.matches(in: truncatedText, range: NSRange(truncatedText.startIndex..., in: truncatedText))
            for urlMatch in urlMatches {
                attributedText.addAttributes([
                    .foregroundColor: UIColor(hex: "0071BB"),
                    .font: UIFont(name: "Roboto-Regular", size: label.font.pointSize) ?? UIFont.systemFont(ofSize: label.font.pointSize),
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .underlineColor: UIColor(hex: "0071BB")
                ], range: urlMatch.range)
            }
        } catch let error {
            dLog("Error creating regular expression: \(error.localizedDescription)")
        }
        
        for wordToHighlight in wordsToHighlight {
            let range = (attributedText.string as NSString).range(of: wordToHighlight)
            attributedText.addAttributes([
                .foregroundColor: colorWordsHighlight
            ], range: range)
        }
        label.attributedText = attributedText
    }
    
    static func getTappedLink(at point: CGPoint, fullText: String, linkTexts: [String], label: UILabel) -> String? {
        guard let attributedText = label.attributedText else {
               return nil
           }

           // Create a text container with the label's text and size
           let textContainer = NSTextContainer(size: label.bounds.size)
           let layoutManager = NSLayoutManager()
           let textStorage = NSTextStorage(attributedString: attributedText)

           layoutManager.addTextContainer(textContainer)
           textStorage.addLayoutManager(layoutManager)

           // Create a tap location in the text container
           let tapLocation = point
           let characterIndex = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

           // Check if the character index corresponds to a URL
           for linkText in linkTexts {
               let linkRange = (NSString(utf8String: fullText) ?? "" as NSString).range(of: linkText)
               if NSLocationInRange(characterIndex, linkRange) {
                   return linkText
               }
           }
        do {
            let urlDetector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let urlMatches = urlDetector.matches(in: fullText, range: NSRange(fullText.startIndex..., in: fullText))
            for match in urlMatches {
               if NSLocationInRange(characterIndex, match.range) {
                   return (fullText as NSString).substring(with: match.range)
               }
            }
        } catch let error {
            dLog("Error creating regular expression: \(error.localizedDescription)")
        }
           return nil
    }
    
    
    static func convertHEICToJPG(from imageURL: URL, completion: @escaping (URL?) -> Void) {
        // Step 1: Download HEIC image data
        guard let heicImageData = try? Data(contentsOf: imageURL) else {
            completion(nil)
            return
        }
        // Step 2: Convert HEIC data to UIImage
        guard var image = UIImage(data: heicImageData) else {
            completion(nil)
            return
        }
        // Step 3: Fix the image orientation
        guard image.imageOrientation != .up else {
            return
        }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image = normalizedImage ?? image
        // Extract the original file name (without extension) from the provided URL
        let originalFileName = imageURL.deletingPathExtension().lastPathComponent
        // Step 4: Convert UIImage to JPG data
        guard let jpgData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        // Step 5: Save JPG data to a file with the original file name and .jpg extension
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jpgURL = documentsDirectory.appendingPathComponent(originalFileName).appendingPathExtension("jpg")
        do {
            try jpgData.write(to: jpgURL)
            completion(jpgURL)
        } catch {
            dLog("Error saving JPG data to file: \(error)")
            completion(nil)
        }
    }
    
    
    static func uploadDataWidthAlamofire(
        serverUrl: URL = URL(string: String(format: "%@%@",APIEndPoint.GATEWAY_SERVER_URL, "/api/v2/media/upload/"))!,
        headers:HTTPHeaders = headers,
        data:[MediaUpload],
        progressing: ((Double) -> Void)? = nil,
        success:((AFDataResponse<Any>) -> Void)? = nil,
        failure: ((Error) -> Void)? = nil
    ){
        dLog("\(serverUrl.absoluteString)")

        
            AF.upload(multipartFormData: { (multipartData) in
                
                for (i,media) in data.enumerated(){
                    
            
                    if media.path_media?.absoluteString.lowercased().contains(".heic") == true {
                        if let path_media = media.path_media {
                            MediaUtils.convertHEICToJPG(from: path_media) { (jpgURL) in
                                dLog(jpgURL)
                                if let jpgURL = jpgURL {
                                    multipartData.append(jpgURL, withName: String(format: "medias[%d][file]", i))
                                    dLog("Conversion Successful. JPG file saved at: \(jpgURL)")
                                }
                            }
                        }
                    } else {
                        if let path_media = media.path_media {
                            dLog("URL File Upload: \(String(describing: path_media))")
                            multipartData.append(path_media, withName: String(format: "medias[%d][file]", i))
                        }
                    }
                    
     
                    if let media_id = media.media_id {
                        multipartData.append(media_id.data(using: .utf8)!, withName:String(format: "medias[%d][media_id]", i))
                    }
                    
                    
                    if let media_type = media.type {
                        
                        multipartData.append(String(format: "%d", media_type.rawValue).data(using: .utf8)!, withName: String(format: "medias[%d][type]", i))
                        
                        if media.type == .video {
                            if let videoURL = media.path_media {
                                MediaUtils.generateThumbnailURLFromVideo(for: videoURL) { thumbnailURL in
                                    if let thumbnailURL = thumbnailURL {
                                        multipartData.append(thumbnailURL, withName: String(format: "medias[%d][thumb]", i))
                                    }
                                }
                            }
                        }
                    }
                    
                }
                            
            
            }, to: serverUrl, method: .post , headers: headers).responseData(completionHandler: { (response) in
                
                switch response.result{
                    case .success(let data):
                        dLog("Headers Upload Media: \(headers)")
                        dLog("Response Upload Media: \(response)")
                    
                        if let jsonString = String(data: data, encoding: .utf8) {
                            if let responseObject = Mapper<APIResponse>().map(JSONString: jsonString) {
                                dLog("Response Upload Media: \(responseObject.toJSON())")
                            }
                        }

                    case .failure(let error):
                        dLog("Error Upload Media: \(error.localizedDescription)")
                }
            }).uploadProgress{ (progress) in
                dLog("Upload Progress: \(progress.fractionCompleted * 100)%")

                dLog("Upload Estimated Time Remaining: \(String(describing: progress.estimatedTimeRemaining))")

                dLog("Upload Total Unit count: \(progress.totalUnitCount/1024)")
                
                dLog("Upload `Completed Unit Count: \(progress.completedUnitCount/1024)")
                
//                self.updateProgress(progress: Float(progress.fractionCompleted))
            }
        
    }
    
    
    
    
}



extension MediaUtils {

  
    
    
}
