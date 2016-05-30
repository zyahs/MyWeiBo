//
//  CZComposeTextView+Extension.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/23.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

extension ZYComposeTextView {
	///获取表情副文本对应字符串
	var emoticonText: String {
		//获取表情对应的表情文本附件
		//在指定范围内遍历副文本的属性
		var result = ""
		self.attributedText.enumerateAttributesInRange(NSMakeRange(0, self.attributedText.length), options: []) { (infoDic, range, _) in
			if let attchment = infoDic["NSAttachment"] as? ZYTextAttachment {
    //就是文本附件
				let chs = attchment.emoticon!.chs!
				result += chs
			} else {
				//文本
				let text = self.attributedText.attributedSubstringFromRange(range).string
				result += text
				
			}
		}
		return result
	}
	///插入表情副文本
	func insertEmoticon(emoticon: ZYEmoticon, font: UIFont) {
		//判断点击的表情类型
		if emoticon.type == "0" {
			///记录上一次的副文本
			let originalAttr = NSMutableAttributedString(attributedString: self.attributedText)
			/// 1. 根据表情图片路径名字创建一个 UIImage
			let image = UIImage(named: emoticon.path!)
			/// 2. 根据 UIImage 对象创建一个 NSTextAttachment( 文本附件)
			let attachment = ZYTextAttachment()
			//设置表情模型
			attachment.emoticon = emoticon
			attachment.image = image
			//取到字体的高度
			let fontHeight = font.lineHeight
			attachment.bounds = CGRect(x: 0, y: -4, width: fontHeight, height: fontHeight)
			/// 3. 根据 NSTextAttachment 创建一个 NSAttributedString( 副文本)
			let attr = NSAttributedString(attachment: attachment)
			//获取 textView 的选中范围
			var range = self.selectedRange
			//替换选中的字符串
			originalAttr.replaceCharactersInRange(range, withAttributedString: attr)
			//设置副文本的字体大小
			originalAttr.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, originalAttr.length))
			//设置副文本
			self.attributedText = originalAttr
			//每次点击表情开始位置加一
			range.location += 1
			//设置选中范围长度为0
			range.length = 0
			//设置选中范围
			self.selectedRange = range
			
			
			///发送文字改变的通知
			NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: nil)
			//自动使用代理方法? 意思判断这个可选方式是否实现
			self.delegate?.textViewDidChange?(self)
		} else {
			self.insertText((emoticon.code! as NSString).emoji())
		}
	}
}
