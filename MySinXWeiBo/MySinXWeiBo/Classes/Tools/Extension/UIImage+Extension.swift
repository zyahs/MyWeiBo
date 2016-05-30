//
//  UIImage+Extension.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/20.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
extension UIImage {
	///  等比压缩图片
	func scaleImageWithWidth(scaleWidth: CGFloat) -> UIImage {
		//  压缩后的宽 100 你要计算压缩后的高度
		//  比方说图片的大小传入的是 宽度 200 ,高度 300
		//  计算出压缩后的高度
		let scaleHeight = scaleWidth / self.size.width * self.size.height
		
		
		let size = CGSize(width: scaleWidth, height: scaleHeight)
		//  开启上下文
		UIGraphicsBeginImageContext(size)
		//  把图片绘制到指定区域
		self.drawInRect(CGRect(origin: CGPointZero, size: size))
		//  获取压缩后图片
		let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
		
		//  关闭上下文
		UIGraphicsEndImageContext()
		
		return scaleImage
	}
}
