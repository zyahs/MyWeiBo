//
//  ZYStatusViewModel.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class ZYStatusViewModel: NSObject {
	var status: ZYStatus?
	/**
	* 转发微博内容
	*/
	var retweetContent: String?
	/**
	* 转发数
	*/
	var retweetCountContent: String?
	/**
	* 评论数
	*/
	var commentCountContent: String?
	/**
	* 赞的数
	*/
	var unlikeCountContent: String?
	/**
	* 来源
	*/
	var sourceContent: String?
	///会员等级图片
	var mbrankImage: UIImage?
	///发布时间
	var createdTime: String?
	///认证等级类型图片
	var verifiedTypeImage: UIImage?
	//时间,定义计算属性的目的是,根据当前时间和发微博时间进行计算,获取描述或者进行时间格式化
	var timeContent: String? {
	//获取发微博的时间
		guard let createAt = status?.created_at else {
		return nil
		}
	
	return NSDate.sinaDate(createAt).sinaDateString
	}
	
	///原创微博副文本
	var origianlAttributedString: NSAttributedString?
	///转发微博副文本
	var retweetAttributedString: NSAttributedString?
	
	init(status: ZYStatus) {
		super.init()
		
		self.status = status
		handleRetWeetContent(status)
		//转发数
		retweetCountContent = handleCountContent(status.reposts_count, defaultTitle: "转发")
		//评论数
		commentCountContent = handleCountContent(status.comments_count, defaultTitle: "评论")
		//赞数
		unlikeCountContent = handleCountContent(status.attitudes_count, defaultTitle: "赞")
		
		handleSourceContent(status)
		//处理会员等级图片显示
		handleMBrankImage(status.user?.mbrank ?? 0)
		//处理认证等级类型图片显示
		handleVerifiedTypeImage(status.user?.verified_type ?? 0)
		//处理微博内容的表情字符串
		//设置原创微博副文本
		origianlAttributedString = handleEmoticonContentWithStatus(status.text!)
	}
	
	///通过微博内容处理里面的表情字符串转表情副文本
	private func handleEmoticonContentWithStatus(status: String) -> NSAttributedString {
		print(status)
	//将微博内容转成副文本,便于我们后面使用直接设置给我们原创微博与转发微博的副文本
		let result = NSMutableAttributedString(string: status)
		//根据微博内容匹配表情字符串'正则表达式'
		// 1. "正则表达式"
		//usingBlock : 1.匹配格式  2. 匹配到内容的指针  3.匹配到范围的值  4. 是否停止的指针
		var matchResultArray = [ZYMatchResult]()
		(status as NSString).enumerateStringsMatchedByRegex("\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]") { (captureCount, captureString, captureRange, _) in
			//获取指针对应的内容
			//吧 NSString 转成我们需要的 NSString
			if let emoticonStr = captureString.memory as? String {
			let matchResult = ZYMatchResult(string: emoticonStr, range: captureRange.memory)
				matchResultArray.append(matchResult)
			}
		}
		//倒叙遍历
		for value in matchResultArray.reverse()
		{
			if let emoticon = ZYEmoticonTools.sharedTools.emoticonWithEmoticonStr(value.string) {
    //创建表情副文本
				let emoticonAttr = NSAttributedString.attributedWithEmoticon(emoticon, font: UIFont.systemFontOfSize(HomeFontSize))
				//替换表情副文本
				result.replaceCharactersInRange(value.range, withAttributedString: emoticonAttr)
			}
		}
		return result
	}
	
	///时间拼接
	private func handleMBrankImage(count: Int) {
		
		//合理的取值范围
		if count > 0 && count < 7 {
			mbrankImage = UIImage(named: "common_icon_membership_level\(count)")
		}
//		let string = @"Wed, 05 May 2011 10:50:00 +0800";
//		NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
//		[inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
//		[inputFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
//		NSDate* inputDate = [inputFormatter dateFromString:string];
		
	}
	
	/// 转发微博内容拼接字符串
	
	private func handleRetWeetContent(status: ZYStatus) {
		guard let retweet = status.retweeted_status?.text else {
		
		return
		}
	//代码执行到这里, retweet 一定存在
		guard let name = status.retweeted_status?.user?.screen_name else {
		
		return
		}
		//拼接转发微博的内容
		retweetContent = "@\(name): \(retweet)"
	}
	
	

	
	///处理转发,评论,赞的数据
	private func handleCountContent(count: Int, defaultTitle: String) -> String {
		if count > 0 {
			if count >= 10000 {
    //处理显示格式
				let result = CGFloat(count / 10000 / 10)
				let resultStr = "\(result)万"
				
				if resultStr.containsString(".0") {
					return resultStr.stringByReplacingOccurrencesOfString(".0", withString: "")
				}
				return resultStr
				
			} else {
			
			return "\(count)"
			}
		} else {
	return defaultTitle
			
	}
	
}
	
 private func handleVerifiedTypeImage(verified: Int) {
	//认证类型 -1 没有认证.  0 认证用户, 2,3,5 企业认证, 220 达人
	switch verified {
	case 0:
	verifiedTypeImage = UIImage(named: "avatar_vip")
		case 2,3,5:
		verifiedTypeImage = UIImage(named: "avatar_enterprise_vip")
		case 220:
		verifiedTypeImage = UIImage(named: "avatar_grassroot")
	default:
		verifiedTypeImage = nil
	}
	
	}
	
	/**
	*  处理来源数据
	*/
	private func handleSourceContent(status: ZYStatus) {
		//  判断是否存在
		guard let source = status.source else {
			return
		}
		
		//  代码执行到此,来源数据一定存在
		//  '\'转译符号
		
		if source.containsString("\">") {
			let startIndex = source.rangeOfString("\">")?.endIndex
			let endIndex = source.rangeOfString("</")?.startIndex
			
			if let start = startIndex, end = endIndex {
				sourceContent = source.substringWithRange(start..<end)
			}
			
		}
		
	}
	
	
}






























