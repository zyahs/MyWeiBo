//
//  CommonTools.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

///切换根视图控制的通知名
let SwitchRootVCNotification = "SwitchRootVCNotification"
///点击表情按钮发送的通知名
let DidSeletedEmoticonNotification = "DidSeletedEmoticonNotification"
///点击删除表情按钮发送的通知名
let DidSelectedDeleteEmoticonButtonNotification = "DidSelectedDeleteEmoticonButtonNotification"
///获取屏幕的宽度
let ScreenWidth = UIScreen.mainScreen().bounds.size.width
///获取屏幕的高度
let ScreenHeight = UIScreen.mainScreen().bounds.size.height
///RGB 颜色创建

func RGB(red: CGFloat, greed: CGFloat, blue: CGFloat) -> UIColor {

return UIColor(red: red, green: greed, blue: blue, alpha: 1)
}

//产生一个随机颜色
func RandomColor() -> UIColor {
	let red = random() % 256
	let green = random() % 256
	let blue = random() % 256
	
	return RGB(CGFloat(red) / 255, greed: CGFloat(green) / 255, blue: CGFloat(blue) / 255)

}
