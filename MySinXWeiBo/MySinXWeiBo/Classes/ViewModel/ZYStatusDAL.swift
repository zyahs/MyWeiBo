//
//  ZYStatusDAL.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/28.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class ZYStatusDAL: NSObject {
 //  加载数据
	class func loadData(maxId: Int64, sinceId: Int64, callback: (statuses: [[String: AnyObject]]) -> ()) {
		
		//  创建数组
		let tempArray = [[String: AnyObject]]()
		
		//  1.查询本地是否有缓存数据 (完成)
		let result = checkCacheData(maxId, sinceId: sinceId)
		//  2.如果有缓存数据则直接返回缓存数据
		if result.count > 0 {
			callback(statuses: result)
			return
		}
		//  3.如果没有缓存数据则从网络加载
		
		ZYNetWorkTools.sharedTools.requestStatus(ZYUserAccountViewModel.sharedUserAccount.accessToken!, maxId: maxId, sinceId: sinceId) { (response, error) -> () in
			
			if error != nil {
				print("网络请求异常")
				callback(statuses: tempArray)
				return
			}
			
			//  代码执行到此说明我们网络请求成功
			guard let dic = response as? [String: AnyObject] else {
				print("不是一个正确的json格式")
				callback(statuses: tempArray)
				return
			}
			
			guard let statusesArray = dic["statuses"] as? [[String: AnyObject]] else {
				print("不是一个正确的json格式")
				callback(statuses: tempArray)
				return
			}
			
			//  4.网络加载完成后,把网络数据缓存到本地 (完成)
			ZYStatusDAL.cacheData(statusesArray)
			
			//  5.把网络加载后数据返回
			callback(statuses: statusesArray)
		}
		
		
		
	}
	
	class func checkCacheData(maxId: Int64, sinceId: Int64) -> [[String: AnyObject]] {
		
		//SELECT * FROM Status where statusid > 3978603153081176 and userid = 1800530611 order by statusid desc limit 20
		
		var sql = "SELECT statusid, status, userid FROM Status\n"
		if maxId > 0 {
			sql += "where statusid < \(maxId)\n"
		} else {
			sql += "where statusid > \(sinceId)\n"
		}
		sql += "and userid = \(ZYUserAccountViewModel.sharedUserAccount.userAccount!.uid)\n"
		//  排序方式
		sql += "order by statusid desc\n"
		//  返回多少记录
		sql += "limit 20\n"
		
		let result = SqliteManger.manager.queryResultSetWithSql(sql)
		
		var tempArray = [[String: AnyObject]]()
		
		for value in result {
			//  取到微博数据转字典
			let statusData = value["status"]! as! NSData
			let statusDic =  try! NSJSONSerialization.JSONObjectWithData(statusData, options: []) as! [String: AnyObject]
			tempArray.append(statusDic)
		}
		
		
		return tempArray
	}
	
	
	//  保存首页数据
	class func cacheData(status: [[String: AnyObject]]) {
		//  准备sql语句
		let sql = "INSERT INTO STATUS(STATUSID, STATUS, USERID) VALUES(?,?,?)"
		let userid = ZYUserAccountViewModel.sharedUserAccount.userAccount!.uid
		//  执行sql语句 , 使用事务保证数据的完整性
		SqliteManger.manager.queue?.inTransaction({ (db, rollback) -> Void in
			
			
			for value in status {
				// Int64 不能直接放到数组里面需要转成字符串
				let statusid = value["id"]!
				//  把字典转jsondata
				let statusData = try! NSJSONSerialization.dataWithJSONObject(value, options: [])
				
				//  依次执行
				let result = db.executeUpdate(sql, withArgumentsInArray: ["\(statusid)", statusData, "\(userid)"])
				
				if result == false {
					// 如果插入失败回滚数据
					rollback.memory = true
					
					break
				}
				
				
				//                if result {
				//                    print("缓存成功")
				//                } else {
				//                    print("缓存失败")
				//                }
				
			}
			
			
			
		})
		
		
	}
	
	
	//  清除缓存数据
	class  func clearCacheData() {
		
		let date = NSDate().dateByAddingTimeInterval(-60 * 30)
		
		let dateFormater = NSDateFormatter()
		dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
		dateFormater.locale = NSLocale(localeIdentifier: "en_US")
		//  获取时间字符串
		let dateStr = dateFormater.stringFromDate(date)
		
		
		//  准备sql语句
		let sql = "DELETE FROM STATUS WHERE TIME < '\(dateStr)'"
		
		//  执行sql语句
		SqliteManger.manager.queue?.inDatabase({ (db) -> Void in
			let result = db.executeUpdate(sql, withArgumentsInArray: nil)
			if result {
				//  操作后影响了多少条数据
				//                db.changes()
				print("清除缓存成功\(db.changes())")
			} else {
				print("清除缓存失败")
			}
		})
		
		
		
		
	}
}
