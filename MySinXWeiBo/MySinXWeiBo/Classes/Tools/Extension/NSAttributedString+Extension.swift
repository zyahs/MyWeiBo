//
//  NSAttributedString+Extension.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/23.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit


extension NSAttributedString {
///根据表情模型和字体对象创建一个副文本对象
	class func attributedWithEmoticon(emoticon: ZYEmoticon, font: UIFont) -> NSAttributedString {
	//1. 根据表情图片路径名字创建一个 UIImage
		let image = UIImage(named: emoticon.path!)
	//2. 根据 UIImage 对象创建一个 NSTextAttachment( 文本附件)
		let attachtment = ZYTextAttachment()
		//设置表情模型
		attachtment.emoticon = emoticon
		attachtment.image = image
		//取到字体的高度
		let fontHeight = font.lineHeight
		attachtment.bounds = CGRect(x: 0, y: -4, width: fontHeight, height: fontHeight)
	//3. 根据 NSTextAttachment 创建一个 NSAttributedString( 副文本)
		let attr = NSAttributedString(attachment: attachtment)
		return attr
		
	}
}





























