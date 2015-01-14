//
//  TripImageHelper.swift
//  OnTheRoadB
//
//  Created by Cunqi.X on 11/29/14.
//  Copyright (c) 2014 CS9033. All rights reserved.
//

import UIKit
class TripImageHelper: NSObject,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	init(viewController: AddNewTripDetailViewController) {
		super.init()
		fileHelper = FileHelper()
		fileHelper.setCurrentFolderPath(viewController.currentTrip.name)
		
		self.viewController = viewController

		imageData.addObject(UIImage(named: defaultAddImagePath)!)
		
		imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		
	}
	
	/*Important method of creating cell*/
	func generateNewCollectionCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as TripImageCell
		cell.tag = indexPath.row
		cell.deleteBtn.tag = indexPath.row
		cell.thumbNail.image = (imageData.objectAtIndex(indexPath.row) as UIImage)
		cell.deleteBtn.addTarget(self, action: "deleteCurrentImage:", forControlEvents: UIControlEvents.TouchUpInside)
		
		if(isEditMode) {
			if(indexPath.row == getLastIndexOfImageData()) {
				cell.deleteBtn.hidden = true
			}else {
				cell.deleteBtn.hidden = false
			}
		}else {
			cell.deleteBtn.hidden = true
		}
		return cell
	}
	
	func getImagePicker() -> UIImagePickerController {
		return imagePicker
	}
	
	func activeEditMode() {
		isEditMode = !isEditMode 
		viewController.imageCv.reloadData()
	}
	
	/*Implement Delegate & DataSource Method*/
	func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		let index = getLastIndexOfImageData()
		imageData.insertObject(image, atIndex: index)
		imagePath.insertObject(fileHelper.generateRelativePath("Day\(viewController.currentDay)"), atIndex: index)

		viewController.imageCv.reloadData()
		
		picker.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func deleteCurrentImage(sender: AnyObject) {
		let cell = sender.superview!!.superview as TripImageCell
		let indexPath = viewController.imageCv.indexPathForCell(cell)
		
		imageData.removeObjectAtIndex(indexPath!.row)
		imagePath.removeObjectAtIndex(indexPath!.row)
		viewController.imageCv.deleteItemsAtIndexPaths([indexPath!])
	}
	
	/*get & set method*/
	func getImageData() -> NSMutableArray {
		return imageData
	}
	
	func getLastIndexOfImageData() -> Int {
		return imageData.count - 1
	}
	
	func getImagePath() -> NSMutableArray {
		return imagePath
	}
	
	func getFileHelper() -> FileHelper {
		return fileHelper
	}
	
	
	/*Global & Local constant*/
	private let defaultAddImagePath = "addPhoto.png"
	private let cellIdentifier = "imageCell"
	
	/*Local Varible*/
	private var fileHelper: FileHelper!
	
	private var imageData: NSMutableArray = NSMutableArray()
	private var imagePath: NSMutableArray = NSMutableArray()
	private var tagIndex = -1	//use nextTag() method to increase the count
	private var isEditMode = false
	
	private var imagePicker: UIImagePickerController!
	
	private var viewController: AddNewTripDetailViewController!
}
