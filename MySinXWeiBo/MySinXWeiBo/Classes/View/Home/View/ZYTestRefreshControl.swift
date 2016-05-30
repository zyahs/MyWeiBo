//
//  ZYTestRefreshControl.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
enum TestRefreshState: Int {
	//下拉刷新
	case Normal = 0
	//松手就刷新
	case Pulling = 1
	//正在刷新
	case Refreshing = 2
}
let activityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 60, 60))
class ZYTestRefreshControl: UIControl {
	//记录当前的刷新状态
//	let activityIndicatorView1 = NVActivityIndicatorView(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width / 2 - 20, 0, 60, 60))
	var testRefreshState: TestRefreshState = .Normal {
		didSet {
			switch testRefreshState {
			case .Normal:
				//只有上一次刷新状态才去 -= 50
				if oldValue == .Refreshing {
					UIView.animateWithDuration(5, animations: {
						activityIndicatorView.x = UIScreen.mainScreen().bounds.size.width
						}, completion: { (true) in
							activityIndicatorView.x = 0
							activityIndicatorView.stopAnimation()
							
							if activityIndicatorView.x == 0 {
								UIView.animateWithDuration(0.25, animations: {
									self.currentScrollView?.contentInset.top -= 50
								})	
							}
					})
					
				}
			
			case .Pulling:
//				print(".Pulling")
				activityIndicatorView.startAnimation()
			
				
//				let activityTypes1: [NVActivityIndicatorType] = [
//					
//					.BallClipRotatePulse
//					
//				]
//				addSubview(activityIndicatorView1)
//				activityIndicatorView1.startAnimation()
			case .Refreshing:
				
			UIView.animateWithDuration(0.25, animations: {
				self.currentScrollView?.contentInset.top += 50
			})
			
    
				//告诉使用则要刷新数据
				sendActionsForControlEvents(.ValueChanged)
			
			}
		
		}
	}
	
	var currentScrollView: UIScrollView?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpUI()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setUpUI() {
//	backgroundColor = UIColor.redColor()
		let activityTypes: [NVActivityIndicatorType] = [
			
			.BallScaleRippleMultiple
			
		]
		
		
		addSubview(activityIndicatorView)
		
//		let cols = 4
//		let rows = 8
//		let cellWidth = Int(frame.width / CGFloat(cols))
//		let cellHeight = Int(frame.height / CGFloat(rows))
//		
//		for i in 0 ..< activityTypes.count {
//			let x = i % cols * cellWidth
//			let y = i / cols * cellHeight
//			let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
	
//		}
	
	}
	override func willMoveToSuperview(newSuperview: UIView?) {
		
		//判断我们的视图是否添加在我们的滚动视图上
		guard let scrollView = newSuperview as? UIScrollView else {
		return
		}
		//添加 kvo监听
		scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.New], context: nil)
		currentScrollView = scrollView
		
		//设置 frame
		frame.size.height = 50
		frame.size.width = currentScrollView!.frame.size.width
		frame.origin.y = -50
	}
	//kvo 监听方法
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		
		if currentScrollView!.dragging {
		
			//拖动情况下只有两种状态 下拉刷新状态( narmal) 2.松手就刷新(Pulling)
			let maxY = -(currentScrollView!.contentInset.top + 50)
			
			let contentOffsetY = currentScrollView!.contentOffset.y
			//判断当前的偏移量和我们 maxY 对比
			if contentOffsetY < maxY && testRefreshState == .Normal {
    //进入 pulling 状态
				testRefreshState = .Pulling
			} else if contentOffsetY >= maxY && testRefreshState == .Pulling {
			
			testRefreshState = .Normal
			}
			//拖动
		} else {
			
		//要想进入正在刷新的状态( refreshing) 1.上一次是松手就刷心动 状态
			//松手
			if testRefreshState == .Pulling {
    //正在刷新状态
				
				testRefreshState = .Refreshing
			}
			
		}
	}

	deinit {
	//移除 kvo
		currentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
	
	}
	func endRefreshing() {
		testRefreshState = .Normal
//		activityIndicatorView.stopAnimation()
	}
}














































