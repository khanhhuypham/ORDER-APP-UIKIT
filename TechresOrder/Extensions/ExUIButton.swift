//
//  ExUIButton.swift
//  ORDER
//
//  Created by Pham Khanh Huy on 19/06/2023.
//

import UIKit

extension UIButton {
    
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    
    func addShadow(shadowOffset: CGSize, shadowOpacity:Float, shadowRadius:Int, color:UIColor){
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = CGFloat(shadowRadius)
        self.layer.masksToBounds = false
    }

    
    private var progressViewTag: Int { return 9999 }
    
    
    func showCircularProgress() {
        let circularProgress = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        circularProgress.center = CGPoint(x: bounds.midX, y: bounds.midY)
        circularProgress.tag = progressViewTag
        addSubview(circularProgress)
        isEnabled = false
    }
    
    func updateCircularProgress(progress: CGFloat) {
        if let progressView = viewWithTag(progressViewTag) as? CircularProgressView {
            progressView.setProgress(to: progress, withAnimation: true)
        }
    }
    
    func hideCircularProgress() {
        if let progressView = viewWithTag(progressViewTag) {
            progressView.removeFromSuperview()
        }
        isEnabled = true
    }
}


extension UIControl {
    func preventRepeatedPresses(inNext seconds: Double = 1) {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }
}

class CircularProgressView: UIView {
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }
    
    private func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: center, radius: frame.size.width / 2, startAngle: -(.pi / 2), endAngle: 3 * .pi / 2, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 2.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.systemGray6.cgColor
        layer.addSublayer(circleLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 2.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = ColorUtils.blue_brand_700().cgColor
        layer.addSublayer(progressLayer)
    }
    
    func setProgress(to progressConstant: CGFloat, withAnimation: Bool) {
        var progress: CGFloat {
            return min(max(progressConstant, 0), 1)
        }
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 0.5
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = progress
            progressLayer.add(animation, forKey: "animateProgress")
        }
        progressLayer.strokeEnd = progress
    }
}

class DownloadManager: NSObject, URLSessionDownloadDelegate {
    static let shared = DownloadManager()
    
    var progressHandler: ((CGFloat) -> Void)?
    var completionHandler: ((URL?, Error?) -> Void)?
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        progressHandler?(progress)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        completionHandler?(location, nil)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            completionHandler?(nil, error)
        }
    }
}
