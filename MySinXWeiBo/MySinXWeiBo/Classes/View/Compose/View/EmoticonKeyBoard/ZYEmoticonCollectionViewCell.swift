//
//  ZYEmoticonCollectionViewCell.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/20.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
///表情视图 cell
class ZYEmoticonCollectionViewCell: UICollectionViewCell {
	///表情数组模型
	var emotions: [ZYEmoticon]? {
		didSet{
			guard let ets = emotions else {
			return
			}
			//去除重用问题
			for value in emoticonButtons
			{
				//隐藏所有表情按钮
				value.hidden = true
			}
			//遍历赋值
			for (i, value) in ets.enumerate()
			{
				//取到 button
				let button = emoticonButtons[i]
				//设置表情模型
				button.emoticon = value
				
			}
		}
	}
	/// 保存表情 button
	private lazy var emoticonButtons: [ZYEmoticonButton] = [ZYEmoticonButton]()
	var indexPath: NSIndexPath? {
		didSet {
			guard let index = indexPath else {
			return
			}
	messageLabel.text = "当前显示的是第\(index.section)组第\(index.item)行"
		}
	}
	// MARK: ------懒加载视图------
	//显示 indexPath label
	private lazy var messageLabel: UILabel = {
	let label = UILabel(textColor: UIColor.whiteColor(), fontSize: 30)
	return label
	}()
	
	///删除按钮
	private lazy var deleteEmoticonButton: UIButton = {
	let button = UIButton()
		button.addTarget(self, action: #selector(ZYEmoticonCollectionViewCell.deleteEmoticonButtonClick), forControlEvents: .TouchUpInside)
		button.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
		button.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: .Highlighted)
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func setUpUI() {
		
		addChildButton()
		contentView.addSubview(deleteEmoticonButton)
//	contentView.backgroundColor = RandomColor()
//		contentView.addSubview(messageLabel)
//		messageLabel.snp_makeConstraints { (make) in
//			make.center.equalTo(contentView)
//		}
	}
	
	///添加表情控件
	private func addChildButton() {
	//循环遍历20个表情控件
		for _ in 0..<20
		{
			let button = ZYEmoticonButton()
			button.addTarget(self, action: #selector(ZYEmoticonCollectionViewCell.emoticonClick(_:)), forControlEvents: .TouchUpInside)
			button.titleLabel?.font = UIFont.systemFontOfSize(34)
			//添加到 contenView 里面
			contentView.addSubview(button)
			//添加到保存表情数组中
			emoticonButtons.append(button)
		}
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		//设置表情按钮的 frame
		//表情按钮的宽度
		let itemWidth = width / 7
		//表情按钮的高度
		let itemHeight = height / 3
		//遍历数组, i 代表数组的下标
		for (i, value) in emoticonButtons.enumerate()
		{
			//设置按钮的大小
			value.size = CGSize(width: itemWidth, height: itemHeight)
			//计算 col 索引
			let colIndex = i % 7
			let rowIndex = i / 7
			//设置 x 坐标
			value.x = CGFloat(colIndex) * itemWidth
			value.y = CGFloat(rowIndex) * itemHeight
			
		}
		//设置删除按钮的 frame
		deleteEmoticonButton.size = CGSize(width: itemWidth, height: itemHeight)
		//设置 x 坐标
		deleteEmoticonButton.x = width - itemWidth
		//设置 y 坐标
		deleteEmoticonButton.y = height - itemHeight
	}
	// MARK: ------点击事件------
	@objc private func emoticonClick(button: ZYEmoticonButton) {
		let emoticon = button.emoticon
		NSNotificationCenter.defaultCenter().postNotificationName(DidSeletedEmoticonNotification, object: emoticon)
		
	}
	
	@objc private func deleteEmoticonButtonClick() {
	//点击删除按钮发送通知
		NSNotificationCenter.defaultCenter().postNotificationName(DidSelectedDeleteEmoticonButtonNotification, object: nil)	
	}
}























