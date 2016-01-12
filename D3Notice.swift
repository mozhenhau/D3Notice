//
//  D3Notice.swift
//  D3Notice
//
//  Created by mozhenhau on 15/6/11.
//  Copyright (c) 2015年 mozhenhau. All rights reserved.
//  显示最后一个
//
import Foundation
import UIKit

extension UIViewController {
    //MARK:suc,3秒自动消失
    func showNoticeSuc(text: String) {
        D3NoticeManager.sharedInstance.showNoticeWithText(NoticeType.Success, text: text,time: D3NoticeManager.longTime, autoClear: true)
    }
    
    func showNoticeSuc(text: String,time:NSTimeInterval, autoClear: Bool) {
        D3NoticeManager.sharedInstance.showNoticeWithText(NoticeType.Success, text: text,time: time, autoClear: autoClear)
    }
    
    //MARK:err
    func showNoticeErr(text: String) {
        D3NoticeManager.sharedInstance.showNoticeWithText(NoticeType.Error, text: text,time: D3NoticeManager.longTime, autoClear: true)
    }
    func showNoticeErr(text: String,time:NSTimeInterval, autoClear: Bool) {
        D3NoticeManager.sharedInstance.showNoticeWithText(NoticeType.Error, text: text, time:time,autoClear: autoClear)
    }
    
    //MARK:info
    func showNoticeInfo(text: String) {
        D3NoticeManager.sharedInstance.showNoticeWithText(NoticeType.Info, text: text, time: D3NoticeManager.longTime,autoClear: true)
    }
    func showNoticeInfo(text: String,time:NSTimeInterval, autoClear: Bool) {
        D3NoticeManager.sharedInstance.showNoticeWithText(NoticeType.Info, text: text, time: time,autoClear: autoClear)
    }
    
    //MARK:wait 不自动消失
    func showNoticeWait() {
        D3NoticeManager.sharedInstance.showWait(D3NoticeManager.longTime,autoClear: false)
    }
    
    func showNoticeWaitAuto(time:NSTimeInterval){
        D3NoticeManager.sharedInstance.showWait(time,autoClear: true)
    }
    
    //MARK:纯text
    func showNoticeText(text: String) {
        D3NoticeManager.sharedInstance.showText(text,time:D3NoticeManager.longTime,autoClear:true)
    }
    
    func showNoticeText(text: String,time:NSTimeInterval,autoClear:Bool) {
        D3NoticeManager.sharedInstance.showText(text,time:time,autoClear:true)
    }
    
    //MARK:进度
    func showProgressView(progress:Double){
        D3NoticeManager.sharedInstance.showProgressView(progress, type: NoticeType.CircleProgress)
    }
    
    
    func showProgressView(progress:Double,type:NoticeType){
        D3NoticeManager.sharedInstance.showProgressView(progress, type: type)
    }
    
    
    //MARK:clear
    func clearAllNotice() {
        D3NoticeManager.sharedInstance.clearNotice()
    }
    
    func clearAllProgress(){
        D3NoticeManager.sharedInstance.clearProgress()
    }
    
    func clearAll(){
        D3NoticeManager.sharedInstance.clearAll()
    }
    
    //clear wait
    func clearWaitNotice(){
        D3NoticeManager.sharedInstance.clearWait()
    }
}


enum NoticeType:Int{
    case Success = 888
    case Error
    case Info
    case OnlyText
    case Wait
    case CircleProgress = 989
    case LineProgress
}

typealias NoticeCompleteBlock = (() -> Void)?
typealias NoticeTextBlock = ((String?) -> Void)?
typealias NoticeDateBlock = ((NSDate?) -> Void)?
//MARK:通知管理类,对应每种类型只会生成一次，不作移除，隐藏在window
class D3NoticeManager: NSObject {
    private var notices = Array<UIView>()  //提示性
    private var window:UIWindow! = UIApplication.sharedApplication().keyWindow!
    static let longTime:NSTimeInterval = 2
    static let shortTime:NSTimeInterval = 1
    
    static let sharedInstance = D3NoticeManager()
    private override init() {}
    
    //菊花图
    func showWait(time:NSTimeInterval,autoClear: Bool) {
        clearNotice()
        for view in notices{
            if view.tag == NoticeType.Wait.rawValue{
                showNotice(view, time: time, autoClear: autoClear)
                return
            }
        }
        
        addNotice(D3NoticeView(type: NoticeType.Wait), time: time, autoClear: autoClear)
    }
    
    //仅文字
    func showText(text: String,time:NSTimeInterval,autoClear: Bool) {
        clearNotice()
        for view in notices{
            if view.tag == NoticeType.OnlyText.rawValue{
                (view as! D3NoticeView).label.text = text
                showNotice(view, time: time, autoClear: autoClear)
                return
            }
        }
        
        addNotice(D3NoticeView(text: text), time: time, autoClear: autoClear)
    }
    
    
    
