//
//  PhotoDisplayController.swift
//  OnTheRoadB
//
//  Created by Cunqi.X on 11/29/14.
//  Copyright (c) 2014 CS9033. All rights reserved.
//

import UIKit
class PhotoDisplayController: UIViewController {
	private var imageView: UIImageView!
	private var imageData: NSMutableArray!
	private var currIndex: Int = 0
	
	func setDisplayPhoto(imageData: NSMutableArray, index: Int) {
		self.imageData = imageData
		self.currIndex = index
	}
	
	override func loadView() {
		super.loadView()
		var contentView = UIView(frame: UIScreen.mainScreen().applicationFrame)
		self.view = contentView
		
		imageView = UIImageView(frame: self.view.frame)
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		self.view.addSubview(imageView)
	}
	
	override func viewDidLoad() {
		
		if (imageView != nil) {
			displayPhotoAtCurrentIndex()
		}
		
		let selector: Selector = "backToAlbum"
		let singleTapGestureRecongnizer = UITapGestureRecognizer(target: self, action: selector)
		singleTapGestureRecongnizer.numberOfTapsRequired = 1
		self.view.addGestureRecognizer(singleTapGestureRecongnizer)
		
		let leftSwipSelector: Selector = "leftSwipe"
		let leftSwipe = UISwipeGestureRecognizer(target: self, action: leftSwipSelector)
		leftSwipe.direction = .Right
		self.view.addGestureRecognizer(leftSwipe)
		
		
		let rightSwipeSelector: Selector = "rightSwipe"
		let rightSwipe = UISwipeGestureRecognizer(target: self, action: rightSwipeSelector)
		rightSwipe.direction = .Left
		self.view.addGestureRecognizer(rightSwipe)
	}
	
	override func didReceiveMemoryWarning() {
	}
	
	func backToAlbum() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func leftSwipe() {
		if currIndex > 0 {
			currIndex--
			displayPhotoAtCurrentIndex()
		}
	}
	
	func rightSwipe() {
		if currIndex < imageData.count - 2 {
			currIndex++
			displayPhotoAtCurrentIndex()
		}
	}
	
	func displayPhotoAtCurrentIndex() {
		self.imageView.image = (imageData.objectAtIndex(currIndex) as UIImage)
	}
}
