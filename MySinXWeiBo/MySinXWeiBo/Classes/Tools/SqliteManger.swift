//
//  SqliteManger.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/27.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
///数据库名字
let dbName = "sinaWeibo.db"
///数据库操作类
class SqliteManger: NSObject {
///全局访问点
	static let manager: SqliteManger = SqliteManger()
	///数据库操作对象
	var queue: FMDatabaseQueue?
	///构造函数私有化
	private override init() {
		super.init()
		///数据库路径
		let dbPath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent(dbName)
		//创建数据库
		//数据库操作队列
		queue = FMDatabaseQueue(path: dbName)
		//创建表
		creatTable()
	}
	//创建表
	private func creatTable() {
	//准备 sql 语句
		let sqlPath = NSBundle.mainBundle().pathForResource("db.sql", ofType: nil)
		let sql = try! String(contentsOfFile: sqlPath!)
		
		//执行sql 语句
		queue?.inDatabase({ (db) in
			let result = db.executeStatements(sql)
			if result {
			print("创表成功")
			} else {
			print("创表失败")
			}
		})
	
	}
	///查询数据
	func select() {
	//1.准备 sql 语句
		let sql = "SELECT ID, NAME, AGR FROM T_PERSON"
		//2.执行 sql 语句
		queue?.inDatabase({ (db) in
			//查询的结果集
			let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
			//判断是否有一条记录
			while resultSet.next() {
			//获取 id 
				let id = resultSet.intForColumn("ID")
				//获取名称
				let name = resultSet.stringForColumn("NAME")
				//获取年龄
				let age = resultSet.intForColumn("AGE")
			
			}
		})
		
	}
	// 方法2
	func select2() {
		
		//  1.准备sql语句
		let sql = "SELECT ID, NAME, AGE FROM T_PERSON"
		//  2.执行sql语句
		queue?.inDatabase({ (db) -> Void in
			//  查询的结果集
			let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
			//  判断是否有一条记录
			while resultSet.next() {
				//  获取id
				let id = resultSet.intForColumnIndex(0)
				//  获取名称
				let name = resultSet.stringForColumnIndex(1)
				//  获取年龄
				let age = resultSet.intForColumnIndex(2)
				
				print("id = \(id), name = \(name), age = \(age)")
			}
			
		})
		
		
	}
	
	
	//  查询方式3
	func select3() {
		//  1.准备sql语句
		let sql = "SELECT ID, NAME, AGE FROM T_PERSON"
		//  2.执行sql语句
		queue?.inDatabase({ (db) -> Void in
			//  返回结果集
			let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
			//  组装字典
			while resultSet.next() {
				//  创建字典
				var dic: [String: AnyObject] = [String: AnyObject]()
				//  遍历列数
				for i in 0..<resultSet.columnCount() {
					//  获取列名
					let colName = resultSet.columnNameForIndex(i)
					//  获取列对应值
					let colValue = resultSet.objectForColumnIndex(i)
					//  添加键值对
					dic[colName] = colValue
					
				}
				print(dic)
				
				
			}
			
			
			
		})
		
	}
	
	//  通用的查询方式
	func queryResultSetWithSql(sql: String) -> [[String: AnyObject]] {
		
		//  定义空的数组
		var tempArray = [[String: AnyObject]]()
		
		queue?.inDatabase({ (db) -> Void in
			let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
			
			while resultSet.next() {
				//  创建空的可变字典
				var dic = [String: AnyObject]()
				
				for i in 0..<resultSet.columnCount() {
					//  获取列名
					let colName = resultSet.columnNameForIndex(i)
					//  获取列对应的值
					let colValue = resultSet.objectForColumnIndex(i)
					
					//  添加键值对
					dic[colName] = colValue
					
				}
				//  添加字典
				tempArray.append(dic)
				
				
			}
			
			
		})
		
		return tempArray
		
	}
	
	
	
	
	
	
	
	//  修改数据
	func update() {
		//  准备sql语句
		let sql = "UPDATE T_PERSON SET NAME = ?, AGE = ? WHERE ID = ?"
		//  执行SQL语句
		queue?.inDatabase({ (db) -> Void in
			let result = db.executeUpdate(sql, withArgumentsInArray: ["古天乐", 20, 2])
			if result {
				print("修改成功")
			} else {
				print("修改失败")
			}
		})
	}
	
	//  删除数据
	func delete() {
		//  准备sql语句
		let sql = "DELETE FROM T_PERSON WHERE ID = ?"
		//  执行sql语句
		queue?.inDatabase({ (db) -> Void in
			db.executeUpdate(sql, withArgumentsInArray: [4])
		})
	}

	
	
}



