    //有勾、叉和警告
    func showNoticeWithText(type: NoticeType,text: String,time:NSTimeInterval,autoClear: Bool) {
        clearNotice()
        for view in notices{
            if view.tag == type.rawValue{
                let noticeView = view as! D3NoticeView
                noticeView.setContent(type, text: text)
                noticeView.center = window.center
                showNotice(view, time: time, autoClear: autoClear)
                return
            }
        }
        addNotice(D3NoticeView(type: type,text: text), time: time, autoClear: autoClear)
    }
    
    //进度
    func showProgressView(progress:Double,type:NoticeType){
        for view in notices{
            if view.tag == NoticeType.CircleProgress.rawValue{
                let noticeView = view as! D3ProgressView
                noticeView.type = type
                noticeView.changeProgress(progress)
                showNotice(view, time: 0, autoClear: false)
                return
            }
        }
        addNotice(D3ProgressView(type: type), time: 0, autoClear: false)
    }
    
    //窗口管理
    func addNotice(mainView:UIView,time:NSTimeInterval,autoClear:Bool){
        if window == nil{
            self.window = UIApplication.sharedApplication().keyWindow!
        }
        
        mainView.center = window.center
        mainView.layer.zPosition = 9999999
        window.addSubview(mainView)
        notices.append(mainView)
        if autoClear {
            NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "hideNotice:", userInfo: mainView, repeats: false)
        }
    }
    
    
    func showNotice(mainView:UIView,time:NSTimeInterval,autoClear:Bool){
        mainView.hidden = false
        if autoClear {
            NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "hideNotice:", userInfo: mainView, repeats: false)
        }
    }
    
    
    func hideNotice(sender: NSTimer) {
        if let noticeView = sender.userInfo as? UIView {
            noticeView.hidden = true
        }
    }
    
    
    func clearAll() {
        for view in notices {
            view.hidden = true
        }
    }
    
    func clearNotice() {
        for view in notices {
            if view.tag >= NoticeType.Success.rawValue && view.tag <= NoticeType.Wait.rawValue{
                view.hidden = true
            }
        }
    }
    
    func clearProgress() {
        for view in notices {
            if view.tag >= NoticeType.CircleProgress.rawValue{
                view.hidden = true
            }
        }
    }
    
    func clearWait(){
        self.clear(NoticeType.Wait)
    }
    
    
    func clear(type:NoticeType){
        for view in notices {
            if view.tag == type.rawValue{
                view.hidden = true
            }
        }
    }
}


class D3NoticeView:UIView{
    var label:UILabel!
    var checkmarkView:UIImageView!
    
    convenience init(type:NoticeType){
        self.init()
        self.frame = CGRectMake(0, 0, 78, 78)
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        ai.frame = CGRectMake(21, 21, 36, 36)
        ai.startAnimating()
        self.addSubview(ai)
        self.tag = type.rawValue
    }
    
    
    convenience init(text:String){
        self.init()
        self.layer.cornerRadius = 12
        self.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        self.addSubview(label)
        self.frame = CGRectMake(0, 0, label.frame.width + 50 , label.frame.height + 30)
        
        label.center = CGPointMake(self.frame.width/2, self.frame.height/2)
        self.tag = NoticeType.OnlyText.rawValue
    }
    
