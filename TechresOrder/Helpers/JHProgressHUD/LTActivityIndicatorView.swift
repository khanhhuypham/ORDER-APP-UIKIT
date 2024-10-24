//
//  LTActivityIndicatorView.swift
//  demoActivator
//
//  Created by Tuan Le on 6/30/15.
//  Copyright (c) 2015 Tuan Le. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class LTActivityIndicatorView: UIView {

    enum HZActivityIndicatorDirection : Int{
         case hzActivityIndicatorDirectionClockwise = -1
         case hzActivityIndicatorDirectionCounterClockwise = 1
    }
    
    var steps:Int?
    var indicatorRadius:Int?
    var finSize:CGSize?
    var stepDuration:CGFloat?
    var isAnimating:Bool?
    var color:UIColor?
    var hidesWhenStopped:Bool?
    var roundedCoreners:UIRectCorner?
    var cornerRadii: CGSize?
    var actualActivityIndicatorViewStyle: UIActivityIndicatorView.Style?
    var timer:Timer?
    var anglePerStep:CGFloat?
    var currStep:CGFloat?
    var direction: HZActivityIndicatorDirection?
    var progress:CGFloat = 0
    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self._setPropertiesForStyle(UIActivityIndicatorView.Style.white)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self._setPropertiesForStyle(UIActivityIndicatorView.Style.white)
    }
    
    func initWithActivityIndicatorStyle(_ style:UIActivityIndicatorView.Style){
        self._setPropertiesForStyle(style)
    }
    
    func setActivityIndicatorViewStyle(_ activityIndicatorViewStyle:UIActivityIndicatorView.Style){
        self._setPropertiesForStyle(activityIndicatorViewStyle)
    }
    
    
    func _setPropertiesForStyle(_ style: UIActivityIndicatorView.Style) ->(){
        self.backgroundColor = UIColor.clear
        self.direction = .hzActivityIndicatorDirectionClockwise
        self.roundedCoreners = UIRectCorner.allCorners
        self.cornerRadii = CGSize(width: 1, height: 1);
        self.stepDuration = 0.1;
        self.steps = 12;
        switch style{
        case .gray:
            self.color = UIColor.darkGray
            self.finSize = CGSize(width: 2, height: 5);
            self.indicatorRadius = 5;
            break
            
        case .white:
            self.color = UIColor.white
            self.finSize = CGSize(width: 2, height: 5)
            self.indicatorRadius = 5
            break
            
            case .medium:
                      
                      break
            case .large:
                
                break
            
        default:
            self.color = UIColor.white
            self.cornerRadii = CGSize(width: 2, height: 2)
            self.finSize = CGSize(width: 3, height: 9)
            self.indicatorRadius = 8
            break
      
                   
        }
       
        isAnimating = false
        if (hidesWhenStopped == true){
           self.isHidden = true
        }
        
        
    }
    
func startAnimating(){
        if(self.isAnimating == true){
            return
        }
        currStep = self.direction == .hzActivityIndicatorDirectionClockwise ? CGFloat(self.steps! - 1): 0
        timer = Timer.scheduledTimer(timeInterval: Double(stepDuration!), target: self, selector: #selector(LTActivityIndicatorView._repeatAnimation(_:)), userInfo: nil, repeats: true)
        self.isAnimating = true
        if (hidesWhenStopped == true){
            self.isHidden = false
        }
    }
    
    func stopAnimating(){
        if(timer != nil){
            timer?.invalidate()
            timer = nil
        }
        self.isAnimating = false;
        if (hidesWhenStopped == true){
            self.isHidden = true
        }
    }
    
    func isAnimation() -> Bool{
        return self.isAnimating!
    }
    
    func setIndicatorRadius(_ indicatorRad:Int) ->(){
        self.indicatorRadius = indicatorRad
//        debugPrint("indicatorRadius \(indicatorRadius)")
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: CGFloat(indicatorRadius!*2) + CGFloat(finSize!.height*2), height: CGFloat(indicatorRadius!*2) + CGFloat(finSize!.height*2))
        self.setNeedsDisplay()
    }
    
    func setSteps(_ stepsActivity:Int)->(){
        anglePerStep = (360.0 / CGFloat(stepsActivity)) * CGFloat(Double.pi) / 180.0
        steps = stepsActivity
//        debugPrint("steps \(steps)")
        self.setNeedsDisplay()
    }
    
    func setFinSize(_ finsize:CGSize){
        finSize = finsize
        self.setNeedsDisplay()
    }
    
//    func setProgress(progressSize:CGFloat){
//        progress = progressSize
//        self.setNeedsDisplay()
//    }
    
    func _colorForStep(_ stepIndex:Int) ->(UIColor){
        let alpha = 1.0 - CGFloat(stepIndex % steps!) * CGFloat(1.0 / CGFloat(steps!))
        let copiedColor = color?.cgColor.copy(alpha: alpha)
        let newColor = UIColor(cgColor: copiedColor!)
        return newColor
    }
    
    @objc func _repeatAnimation(_ timers: Timer){
        currStep! += 1
        self.setNeedsDisplay()
        
    }
    
    func finPathWithRect(_ rect:CGRect) ->(UIBezierPath){
        return UIBezierPath(roundedRect: rect, byRoundingCorners: roundedCoreners!, cornerRadii: cornerRadii!)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let a = self.bounds.size.width/2
        let b = self.finSize!.width/2
        
        let finRect = CGRect(x: a - b ,y: 0,width: finSize!.width,height: finSize!.height)
        let bezierPath = finPathWithRect(finRect)
        let bezierPathRef = bezierPath.cgPath.copy()
        
//        for i in 0 ..< 12 {
        
          //  print (i) //i will increment up one with each iteration of the for loop
            
//        }
//
//       for i in 0 ... steps {
        
       for i in 0...16 {
//        for (var i = 0; i < steps ; i += 1){
            if(isAnimating == false &&  progress < ((CGFloat)(i + 1) / (CGFloat)(steps!)))
            {
                break
            }
            let c:Int = Int(currStep!) + i * direction!.rawValue
            self._colorForStep(c).set()
            context?.beginPath()
            context?.addPath(bezierPathRef!);
            context?.closePath();
            context?.fillPath();
            
            context?.translateBy(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            context?.rotate(by: anglePerStep!)
            context?.translateBy(x: -(self.bounds.size.width / 2), y: -(self.bounds.size.height / 2))
        }
    }

}
