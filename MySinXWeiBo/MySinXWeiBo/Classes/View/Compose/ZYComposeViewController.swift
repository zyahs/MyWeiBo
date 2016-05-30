//
//  ZYComposeViewController.swift
//  MySinXWeiBo
//
//  Created by 飞奔的羊 on 16/5/19.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import SVProgressHUD

class ZYComposeViewController: UIViewController,UITextViewDelegate {
// MARK: ------懒加载控件-右侧的按钮------
	private lazy var rightButton: UIButton = {
	let button = UIButton()
	button.addTarget(self, action: #selector(ZYComposeViewController.sendAction), forControlEvents: .TouchUpInside)
		button.setTitle("发送", forState: .Normal)
		button.titleLabel?.font = UIFont.systemFontOfSize(15)
		
		//设置背景图片
		button.setBackgroundImage(UIImage(named: "common_button_orange"), forState: .Normal)
		button.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), forState: .Highlighted)
		button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: .Disabled)
		//设置 button 文字颜色
		button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		button.setTitleColor(UIColor.grayColor(), forState: .Disabled)
		button.size = CGSize(width: 45, height: 30)
		//这里指定状态不起作用,原因是按钮被 itm 控制着
//		button.enabled =false

	return button
	}()
	
	///自定义 titleView
	private lazy var titleView: UILabel = {
	let label = UILabel(textColor: UIColor.darkGrayColor(), fontSize: 17)
		if let name = ZYUserAccountViewModel.sharedUserAccount.userAccount?.name {
			let title: String = "发微博\n\(name)"
			//获取 name 在文本里面的范围
			let range = (title as NSString).rangeOfString(name)
			//创建副文本对象
			let attributedStr = NSMutableAttributedString(string: title)
			//修改颜色
			attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: range)
			//修改字体大小
			attributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(13), range: range)
			label.attributedText = attributedStr
		} else {
		label.text = "发微博"
		}
		//多行显示
		label.numberOfLines = 0
		label.textAlignment = .Center
		label.sizeToFit()
		
		return label
	}()
	
	///定义 UITextView
	private lazy var textView: ZYComposeTextView = {
	let view = ZYComposeTextView()
		view.font = UIFont.systemFontOfSize(14)
	//设置代理
		view.delegate = self
		view.placeHolder = "请输入内容"
		//锤子方向能够滚动
		view.alwaysBounceVertical = true
		return view
	}()
	
	///设置自定义 TooBar
	
	private lazy var tooBar: ZYComposeToolBar = {
	let view = ZYComposeToolBar(frame: CGRectZero)
		return view
	}()
	
	///自定义配图
	private lazy var pictureView: ZYComposePictureView = {
	let view = ZYComposePictureView()
		view.backgroundColor = self.view.backgroundColor
	return view
	}()
	
	///自定义表情键盘
	private lazy var emoticonKeyBoard: ZYEmoticonKeyBoard = {
	let view = ZYEmoticonKeyBoard()
		//设置的大小
		view.size = CGSize(width: self.textView.width, height: 216)
		return view
	}()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