    convenience init(type:NoticeType,text:String){
        self.init()
        self.frame = CGRectMake(0, 0, 90, 90)
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        checkmarkView = UIImageView(frame:CGRectMake(27, 15, 36, 36))
        self.addSubview(checkmarkView)
        
        label = UILabel(frame: CGRectMake(0, 60, 90, 16))
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
        self.tag = type.rawValue
        self.setContent(type, text: text)
    }
    
    
    func setContent(type: NoticeType,text:String){
        checkmarkView.image = self.draw(type)
        label.text = text
        label.sizeToFit()
        
        var mainViewWidth:CGFloat = 90.0
        if label.frame.width + 50 > 90{
            mainViewWidth = label.frame.width + 50.0
        }
        self.frame = CGRectMake(0, 0, mainViewWidth , self.frame.height)
        checkmarkView.center.x = self.frame.width/2
        label.center.x = self.frame.width/2
    }
    
    
    //下面是画图的
    func draw(type: NoticeType)->UIImage!{
        var image:UIImage!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
        let checkmarkShapePath = UIBezierPath()
        
        // 先画个圈圈
        checkmarkShapePath.moveToPoint(CGPointMake(36, 18))
        checkmarkShapePath.addArcWithCenter(CGPointMake(18, 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        checkmarkShapePath.closePath()
        
        switch type {
        case .Success: // 画勾
            checkmarkShapePath.moveToPoint(CGPointMake(10, 18))
            checkmarkShapePath.addLineToPoint(CGPointMake(16, 24))
            checkmarkShapePath.addLineToPoint(CGPointMake(27, 13))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 18))
            checkmarkShapePath.closePath()
        case .Error: // 画叉
            checkmarkShapePath.moveToPoint(CGPointMake(10, 10))
            checkmarkShapePath.addLineToPoint(CGPointMake(26, 26))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 26))
            checkmarkShapePath.addLineToPoint(CGPointMake(26, 10))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 10))
            checkmarkShapePath.closePath()
        case .Info:  //画警告
            checkmarkShapePath.moveToPoint(CGPointMake(18, 6))
            checkmarkShapePath.addLineToPoint(CGPointMake(18, 22))
            checkmarkShapePath.moveToPoint(CGPointMake(18, 6))
            checkmarkShapePath.closePath()
            
            UIColor.whiteColor().setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.moveToPoint(CGPointMake(18, 27))
            checkmarkShapePath.addArcWithCenter(CGPointMake(18, 27), radius: 1, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
            checkmarkShapePath.closePath()
            
            UIColor.whiteColor().setFill()
            checkmarkShapePath.fill()
            
        default:
            break
        }
        
        UIColor.whiteColor().setStroke()
        checkmarkShapePath.stroke()
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}



//进度
class D3ProgressView: UIView {
    var label:UILabel!
    var progress:Double = 0
    var type:NoticeType = NoticeType.CircleProgress
    
    convenience init(type:NoticeType){
        self.init()
        self.type = type
        self.tag =  NoticeType.CircleProgress.rawValue
        self.frame = CGRectMake(0, 0, 90, 90)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        label = UILabel(frame: CGRectMake(0, 0, 90, 90))
        label?.textAlignment = NSTextAlignment.Center
        label?.textColor = UIColor.whiteColor()
        label?.font = UIFont.systemFontOfSize(13)
        label?.text = "0.0%"
        self.addSubview(label!)
    }
    
    func changeProgress(progress:Double){
        self.progress = progress > 1 ? 1 : progress
        label?.text = "\(NSString(format:"%.1f",self.progress*100))%"
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        switch type{
        case .LineProgress:
            label.frame = CGRectMake(0,0,90,75)
            self.drawLine()
            
        default:
            self.drawCircle()
        }
    }
    
    
    private func drawCircle(){
        UIColor.whiteColor().setFill()
        let ctx = UIGraphicsGetCurrentContext()
        //拼接路径
        let center = CGPointMake(45, 45)
        let radius:CGFloat = 30
        let startA = CGFloat(-M_PI_2);
        let endA = CGFloat(-M_PI_2 + progress * M_PI * 2)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startA, endAngle: endA, clockwise: true)
        CGContextSetLineCap(ctx, CGLineCap.Round)
        CGContextSetLineWidth(ctx, 4);
        UIColor.whiteColor().set()
        CGContextAddPath(ctx, path.CGPath);
        CGContextStrokePath(ctx);
    }
    
    private func drawLine(){
        let context = UIGraphicsGetCurrentContext()
        
        // save the context
        CGContextSaveGState(context) ;
        
        // allow antialiasing
        CGContextSetAllowsAntialiasing(context, true)
        
        // we first draw the outter rounded rectangle
        let lineRect = CGRectMake(10, 55, 70, 16)
        var rect = CGRectInset(lineRect, 1.0, 1.0)
        var radius = 0.5 * rect.size.height
        
        UIColor.whiteColor().setStroke()
        CGContextSetLineWidth(context, 1.0)
        
        CGContextBeginPath(context) ;
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
        CGContextClosePath(context) ;
        CGContextDrawPath(context, .Stroke)
        
        // draw the empty rounded rectangle (shown for the "unfilled" portions of the progress
        rect = CGRectInset(lineRect, 3.0, 3.0)
        radius = 0.5 * rect.size.height
        
        UIColor.clearColor().setFill()
        
        CGContextBeginPath(context) ;
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
        CGContextClosePath(context) ;
        CGContextFillPath(context) ;
        
        // draw the inside moving filled rounded rectangle
        radius = 0.5 * rect.size.height ;
        
        // make sure the filled rounded rectangle is not smaller than 2 times the radius
        rect.size.width *= CGFloat(progress)
        if (rect.size.width < 2 * radius){
            rect.size.width = 2 * radius
        }
        
        UIColor.whiteColor().setFill()
        
        CGContextBeginPath(context) ;
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
        CGContextClosePath(context) ;
        CGContextFillPath(context) ;
        
        // restore the context
        CGContextRestoreGState(context) ;
    }
    
}