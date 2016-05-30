//
//  ZYHomeTableViewController.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
// 重用标记
private let HomeTableViewCellIdentifier = "HomeTableViewCellIdentifier"
private var B: Bool = false
class ZYHomeTableViewController: ZYVisitorTableViewController {
//获取微博数据
	
	private lazy var statusListViewModel: ZYStatusListViewModel = ZYStatusListViewModel()
	///上拉加载视图
	private lazy var pullUpView: UIActivityIndicatorView = {
	let view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
		view.color = UIColor.redColor()
	return view
	}()
	///系统下拉刷新
	private lazy var refreshCtr: UIRefreshControl = {
	let ctr = UIRefreshControl()
		return ctr
	
	}()
	///自定义的下拉刷新
	private lazy var pullDownView: ZYTestRefreshControl = {
	let ctr = ZYTestRefreshControl()
		return ctr
	}()
	//tip 动画的控件
	private lazy var tipLabel: UILabel = {
	let label = UILabel(textColor: UIColor.whiteColor(), fontSize: 12)
		label.textAlignment = .Center
		label.backgroundColor = UIColor.orangeColor()
		label.hidden = true
	return label
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		if userLogin {
	setUpTabView()
			setUpUI()
			loadStatus()
//			statusListViewModel.requestStatus({ (isSuccess) in
//				if isSuccess {
//				self.tableView.reloadData()
//				}
//			})
		} else {
			//  未登录情况下
			//  访客视图信息
			visitorView?.setVistorInfo(nil, imageName: nil)
		}
		
    }
	private func setUpUI() {
	//把 tip 视图添加到导航栏下面
		if let nav = self.navigationController {
			tipLabel.frame = CGRectMake(0, CGRectGetMaxY(nav.navigationBar.frame) - 35, tableView.frame.size.width, 35)
			nav.view.insertSubview(tipLabel, belowSubview: nav.navigationBar)
		}
	
	}
	
	private func loadStatus() {
		let beginDate = NSDate()
	statusListViewModel.requestStatus(pullUpView.isAnimating()) { (isSuccess, message) in
		let endDate = NSDate()
		
		let timeinternal = endDate.timeIntervalSinceDate(beginDate)
		print(timeinternal)
		
		if !self.pullUpView.isAnimating() && B == true {
		//执行动画
		self.startAnimation(message)
		}
		//闭包需要使用调用函数
		self.endRefreshing()
		if isSuccess {
		self.tableView.reloadData()
		}
		}
	
	}
	private func endRefreshing() {
	//关闭动画效果
		pullUpView.stopAnimating()
		//结束刷新
		refreshCtr.endRefreshing()
		//自定义控件结束刷新
		pullDownView.endRefreshing()
	
	}
	private func setUpTabView() {
	//UITableViewCell.self 获取对应的 Class, 相当于 xib 里面设置 identifier
		tableView.registerClass(ZYStatusTableViewCell.self, forCellReuseIdentifier: HomeTableViewCellIdentifier)
		//设置行高
//		tableView.rowHeight = 200
		//自动计算行高
		tableView.rowHeight = UITableViewAutomaticDimension
		//设置预估高度(必写)
		tableView.estimatedRowHeight = 200
		//去掉分割线
		tableView.separatorStyle = .None
	//设置上拉加载更多的视图
		tableView.tableFooterView = pullUpView
		//设置大小,防止显示出来没有留位置
		pullUpView.sizeToFit()
		//自定义下拉刷新
		pullDownView.addTarget(self, action: #selector(ZYHomeTableViewController.pullDownRefresh), forControlEvents: .ValueChanged)
		tableView.addSubview(pullDownView)
	}

	@objc private func pullDownRefresh() {
	//下拉刷新加载数据
		 B = true
			loadStatus()
		
	
	}
	
	private func startAnimation(message: String) {
	//防止执行动画再次让其执行
		if tipLabel.hidden == false {
			return
		}
	//赋值显示的内容
		tipLabel.text = message
		//显示 tipLabel
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
			self.tipLabel.hidden = false
			UIView.animateWithDuration(1, animations: { () -> Void in
				self.tipLabel.transform = CGAffineTransformMakeTranslation(0, self.tipLabel.frame.size.height)
			}) { (_) -> Void in
				
				UIView.animateWithDuration(1, animations: { () -> Void in
					//  回到原始位置
					self.tipLabel.transform = CGAffineTransformIdentity
					
					}, completion: { (_) -> Void in
						self.tipLabel.hidden = true
				})
				
			}
		})
		
		
		
	}
	func testRefresh(ctr: ZYTestRefreshControl) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
			ctr.endRefreshing()
		})
	}
	
}

//数据源代理方法
extension ZYHomeTableViewController {
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return statusListViewModel.statusList?.count ?? 0
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(HomeTableViewCellIdentifier, forIndexPath: indexPath) as! ZYStatusTableViewCell
		
		cell.statusViewModel = statusListViewModel.statusList![indexPath.row]
		
		return cell
		
		
	}
//将要显示 cell
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		//进入到华东到作用一个 cell 冰枪我们的上啦加载更多的动画没有执行,那么才能开启动画
		if indexPath.row == statusListViewModel.statusList!.count - 1 && !pullUpView.isAnimating() {
			//开启动画
			pullUpView.startAnimating()
			//数据请求
			loadStatus()
		}
	}
}























