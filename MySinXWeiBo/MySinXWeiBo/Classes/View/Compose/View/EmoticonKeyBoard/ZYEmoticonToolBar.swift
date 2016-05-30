//
//  ZYEmoticonToolBar.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/20.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
enum ZYEmoticonToolBarButtonType: Int {
	//  默认
	case Normal = 1000
	//  emoji
	case Emoji = 1001
	//  浪小花
	case Lxh = 1002
}
///表情键盘 toolBar
class ZYEmoticonToolBar: UIStackView {

  ///计算上次选中按钮
	var lastSelectedButton: UIButton?
	///定义点击表情按钮的闭包
	var didSelectedEmoticonButtonClosure: ((type: ZYEmoticonToolBarButtonType)-> ())?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpUI()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setUpUI() {
	//布局方式
		axis = .Horizontal
		//填充方式
		distribution = .FillEqually
	 addChildButton("默认", bgImageName: "compose_emotion_table_left", type: .Normal)
		addChildButton("Emoji", bgImageName: "compose_emotion_table_mid", type: .Emoji)
		addChildButton("浪小花", bgImageName: "compose_emotion_table_right", type: .Lxh)
		
	}
	private func addChildButton(title: String, bgImageName: String, type: ZYEmoticonToolBarButtonType) {
		let button = UIButton()
		button.tag = type.rawValue
		button.addTarget(self, action: #selector(ZYEmoticonToolBar.emoticonButtonClick(_:)), forControlEvents: .TouchUpInside)
		button.setTitle(title, forState: .Normal)
		//设置文字颜色
		button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		button.setTitleColor(UIColor.grayColor(), forState: .Selected)
		//字体大小
	 button.titleLabel?.font = UIFont.systemFontOfSize(15)
		//设置背景图片
		button.setBackgroundImage(UIImage(named: "\(bgImageName)_normal"), forState: .Normal)
		button.setBackgroundImage(UIImage(named: "\(bgImageName)_selected"), forState: .Selected)
		//去掉高亮效果
		button.adjustsImageWhenHighlighted = false
		//添加按钮
		addArrangedSubview(button)
		//默认状态选中
		if type == .Normal {
			lastSelectedButton?.selected = false
			button.selected = true
			lastSelectedButton = button
		}
	}
	// MARK: ------点击事件------
	@objc private func emoticonButtonClick(button: UIButton) {
	//如果是用一个按钮则不执行点击事件
		if button == lastSelectedButton {
			return
		}
		//取消上一次选中状态
		lastSelectedButton?.selected = false
		//当前点击的按钮选中
		button.selected = true
		//记录选中按钮
		lastSelectedButton = button
		//记录 tag 转成枚举
		let type = ZYEmoticonToolBarButtonType(rawValue: button.tag)!
		//执行闭包
		didSelectedEmoticonButtonClosure?(type: type)
	}
	
	//根据传入的 section 判断选中那个按钮
	func selectEmoticonButtonWithSection(section: Int) {
	//如果 tag 是0取到的不是按钮,而是当前控件
	//判断 tag 判断是否是同一个按钮,如果是不需要选中
		if section + 1000 == lastSelectedButton?.tag {
		return
		}
		let button = viewWithTag(section + 1000) as! UIButton
		lastSelectedButton?.selected = false
		button.selected = true
		lastSelectedButton = button
	}
}






