//监听键盘改变
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ZYComposeViewController.keyboardChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
		//监听表情按钮点击的通知
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ZYComposeViewController.didSectedEmoticon(_:)), name: DidSeletedEmoticonNotification, object: nil)
		//监听删除表情按钮点击的通知
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ZYComposeViewController.didSelectedDeleteEmoticon), name: DidSelectedDeleteEmoticonButtonNotification, object: nil)
		setUpUI()
    }

	private func setUpUI() {
	view.backgroundColor = UIColor.whiteColor()
		setNavUI()
		view.addSubview(textView)
		textView.addSubview(pictureView)
		 view.addSubview(tooBar)
	
		//设置约束
		textView.snp_makeConstraints { (make) in
			make.top.equalTo(view)
			make.leading.equalTo(view)
			make.trailing.equalTo(view)
			make.bottom.equalTo(tooBar.snp_top)
		}
		tooBar.snp_makeConstraints { (make) in
			make.bottom.equalTo(view)
			make.leading.equalTo(view)
			make.trailing.equalTo(view)
			make.height.equalTo(44)
		}
		pictureView.snp_makeConstraints { (make) in
			make.top.equalTo(textView).offset(100)
			make.centerX.equalTo(textView)
			make.width.equalTo(textView).offset(-20)
			make.height.equalTo(textView.snp_width).offset(-20)
		}
		
		tooBar.didSeletedButtonClosure = {
			[weak self] (type: ZYComposeToolBarButtonType) in
			switch type {
			case .Picture:
				//选择图片
				print("pciture")
				self?.didSelectedPicture()
			case .Mention:
				print("Mention")
			case .Trend:
				print("Trend")
			case .Emoticon:
//				print("Emotion")
				self?.didSelectedEmoticon()
			case .Add:
				print("Add")
			}
			
		}
			//点击图片按钮回调
			pictureView.didSelectAddImageClosure = { [weak self] in
			self?.didSelectedPicture()
		
			
		}
		
	}
	//设置导航栏视图
	private func setNavUI() {
	navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", fontSize: 15, target: self, action: #selector(ZYComposeViewController.cancleAction))
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
		//右侧按钮不可用
		navigationItem.rightBarButtonItem?.enabled = false
		//自定义 titleView
		navigationItem.titleView = titleView
	}
	// MARK: ------点击事件------
	
	@objc private func cancleAction() {
	self.view.endEditing(true)
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	@objc private func sendAction() {
		//  发送的带有图片的微博
		
		if pictureView.images.count > 0 {
			upload()
		} else{
			update()
		}
		
	}
	
	//  发送带文字的微博接口
	private func update() {
		//  带有文字的微博
		//   准备参数
		let accesstoken = ZYUserAccountViewModel.sharedUserAccount.accessToken!
		let status = textView.emoticonText
		
		//  请求发送微博接口
		
		SVProgressHUD.show()
		
		ZYNetWorkTools.sharedTools.update(accesstoken, status: status) { (response, error) -> () in
			if error != nil {
				SVProgressHUD.showErrorWithStatus("网络请求异常")
				return
			}
			
			SVProgressHUD.showSuccessWithStatus("发送成功")
		}
	}
	
	//  发送带图片的微博请求
	private func upload() {
		//   准备参数
		let accesstoken = ZYUserAccountViewModel.sharedUserAccount.accessToken!
		let status = textView.emoticonText//textView.text!
		
		SVProgressHUD.show()
		
		//  调用发图片微博接口
		let image = pictureView.images.first!
		
		ZYNetWorkTools.sharedTools.upload(accesstoken, status: status, image: image, callBack: { (response, error) -> () in
			if error != nil {
				SVProgressHUD.showErrorWithStatus("网络异常")
				return
			}
			
			SVProgressHUD.showSuccessWithStatus("发送成功")
		})
		

		
	}
	// MARK: ------键盘监听事件------
	@objc private func keyboardChangeFrame(noti: NSNotification) {
		let keyboardFrame = (noti.userInfo!["UIKeyboardFrameEndUserInfoKey"]! as! NSValue).CGRectValue()
		let animationDuration = (noti.userInfo!["UIKeyboardAnimationDurationUserInfoKey"]! as! NSNumber).doubleValue
		//更新约束
		tooBar.snp_updateConstraints { (make) in
			make.bottom.equalTo(view).offset(keyboardFrame.origin.y - view.frame.size.height)
		}
		UIView.animateWithDuration(animationDuration) { 
			self.view.layoutIfNeeded()
		}
	
	}
	// MARK: ------监听删除表情按钮点击------
	@objc private func didSelectedDeleteEmoticon() {
	//删除 tetxView 内容
		textView.deleteBackward()
	}
	
	// MARK: ------监听表情按钮的点击------
	@objc private func didSectedEmoticon(noti: NSNotification) {
		guard let emoticon = noti.object as? ZYEmoticon else {
		return
		}
		//封装出入表情副文本
		textView.insertEmoticon(emoticon, font: textView.font!)
		
	}
	// MARK: ------UITextViewDelegate 实现------
	func textViewDidChange(textView: UITextView) {
		navigationItem.rightBarButtonItem?.enabled = textView.hasText()
	}
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		self.view.endEditing(true)
	}
	
	deinit{
	NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
}

extension ZYComposeViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
	//点击表情的操作
	func didSelectedEmoticon(){
		if textView.inputView == nil {
			//设置表情键盘视图
			textView.inputView = emoticonKeyBoard
			//设置表情按钮 icon
			tooBar.showEmoticonIcon(true)
		} else {
		//设置系统键盘视图
			textView.inputView = nil
			//设置标签按钮 icon
			tooBar.showEmoticonIcon(false)
		
		}
		//获取第一响应者
		textView.becomeFirstResponder()
		//重新加载自定义的 intputView
	 textView.reloadInputViews()
	}
	
	//点击图片操作
	func didSelectedPicture() {
		let pictureVc = UIImagePickerController()
		
		pictureVc.delegate = self
		
		//  是否支持这种类型
		if UIImagePickerController.isSourceTypeAvailable(.Camera) {
			pictureVc.sourceType = .Camera
		} else {
			pictureVc.sourceType = .PhotoLibrary
		}
		
		// 判断前置摄像头是否可用
		if UIImagePickerController.isCameraDeviceAvailable(.Front) {
			print("前置摄像头可用")
		} else if UIImagePickerController.isCameraDeviceAvailable(.Rear) {
			print("后置摄像头可用")
		} else {
			print("摄像头不可用")
		}
		//  可用编辑
		//        pictureVc.allowsEditing = true
		
		presentViewController(pictureVc, animated: true, completion: nil)
	}
//UIImagePickerControllerDelegate 实现代理方法
	//实现代理方法自己调用 dismis
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		//获取压缩后的图片
		let scaleImage = image.scaleImageWithWidth(300)
		
		pictureView.addImage(scaleImage)
		picker.dismissViewControllerAnimated(true, completion: nil)
	}
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		picker.dismissViewControllerAnimated(true, completion: nil)
	}
	
}




















