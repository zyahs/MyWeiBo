//
//  ZYEmoticonKeyBoard.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/20.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
//重用标记
private let ZYEmoticonCollectionViewCellIdentifier = "ZYEmoticonCollectionViewCellIdentifier"
///表情键盘
class ZYEmoticonKeyBoard: UIView {
///表情键盘 toolBar
	private lazy var toolBar: ZYEmoticonToolBar = {
	let view = ZYEmoticonToolBar(frame: CGRectZero)
		return view
	}()
	///表情视图
	private lazy var emoticonCollectionView: UICollectionView = {
	let flowLayout = UICollectionViewFlowLayout()
		//指定水平方向滚动
		flowLayout.scrollDirection = .Horizontal
		let view = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
		view.backgroundColor = self.backgroundColor
		//开启分页
		view.pagingEnabled = true
		//去掉水平滚动条
		view.showsHorizontalScrollIndicator = false
		//去掉锤子滚动条
		view.showsVerticalScrollIndicator = false
	//注册 cell
		view.registerClass(ZYEmoticonCollectionViewCell.self, forCellWithReuseIdentifier: ZYEmoticonCollectionViewCellIdentifier)
		view.dataSource = self
		view.delegate = self
	return view
	}()
	///分页控件
	private lazy var pageControl: UIPageControl = {
	let ctr = UIPageControl()
	ctr.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_selected")!)
		ctr.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_normal")!)
		return ctr
	}()
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setUpUI() {
	backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
		addSubview(toolBar)
		addSubview(emoticonCollectionView)
		addSubview(pageControl)
	emoticonCollectionView.snp_makeConstraints { (make) in
		make.top.equalTo(self)
		make.leading.equalTo(self)
		make.trailing.equalTo(self)
		make.bottom.equalTo(toolBar.snp_top)
		}
		toolBar.snp_makeConstraints { (make) in
			make.bottom.equalTo(self)
			make.leading.equalTo(self)
			make.trailing.equalTo(self)
			make.height.equalTo(40)
		}
		
		pageControl.snp_makeConstraints { (make) in
			make.centerX.equalTo(self)
			make.bottom.equalTo(toolBar.snp_top)
			make.height.equalTo(10)
		}
		toolBar.didSelectedEmoticonButtonClosure = { [weak self] (type: ZYEmoticonToolBarButtonType) in
			let indexPath: NSIndexPath
			
			switch type {
			case .Normal:
				print("Nomal")
				indexPath = NSIndexPath(forItem: 0, inSection: 0)
			case .Emoji:
				print("Emoji")
				indexPath = NSIndexPath(forItem: 0, inSection: 1)
			case .Lxh:
				print("Lxh")
				indexPath = NSIndexPath(forItem: 0, inSection: 2)
			}
			//滚动到指定位置
			self?.emoticonCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
			//设置 pageCOntrol
			self?.setPageControData(indexPath)
		}
	}
	
	
	
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		//获取布局方式
		let flowLayout = emoticonCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
		//没有 cell 大小就喝我们表情视图的大小一样
		flowLayout.itemSize = emoticonCollectionView.size
		//设置水平间距
		flowLayout.minimumInteritemSpacing = 0
		//盒子锤子间距
		flowLayout.minimumLineSpacing = 0
		
	}
	
	///设置 pageContro 数据
	private func setPageControData(indexPath: NSIndexPath) {
	pageControl.numberOfPages = ZYEmoticonTools.sharedTools.allEmoticons[indexPath.section].count
		pageControl.currentPage = indexPath.item
	}
}

extension ZYEmoticonKeyBoard: UICollectionViewDataSource,UICollectionViewDelegate {
//返回多少组
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return ZYEmoticonTools.sharedTools.allEmoticons.count
	}
	//每组返回多少页
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return ZYEmoticonTools.sharedTools.allEmoticons[section].count
	}

	//创建 cell
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ZYEmoticonCollectionViewCellIdentifier, forIndexPath: indexPath) as! ZYEmoticonCollectionViewCell
		cell.indexPath = indexPath
		//设置表情数组元素
		cell.emotions = ZYEmoticonTools.sharedTools.allEmoticons[indexPath.section][indexPath.item]
		return cell
	}
//监听滚动获取 cell
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let contentOffsetX = scrollView.contentOffset.x
		//获取显示 cell, 无序的需要我们进行排序,然后在判断 cell 哪个显示多
		let cells = emoticonCollectionView.visibleCells().sort { (firstCell, secondCell) -> Bool in
			return firstCell.x < secondCell.x
		}
		
		//判断那个显示的多
		if cells.count == 2 {
			//获取第一个 cell
			let firstCell = cells.first!
			//获取第二个 cell
			let secondCell = cells.last!
			
			let firstCellContentOffsetX = abs(firstCell.x - contentOffsetX)
			let secondCellContentOffsetX = abs(secondCell.x - contentOffsetX)
			
			//如果第一个差值小于我们第二个差值,则第一个 cell 显示多
			let indexPath: NSIndexPath
			if firstCellContentOffsetX < secondCellContentOffsetX {
    indexPath = emoticonCollectionView.indexPathForCell(firstCell)!
			} else {
			
			indexPath = emoticonCollectionView.indexPathForCell(secondCell)!
			}
			//获取indexoath对应的 section
			let section = indexPath.section
			//设置按钮选中
			toolBar.selectEmoticonButtonWithSection(section)
			setPageControData(indexPath)
		}
	}
}


















