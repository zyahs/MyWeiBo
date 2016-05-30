//
//  ZYEmoticonTools.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/21.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
///读取表情数据专用类
class ZYEmoticonTools: NSObject {
///单例全局访问点
	static let sharedTools: ZYEmoticonTools = ZYEmoticonTools()
	//构造函数私有化
	private override init() {
		super.init()
	}
	///创建 emoriconbundlle 对象,因为主要都在这个 bundle
	private lazy var emoticonBundle: NSBundle = {
		let path = NSBundle.mainBundle().pathForResource("Emoticons.bundle", ofType: nil)!
		//创建 bundle 对象
		let bundle = NSBundle(path: path)!
		//返回 bundle 对象
		return bundle
	}()
	
	
	///读取默认表情
	private lazy var defaultEmoticons: [ZYEmoticon] = {
	return self.loadEmoticonWithPath("default/info.plist")
	}()
	///读取默认表情
	private lazy var emojiEmoticons: [ZYEmoticon] = {
		return self.loadEmoticonWithPath("emoji/info.plist")
	}()
	///读取默认表情
	private lazy var LxhEmoticons: [ZYEmoticon] = {
		return self.loadEmoticonWithPath("lxh/info.plist")
	}()
	///给表情视图做准备
	lazy var allEmoticons: [[[ZYEmoticon]]] = {
	//表情视图包含三个种类型的二维数组
		return [
		self.sectionWithEmoticons(self.defaultEmoticons),
		self.sectionWithEmoticons(self.emojiEmoticons),
		self.sectionWithEmoticons(self.LxhEmoticons)
		]
	}()
	
	
	
	
	///抽取读取表情方法
	private func loadEmoticonWithPath(subPath: String) -> [ZYEmoticon] {
	//pathForResource 如果不知道路径取得就是 Resources 路径
		let path = self.emoticonBundle.pathForResource(subPath, ofType: nil)!
		//加载 plist 资源数据
		let array = NSArray(contentsOfFile: path)!
		var tempArray = [ZYEmoticon]()
		//遍历数组转模型
		for dic in array
		{
			let emoticon = ZYEmoticon(dic: dic as! [String: AnyObject])
			//判断是否是图片
			if emoticon.type == "0" {
    //给我们 path 拼接路径
				//获取图片名字
				let png = emoticon.png!
				//把路径里面的最后一部分干掉
				let subPath = (path as NSString).stringByDeletingLastPathComponent
				//图片的全路径
				emoticon.path = subPath + "/" + png
			}
			tempArray.append(emoticon)
		}
		return tempArray
	}
	
	
	///计算页数,截取数据
	private func sectionWithEmoticons(emoticons: [ZYEmoticon]) -> [[ZYEmoticon]] {
	//计算页数
		let pageCount = (emoticons.count - 1) / 20 + 1
		var tempArray: [[ZYEmoticon]] = [[ZYEmoticon]]()
		//遍历页数计算截取
		for i in 0..<pageCount
		{
			//计算当前截取的索引
			let locaction = i * 20
			var length = 20
			//如果数组越界,重写计算截取个数
			if locaction + length > emoticons.count {
		length = emoticons.count - locaction
			}
			
			//截取数组元素
			let subArray = (emoticons as NSArray).subarrayWithRange(NSMakeRange(locaction, length)) as! [ZYEmoticon]
			tempArray.append(subArray)
		}
		return tempArray
	}
	
	
	///通过表情字符串 查找表情模型
	func emoticonWithEmoticonStr(emoticonStr: String) -> ZYEmoticon? {
		
		//另一种方法
//		if let defaultEmoticon = defaultEmoticons.filter({$0.chs == emoticonStr}).first {
//			return defaultEmoticon
//		}
//		if let lxhEmoticon = lxhEmoticons.filter({$0.chs == emoticonStr}).first {
//			return lxhEmoticon
//		}
//		
	//先从默认数组中查找
		for value in defaultEmoticons
		{
			if value.chs == emoticonStr {
		return value
			}
		}
		//从浪小花数组中查找
		for value in LxhEmoticons
		{
			if value.chs == emoticonStr {
		return value
			}
		}
		return nil
	}
}























