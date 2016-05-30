//
//  ZYStatusListViewModel.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class ZYStatusListViewModel: NSObject {
	//保存微博数据
	var statusList: [ZYStatusViewModel]?
	
	//获取微博数据
	func requestStatus(isPullUp: Bool, complete: (isSuccess: Bool, message: String)->()){
		//上啦加载使用默认的 maxid
		var maxId: Int64 = 0
		//下拉刷新使用的默认值
		var sinceId: Int64 = 0
		//上拉加载
		if isPullUp {
			//代表上拉加载更多 上拉加载要取数组里面的最后一条微博数据 id
			maxId = statusList?.last?.status?.id ?? 0
			if maxId > 0 {
    //去除重复的微博数据
				maxId -= 1
			}
		}else {
			//下拉刷新要取数组里面的第一条微博数据的 id
			sinceId = statusList?.first?.status?.id ?? 0
			
		}
		
	ZYNetWorkTools.sharedTools.requestStatus(ZYUserAccountViewModel.sharedUserAccount.accessToken!, maxId:  maxId, sinceId:  sinceId) { (response, error) in
		var message: String = "没有加载到微博数据"
		
		if error != nil {
		print("网络异常")
			complete(isSuccess: false, message: message)
			return
		
		}
		//代码执行到此说明网络请求成功
		guard let dic = response as? [String: AnyObject] else {
		print("非正确的 json 格式")
			complete(isSuccess: false, message: message)
			return
		
		}
		
		guard let statusArray = dic["statuses"] as? [[String: AnyObject]] else {
		print("非正确的 json 格式")
			complete(isSuccess: false, message: message)
			return
		}
		
		//遍历数组字典初始化模型
		var tempArray = [ZYStatusViewModel]()
		for value in statusArray {
			let status = ZYStatus(dic: value)
			//通过 status 模型转成我们需要 viewModel
			let statusViewModel = ZYStatusViewModel(status: status)
			tempArray.append(statusViewModel)
			
		}
		
		//判断 statusList是否微博 nil, 如果为 nil 则进行初始化
		if self.statusList == nil {
		self.statusList = [ZYStatusViewModel]()
		
		}
		
		
		//刷新数据
		if isPullUp {
		
		self.statusList = self.statusList! + tempArray
		} else {
		
			self.statusList = tempArray + self.statusList!
		
		}
		let count = tempArray.count
		if count > 0 {
		message = "加载了\(count)条微博数据"
		
		}
		//通过闭包回调数据
		complete(isSuccess: true, message: message)
		
		}
	
	}
	
	
	
}
