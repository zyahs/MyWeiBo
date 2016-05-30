//
//  ZYComposePictureView.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/19.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
private let ZYComposePictureViewIdentifier = "ZYComposePictureViewIdentifier"

class ZYComposePictureView: UICollectionView,UICollectionViewDataSource, UICollectionViewDelegate {
	///点击加号按钮的闭包
	var didSelectAddImageClosure: (()->())?
	///存储图片的数组
	lazy var images: [UIImage] = [UIImage]()
	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		let flowLayout = UICollectionViewFlowLayout()
		super.init(frame: frame, collectionViewLayout: flowLayout)
		setUpUI()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setUpUI() {
		hidden = true
		//注册 cell
		registerClass(ZYComposePictureViewCell.self, forCellWithReuseIdentifier: ZYComposePictureViewIdentifier)
		//设置数据源代理
		
		dataSource = self
		delegate = self
//	backgroundColor = RandomColor()
	
	}
	func addImage(image: UIImage) {
		//添加图片显示配图
		hidden = false
	images.append(image)
		reloadData()
	
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		//每项间距
		let itemMargin: CGFloat = 5
		//每项宽度
		let itemWidth = (frame.size.width - 2 * itemMargin) / 3
		
		//获取 flowLayout
		let flowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
		//指定大小
		flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
		//指定行距间距
		flowLayout.minimumInteritemSpacing = itemMargin
		flowLayout.minimumLineSpacing = itemMargin
		
		
		
	}
	
	// MARK: ------实现UICollectionViewDataSource------
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let count = images.count
		if count == 0 || count == 9 {
			return count
		} else {
			return count + 1
		}
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ZYComposePictureViewIdentifier, forIndexPath: indexPath) as! ZYComposePictureViewCell
		//判断当前 item 小于数组的个数可以取值
		if indexPath.item < images.count {
			cell.image = images[indexPath.item]
		} else {
		//显示加号按钮
			cell.image = nil
		}
		//设置删除的闭包
		cell.deleteButtonClosure = { [weak self] in
		//如果数组中没有数据则不显示配图
		self?.images.removeAtIndex(indexPath.item)
			if self?.images.count == 0 {
		self?.hidden = true
			}
			self?.reloadData()
		}
		
		return cell
	}
	//  MARK:   UICollectionViewDelegate 实现方法
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		//  取消选中
		collectionView.deselectItemAtIndexPath(indexPath, animated: true)
		
		//  如果当前item的索引等于我们数组的个数代表是加号按钮
		if indexPath.item == images.count {
			print("加号按钮")
			didSelectAddImageClosure?()
		}
		
		
	}
	
}



//自定义配图 cell
class ZYComposePictureViewCell: UICollectionViewCell {
///点击删除图片按钮的闭包
	var deleteButtonClosure: (()->())?
	//设置图片
	var image: UIImage? {
		didSet {
			if image == nil {
    //显示加号按钮
				imageView.image = UIImage(named: "compose_pic_add")
				//添加高亮图片
				imageView.highlightedImage = UIImage(named: "compose_pic_add_highlighted")
				//隐藏删除按钮
				deleImageButton.hidden = true
			} else {
			//设置图片
				imageView.image = image
				imageView.highlightedImage = nil
				//显示删除按钮
				deleImageButton.hidden = false
			}
		}
	}

	// MARK: ------懒加载控件------
	///显示的图片
	private lazy var imageView: UIImageView = UIImageView(image: UIImage(named: "timeline_image_placeholder"))
	///显示删除图片按钮
	private lazy var deleImageButton: UIButton = {
	let button = UIButton()
		button.addTarget(self, action: #selector(ZYComposePictureViewCell.deleteImageButtonClick), forControlEvents: .TouchUpInside)
		button.setImage(UIImage(named: "compose_photo_close"), forState: .Normal)
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
	contentView.addSubview(imageView)
		contentView.addSubview(deleImageButton)
		//设置控件约束
		imageView.snp_makeConstraints { (make) in
			make.edges.equalTo(contentView).offset(UIEdgeInsetsZero)
		}
		deleImageButton.snp_makeConstraints { (make) in
			make.top.equalTo(imageView)
			make.trailing.equalTo(imageView)
		}
	
	}
		// MARK: ------点击事件------
	@objc private func deleteImageButtonClick() {
	print("删除")
	deleteButtonClosure?()
	}
	
}


















