//
//  ZYTabBar.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/12.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

//协议需要继承自 NSObjectProtocol,需要使用 weak 去修饰
protocol ZYTabBarDelegate: NSObjectProtocol {
	//点击撰写按钮回调的方法
	func didSelectedComposeButton()
	
}
class ZYTabBar: UITabBar {
	 //设置闭包
	var composeButtonClouser: (() -> ())?
	
	//UITabBar 有 delegate 的属性,不能重名
	weak var zyDelegate: ZYTabBarDelegate?
	
	// MARK: ------使用懒加载------
	//创建撰写按钮
	
	private lazy var composeButton: UIButton = {
		let button = UIButton()
		
		button.addTarget(self, action: #selector(ZYTabBar.composeButtonClick), forControlEvents: .TouchUpInside)
		//设置背景图片
		button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: .Normal)
		
		button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: .Highlighted)
		
		//设置图片
		button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: .Normal)
		button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: .Highlighted)
		button.sizeToFit()
	
	
	
	return button
	}()
	//手写代码创建对象,用一下方法
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpUI()
	}
	
	//使用 xib 或者 storyboard 创建视图的时候回执行
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setUpUI() {
	addSubview(composeButton)
	
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		//设置撰写按钮的位置
		composeButton.center.x = frame.size.width * 0.5
		composeButton.center.y = frame.size.height * 0.5
		//计算子视图按钮大小
		let itemWidth = frame.size.width / 5
		//记录当前遍历的是第几个 UITabBarButton
		var index = 0
		//遍历子视图
		for childView in subviews
		{
			//UITabBarButton 不能直接使用
			if childView.isKindOfClass(NSClassFromString("UITabBarButton")!) {
		//设置子视图的宽度
				childView.frame.size.width = itemWidth
				//设置 x
				childView.frame.origin.x = CGFloat(index) * itemWidth
				index += 1
				//将显示第三个子视图的时候需要再次++,跳过加号按钮的位置
				if index == 2 {
					index += 1
				}
				
				
			}
			
			
		}
		
		
	}
	// MARK: ------点击事件------
	//使用 private 修饰的函数在 swift 运行循环里面是找不到的
	//@objc 告诉系统我们使用 oc 动态运行机制,去调用这个函数
	@objc private func composeButtonClick() {
	
	print("guagua")
		//执行闭包
		composeButtonClouser?()
		
		//使用代理对象,调用代理方法
		zyDelegate?.didSelectedComposeButton()
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


}
