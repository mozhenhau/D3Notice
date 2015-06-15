# D3Notice

##介绍
纯代码实现，不需要加图  
D3Notice是用swift写的IOS的自定义AlertView。包括纯文字提示，成功、失败、警告和菊花图。是扩展UIViewController的实现。  
![此处输入图片的描述][1]


  [1]: http://7vzpd0.com1.z0.glb.clouddn.com/111.gif  
  
  
##使用
###在UIViewController
对应上图的功能，直接在UIViewController里使用

    clearAllNotice()

    showNoticeSuc("suc")

    showNoticeSuc("suc", time: D3Notice.longTime, autoClear: false)

    showNoticeErr("err")

    showNoticeInfo("info")

    showNoticeWait()

    showNoticeText("text")
    
###不在UIViewController
如果不是在UIViewController,使用方法：

     D3Notice.showNoticeWithText(NoticeType.success, text: "suc",time: D3Notice.longTime, autoClear: true)
     
###Tips
配合本人github项目里的D3View可容易实现弹窗动画
地址：https://github.com/mozhenhau/D3View  
D3Notice加动画效果已集成至D3View里的D3Notice

     
##安装使用
###使用CocoaPods (iOS 8+, OS X 10.9+)

    platform :ios, '8.0'
    use_frameworks!
    
    pod 'D3Notice', '~> 1.0.0'

swift调用framework需要import D3Notice

###普通使用
只需拖动D3Notice.swift文件
