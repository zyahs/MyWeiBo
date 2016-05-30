/////////
//
//  ZYStatusPictureView.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/16.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
///重用标记
private let ZYStatusPictureViewCellIdentifier = "ZYStatusPictureViewCellIdentifier"
///每项之间的间距
let itemMargin: CGFloat = 5
///计算每项图片的一个宽度
let itemWidth = (ScreenWidth - 2 * StatusTableViewCellMargin - 2 * itemMargin) / 3

///配图视图
class ZYStatusPictureView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
//绑定数据模型
	var picUrls: [ZYStatusPictureInfo]? {
		didSet {
		messageLabel.text = "\(picUrls?.count ?? 0)"
			let currentSize = calcSize(picUrls?.count ?? 0)
			//根据配图个数生成一个 CGSzie,设置大小约束
			self.snp_updateConstraints { (make) in
				make.size.equalTo(currentSize)
			}
			//重新加载数据
		reloadData()
		}
	}
// MARK: ------懒加载------
	private lazy var messageLabel: UILabel = UILabel(textColor: UIColor.redColor(), fontSize: 20)
	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		//自定义 layout
		let flowLayout = UICollectionViewFlowLayout()
		//设置大小
		flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
		//设置间距
		//设置水平间距
		flowLayout.minimumInteritemSpacing = itemMargin
		//设置锤子间距
		flowLayout.minimumLineSpacing = itemMargin
		super.init(frame: frame, collectionViewLayout: flowLayout)
	
		
		setUpUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setUpUI() {
//	backgroundView = RandomColor()
		addSubview(messageLabel)
	messageLabel.snp_makeConstraints { (make) in
		make.center.equalTo(self)
		}
		//注册 cell
		registerClass(ZYStatusPictureViewCell.self, forCellWithReuseIdentifier: ZYStatusPictureViewCellIdentifier)
		//设置数据源代理
		dataSource = self
		delegate = self
		self.backgroundColor = UIColor.redColor()
	}
	
	//根据图片数量生成 CGSize
	private func calcSize(count: Int) -> CGSize {
	//列数计算
		let cols = count > 3 ? 3 : count
		//行数计算
		let rows = (count - 1) / 3 + 1
		//当前视图的宽度
		let currentWidth = CGFloat(cols) * itemWidth + CGFloat(cols - 1) * itemMargin
		//当前视图的高度
		let currentHeight = CGFloat(rows) * itemWidth + CGFloat(rows - 1) * itemMargin
		
		return CGSize(width: currentWidth, height: currentHeight)
		
	
	}
	// MARK: ------数据源代理方法------
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return picUrls?.count ?? 0
	}
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ZYStatusPictureViewCellIdentifier, forIndexPath: indexPath) as! ZYStatusPictureViewCell
		
		//设置数据
		cell.picInfo = picUrls![indexPath.item]
		return cell
	}
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let photoBrowser = SDPhotoBrowser()
		photoBrowser.delegate = self
		photoBrowser.currentImageIndex = indexPath.item
		photoBrowser.imageCount = picUrls?.count ?? 0
		//  来源视图
		photoBrowser.sourceImagesContainerView = self
		photoBrowser.show()
		
	}
	
}

extension ZYStatusPictureView: SDPhotoBrowserDelegate {

//返回临时占位图片(即原来的小图)
	func photoBrowser(browser: SDPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
		let indexPath = NSIndexPath(forItem: index, inSection: 0)
		let cell = self.cellForItemAtIndexPath(indexPath)! as! ZYStatusPictureViewCell
		
		return cell.imageView.image
	}
//返回高质量图片 url
	func photoBrowser(browser: SDPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
		let urlStr = picUrls![index].thumbnail_pic!.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
		return NSURL(string: urlStr)
	}
}

//自定义配图 cell
class ZYStatusPictureViewCell: UICollectionViewCell {
	//设置模型
	var picInfo: ZYStatusPictureInfo? {
		didSet {
		
			guard let url = picInfo?.thumbnail_pic else {
			
			return
			}
			imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "timeline_image_placeholder"))
		gifImageView.hidden = !url.hasSuffix(".gif")
		
		}
	}
	///图片
	private lazy var imageView: UIImageView = {
	let view = UIImageView(image: UIImage(named: "timeline_image_placeholder"))
		//设置图片等比填充
		view.contentMode = UIViewContentMode.ScaleAspectFill
		//多余部分截取掉
		view.clipsToBounds = true
		return view
	}()
///gif 图片
	private lazy var gifImageView: UIImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//添加控件设置约束
	private func setUpUI() {
	contentView.addSubview(imageView)
		contentView.addSubview(gifImageView)
		
		imageView.snp_makeConstraints { (make) in
			make.edges.equalTo(contentView).offset(UIEdgeInsetsZero)
		}
			gifImageView.snp_makeConstraints { (make) in
				make.trailing.equalTo(imageView)
				make.bottom.equalTo(imageView)
		}
	
	}
	
}























