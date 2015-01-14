//
//  FileHelper.swift
//  OnTheRoadB
//
//  Created by Cunqi.X on 11/29/14.
//  Copyright (c) 2014 CS9033. All rights reserved.
//

import UIKit
class FileHelper: NSObject {
	/*Local varible*/
	private let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
	
	private let dateFormatter = NSDateFormatter()
	
	private var currentFolderPath: String!
	
	override init() {
		super.init()
		 dateFormatter.dateFormat = "yyyyMMddHHmmss"
	}
	
	func getDocumentPath() -> NSString {
		return documentPath
	}
	
	func createTripFolder(tripName: String) {
		var tripFolderPath = generateAbsoluteFolderPath(tripName)
		
		NSFileManager.defaultManager().createDirectoryAtPath(tripFolderPath, withIntermediateDirectories: true, attributes: nil, error: nil)
	}
	
	func generateAbsoluteFolderPath(tripName: String) -> String {
		return documentPath.stringByAppendingPathComponent(tripName)
	}
	
	func setCurrentFolderPath(tripName: String) {
		self.currentFolderPath = generateAbsoluteFolderPath(tripName)
		
		var isDirctory = ObjCBool(true)
		if(!NSFileManager.defaultManager().fileExistsAtPath(currentFolderPath, isDirectory: &isDirctory)) {
			createTripFolder(tripName)
		}
	}
	
	func getCurrentFolderPath() -> String {
		return currentFolderPath
	}
	
	func generateRelativePath(tripName: String) -> String {
		let timestampFileName = dateFormatter.stringFromDate(NSDate())
		return tripName.stringByAppendingPathComponent(timestampFileName)
	}
	
	func saveTripDetail(viewController: UIViewController, data: Dictionary<String, AnyObject>, parent: Trip) {
		let alertController = AlertHelper.showLoadingAlertOfSavingPhoto()
		viewController.presentViewController(alertController, animated: true, completion: nil)
		
		let databaseHelper = DataBaseHelper()
		var photoPath = data["photo_path"] as NSMutableArray
		var photoData = data["photo_data"] as NSMutableArray
		
		var photos: NSMutableSet = NSMutableSet()
		
		let tripFolder = data["tripName"] as String
		
		createTripFolder(tripFolder.stringByAppendingPathComponent(data["day"] as String))
		
		let absolutlyPath = getDocumentPath().stringByAppendingPathComponent(tripFolder)
		
		//saving picture to folder
		for index in 0...photoPath.count-1 {
			let path = absolutlyPath.stringByAppendingPathComponent(photoPath.objectAtIndex(index) as String)
			saveImage(photoData.objectAtIndex(index) as UIImage, filePath: path)
			
			var photo = databaseHelper.createManagedObjectByName("Photo") as Photo
			photo.photoPath = photoPath.objectAtIndex(index) as String
			photos.addObject(photo)
		}
		
		//saving data to database
		var detail: TripDetail = databaseHelper.createManagedObjectByName("TripDetail") as TripDetail
		detail.location = data["location"] as String
		detail.longitude = data["longitude"] as NSNumber
		detail.latitude = data["latitude"] as NSNumber
		detail.notes = data["notes"] as String
		detail.name = data["day"] as String
		detail.tripDate = NSDate()
		
		detail.tripToPhoto = photos
		
		var md = NSMutableSet(set: parent.masterDetail)
		md.addObject(detail)
		parent.masterDetail = md
		
		
		databaseHelper.save()
		
		func backToList() {
			viewController.navigationController?.popViewControllerAnimated(true)
		}
		
		AlertHelper.dismiss(alertController, completion: backToList)
	}
	
	func saveImage(image: UIImage, filePath: NSString) {
		var data: NSData!
		var finalFilePath: NSString = filePath
		
		if(UIImagePNGRepresentation(image) == nil) {
			data = UIImageJPEGRepresentation(image, 1)
			finalFilePath = finalFilePath.stringByAppendingString(".jpg")
		}else {
			data = UIImagePNGRepresentation(image)
			finalFilePath = finalFilePath.stringByAppendingString(".png")
		}
		
		data.writeToFile(finalFilePath, atomically: true)
	}
	
	func readImage(filePath: String) -> UIImage {
		return UIImage(contentsOfFile: filePath)!
	}
	
	class func defaultFileHelper() -> FileHelper {
		return FileHelper()
	}
	
	class dispatch {
		class async {
			class func bg(block: dispatch_block_t) {
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
			}
			
			class func main(block: dispatch_block_t) {
				dispatch_async(dispatch_get_main_queue(), block)
			}
		}
		
		class sync
		{
			class func bg(block: dispatch_block_t) {
				dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block)
			}
			
			class func main(block: dispatch_block_t) {
				if NSThread.isMainThread() {
					block()
				}
				else {
					dispatch_sync(dispatch_get_main_queue(), block)
				}
			}
		}
	}
}
