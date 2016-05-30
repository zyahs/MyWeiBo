//
//  ZYComposeToolBar.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/19.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

enum ZYComposeToolBarButtonType: Int {
	///图片
	case  Picture = 0
	///@
	case Mention = 1
	///话题
	case Trend = 2
	///表情
	case Emoticon = 3
	///add
	case Add = 4
}
//只是一个容器,不具备渲染效果
@available(iOS 9.0, *)
class ZYComposeToolBar: UIStackView {
//设置闭包
	var didSeletedButtonClosure: ((type: ZYComposeToolBarButtonType) -> ())?
	
	///表情按钮
	var emoticonButton: UIButton?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setUpUI() {
	//指定布局方式
		axis = .Horizontal
		//填充方式,所有子空间一样宽高
		distribution = .FillEqually
	//添加按钮
		addChildButton("compose_toolbar_picture", type: .Picture)
		addChildButton("compose_mentionbutton_background", type: .Mention)
		addChildButton("compose_trendbutton_background", type: .Trend)
		emoticonButton = addChildButton("compose_emoticonbutton_background", type: .Emoticon)
		addChildButton("compose_add_background", type: .Add)
	}
	
	//添加子空间的方法
	private func addChildButton(imageName: String, type: ZYComposeToolBarButtonType)-> UIButton {
		let button = UIButton()
		//获取枚举的原始值
		button.tag = type.rawValue
		button.addTarget(self, action: #selector(ZYComposeToolBar.buttonClick(_:)), forControlEvents: .TouchUpInside)
		button.setImage(UIImage(named: imageName), forState: .Normal)
		button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: .Highlighted)
		//设置背景图片
		button.setBackgroundImage((UIImage(named: "compose_toolbar_background")), forState: .Normal)
		//去掉高亮效果
		button.adjustsImageWhenHighlighted = false
		addArrangedSubview(button)
		return button
	}
	// MARK: ------点击事件------
	@objc private func buttonClick(button: UIButton) {
	//转成枚举
		let type = ZYComposeToolBarButtonType(rawValue: button.tag)!
		
		didSeletedButtonClosure?(type: type)
	}
	//判断是否是表情键盘,如果是表情键盘,则显示,系统键盘的图片,否则显示表情图标
	func showEmoticonIcon(isEmoticon: Bool) {
	//表情键盘显示 keyboard
		var icon = "compose_emoticonbutton_background"
		
		if isEmoticon {
			icon = "compose_keyboardbutton_background"
		}
	emoticonButton?.setImage(UIImage(named: icon), forState: .Normal)
		emoticonButton?.setImage(UIImage(named: "\(icon)_highlighted"), forState: .Highlighted)
	}
}

























