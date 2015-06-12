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
        clearAllNotice()
    }
    
    @IBAction func clickShowSuc(sender: AnyObject) {
        showNoticeSuc("suc")
    }
    

    @IBAction func clickShowSucNotDisapear(sender: AnyObject) {
        showNoticeSuc("suc", time: D3Notice.longTime, autoClear: false)
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
}

