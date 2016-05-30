//
//  NSDate+Extension.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/16.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

extension NSDate {
///根据时间字符串创建一个时间对象
	class func sinaDate(createAt: String) -> NSDate {
	//服务器返回的位置 Mon May 16 10:39:03 +0800 2016
		let dateFormatter = NSDateFormatter()
		//指定本地化信息
		dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
		//格式化时间
		dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss z yyyy"
		let createAtDate = dateFormatter.dateFromString(createAt)
		return createAtDate!
	}
	//判断是否今年
		//判断是否今天
			//判断是否1分钟之内
				//刚刚
			//判断是否1小时之前
				//xx 分钟前
			//其他
				//xx 小时前
			//判断是否昨天
				//昨天 xx
			//其他
				//MMM dd HH mm
	 //不是今年
		//yyyy MMM dd HH mm

	var sinaDateString: String? {
		let dateFormatter = NSDateFormatter()
		//设置本地化信息
		dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
		
		if isThisYear(self) {
			//是今年   NSCalendar 获取日历
			let calendar = NSCalendar.currentCalendar()
			//判断是否是今天
			if calendar.isDateInToday(self) {
    //判断是否在1分钟之内
				//获取时间差值的方式1
				//createAtDate.timeIntervalSinceDate(<#T##anotherDate: NSDate##NSDate#>)
				//获取时间差值的方式2
				//使用 abs 或者 '-'取整数
				
				let timeInterval = abs(self.timeIntervalSinceNow)
				
				if timeInterval < 60 {
					return "刚刚"
				} else if timeInterval < 3600 {
					let result = timeInterval / 60
					return "\(Int(result))分钟前"
				
				} else {
					let result = timeInterval / 3600
					return "\(Int(result))小时前"
				}

			} else if calendar.isDateInYesterday(self) {
			//昨天
				dateFormatter.dateFormat = "昨天 HH:mm"
			} else {
			//其他
				dateFormatter.dateFormat = "MM-dd HH:mm"
			}
			
		} else {
		//不是今年
			dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
		}
		
	return dateFormatter.stringFromDate(self)
	}
	
	//根据发微博时间判断是否是今年
	private func isThisYear(creatAtDate: NSDate) -> Bool {
	//获取当前时间
		let currentDate = NSDate()
		
		let dateFormatter = NSDateFormatter()
		//设置本地化信息
		
		dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
		//设置格式化方式
		dateFormatter.dateFormat = "yyyy"
	
		//获取当前时间的年份
		let currentDateYear = dateFormatter.stringFromDate(currentDate)
		//获取发微博的时间的年份
		let createAtDateYear = dateFormatter.stringFromDate(creatAtDate)
		
		return currentDateYear == createAtDateYear
		
	}
	
	

}
























































