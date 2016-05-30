//
//  ZYStatus.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
//微博数据模型
class ZYStatus: NSObject {
//发微博时间
	var created_at: String?
	//微博 ID
	var id: Int64 = 0
	/**
	*  微博内容
	*/
	var text: String?
	/**
	*  微博来源
	*/
	var source: String?
	/**
	*  用户模型
	*/
	var user: ZYUser?
	/**
	*  转发微博模型
	*/
	var retweeted_status: ZYStatus?
	/**
	*  转发数
	*/
	var reposts_count: Int = 0
	/**
	*  评论数
	*/
	var comments_count: Int = 0
	/**
	*  赞数
	*/
	var attitudes_count: Int = 0

	///   配图数据
	var pic_urls: [ZYStatusPictureInfo]?
	/**
	*  kvc 构造函数
	*/
	init(dic: [String: AnyObject]) {
		super.init()
		setValuesForKeysWithDictionary(dic)
	}
	override func setValue(value: AnyObject?, forKey key: String) {
		if key == "user" {
			guard let dic = value as? [String: AnyObject] else {
			return
			}
			user = ZYUser(dic: dic)
		} else if key == "retweeted_status" {
		
			guard let dic = value as? [String: AnyObject] else {
			
			return
			}
			//自定义字典转模型
			retweeted_status = ZYStatus(dic: dic)
		
		} else if key == "pic_urls" {
			guard let dicArray = value as? [[String: AnyObject]] else {
			return
			}
		//创建空的数组
			var tempArray = [ZYStatusPictureInfo]()
			//遍历字典数组
			for dic in dicArray
			{
				let picInfo = ZYStatusPictureInfo(dic: dic)
				tempArray.append(picInfo)
				
			}
			pic_urls = tempArray
			
		} else {
		super.setValue(value, forKey: key)
		}
	}
	override func setValue(value: AnyObject?, forUndefinedKey key: String) {
		
	}
}




















