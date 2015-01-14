//
//  AlertHelper.swift
//  OnTheRoadB
//
//  Created by Cunqi.X on 11/29/14.
//  Copyright (c) 2014 CS9033. All rights reserved.
//

import UIKit
class AlertHelper {
	class func showActionControllerOfAddNewTrip(viewController: AddNewTripDetailViewController) {
		let alertController = UIAlertController(title: "Add Photo", message: "Add photo you want to post.", preferredStyle: UIAlertControllerStyle.ActionSheet)
		
		//take photo
		func takePhotoAction(action: UIAlertAction!) {
			let imagePicker = viewController.imageHelper.getImagePicker()
			
			if(UIImagePickerController.isSourceTypeAvailable(.Camera)) {
				imagePicker.sourceType = .Camera
				viewController.presentViewController(imagePicker, animated: true, completion: nil)
			}else {
				println("Simulator does not support camera.")
			}
		}
		let takePhoto: UIAlertAction = UIAlertAction(title: "Camera", style: .Default, handler: takePhotoAction)
		
		func choosePhotoAction(action: UIAlertAction!) {
			let imagePicker = viewController.imageHelper.getImagePicker()
			imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
			viewController.presentViewController(imagePicker, animated: true, completion: nil)
		}
		let choosePhoto: UIAlertAction = UIAlertAction(title: "Photo Library", style: .Default, handler: choosePhotoAction)
		
		let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
		
		alertController.addAction(takePhoto)
		alertController.addAction(choosePhoto)
		alertController.addAction(cancel)
		
		viewController.presentViewController(alertController, animated: true, completion: nil)
	}
	
	
	class func showLoadingAlertOfSavingPhoto()-> UIAlertController {
		let alertController = UIAlertController(title: nil, message: "Loading...\n\n", preferredStyle: UIAlertControllerStyle.Alert)
		
		var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
		activityIndicator.center = CGPointMake(130.5, 65.5)
		
		activityIndicator.startAnimating()
		
		alertController.view.addSubview(activityIndicator)
		return alertController
	}
	class func dismiss(alertController: UIAlertController, completion: (() -> Void)) {
		alertController.dismissViewControllerAnimated(true, completion: completion)
	}
}
