//
//  ViewController.swift
//  D3Notice
//
//  Created by mozhenhau on 15/6/11.
//  Copyright (c) 2015年 mozhenhau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBAction func clickClearNotcie(sender: AnyObject) {
        clearAll()
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func clickShowSuc(sender: AnyObject) {
        showNoticeSuc("suc")
    }
    

    @IBAction func clickShowSucNotDisapear(sender: AnyObject) {
        showNoticeSuc("suc", time: D3NoticeManager.longTime, autoClear: false)
    }

    @IBAction func clickShowErr(sender: AnyObject) {
        showNoticeErr("err")
    }
    
    @IBAction func clickSowInfo(sender: AnyObject) {
        showNoticeInfo("info")
    }
    
    @IBAction func clickShowWait(sender: AnyObject) {
        showNoticeWait()
    }
    
    @IBAction func clickShowText(sender: AnyObject) {
        showNoticeText("text")
    }
    
    @IBAction func clickShowSuc2(sender: AnyObject) {
        D3NoticeManager.sharedInstance.showNoticeWithText(NoticeType.Success, text: "suc",time: D3NoticeManager.longTime, autoClear: true)
    }
    
    var progress:Double = 0
    var timer:NSTimer?
    var type:NoticeType = NoticeType.CircleProgress
    @IBAction func clickProgressCircle(sender: AnyObject) {
        progress = 0
        timer?.invalidate()
        type = NoticeType.CircleProgress
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateProgress:"), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func clickProgressLine(sender: AnyObject) {
        progress = 0
        timer?.invalidate()
        type = NoticeType.LineProgress
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateProgress:"), userInfo: nil, repeats: true)
    }
    

    func updateProgress(timer:NSTimer){
        progress += 0.01
        self.showProgressView(progress, type: type)
    }
}

