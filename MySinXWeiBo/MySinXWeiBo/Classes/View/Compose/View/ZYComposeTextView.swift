//
//  ZYComposeTextView.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/19.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class ZYComposeTextView: UITextView {

// MARK: ------懒加载占位文字 Label------
	private lazy var placeHolderLabel: UILabel = {
	let label = UILabel()
	label.font = UIFont.systemFontOfSize(12)
		label.text = "捏咪咪"
		label.numberOfLines = 0
		return label
	}()
	//设置占位文字,让属性可以在 xib 中使用
	@IBInspectable var placeHolder: String? {
		didSet{
		placeHolderLabel.text = placeHolder
		}
	}
	//重写 font
	override var font: UIFont? {
		didSet{
			if font == nil {
    return
			}
			placeHolderLabel.font = font
		}
	}
	//重写 text
	override var text: String! {
		didSet{
		placeHolderLabel.hidden = hasText()
		}
	}
	
	//加载用
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
	setUpUI()
		//监听文字改变的通知
		NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ZYComposeTextView.textChange) , name: UITextViewTextDidChangeNotification, object: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setUpUI()
		//  监听文字改变的通知
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ZYComposeTextView.textChange), name: UITextViewTextDidChangeNotification, object: nil)
	}
	
	private func setUpUI() {
	addSubview(placeHolderLabel)
		//使用系统的约束
		placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
		
		addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: -10))
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		//指定位置
		placeHolderLabel.x = 5
		placeHolderLabel.y = 8
	}
	
	@objc private func textChange() {
	
	placeHolderLabel.hidden = hasText()
	}
	deinit{
	NSNotificationCenter.defaultCenter().removeObserver(self)
	}
}




















