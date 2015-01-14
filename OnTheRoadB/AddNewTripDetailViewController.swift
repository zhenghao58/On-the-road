//
//  File.swift
//  OnTheRoadB
//
//  Created by Cunqi.X on 11/24/14.
//  Copyright (c) 2014 CS9033. All rights reserved.
//

import UIKit
import MapKit
protocol LocationInformationDelegate {
	func setCurrentLocation(location: [String: AnyObject])
}

class AddNewTripDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate, LocationInformationDelegate {

	/*Override UIViewController Method*/
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.noteTv.delegate = self
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("activeEditMode"))
		
		//initialize an imageHelper
		imageHelper = TripImageHelper(viewController: self)
		
		self.view.addGestureRecognizer(addSwipUpCancelKeyboardGestureRecognize())
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showLocation" {
			let viewController = segue.destinationViewController as LocationPickerViewController
			viewController.locationDelegate = self
		}
	}
	
	/*Implement Delegate & DataSource Method*/
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return imageHelper.getImageData().count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		return imageHelper.generateNewCollectionCell(collectionView, indexPath: indexPath)
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if(indexPath.row == imageHelper.getLastIndexOfImageData()) {
			AlertHelper.showActionControllerOfAddNewTrip(self)
		}else {
			let photoDisplayController = PhotoDisplayController()
			photoDisplayController.setDisplayPhoto(imageHelper.getImageData(), index: indexPath.row)
			self.presentViewController(photoDisplayController, animated: true, completion: nil)
		}
	}
	
	func textViewDidBeginEditing(textView: UITextView) {
		if(textView.text == "Write Something...") {
			textView.text = ""
			textView.textColor = UIColor.blackColor()
		}
		textView.becomeFirstResponder()
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		if(textView.text == "") {
			textView.text = "Write Something..."
			textView.textColor = UIColor.lightGrayColor()
		}
		
		textView.resignFirstResponder()
	}
	
	
	/*Local Method*/
	func addSwipUpCancelKeyboardGestureRecognize() -> UISwipeGestureRecognizer {
		let gestureRecognize = UISwipeGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
		gestureRecognize.direction = .Up
		return gestureRecognize
	}
	
	func dismissKeyboard() {
		noteTv.resignFirstResponder()
	}
	
	func activeEditMode() {
		imageHelper.activeEditMode()
	}
	
	func setCurrentLocation(location: [String : AnyObject]) {
		locationTx.text = location["name"] as String
		
		currentLocation = location["location"] as? CLLocation
		
		println(currentLocation)
	}
	
	/*UI Components Listener*/
	@IBAction func addNewTrip(sender: AnyObject) {
		var data: [String : AnyObject] = [String : AnyObject]()
		
		data["location"] = locationTx.text.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
		
		if currentLocation != nil {
			data["longitude"] = currentLocation!.coordinate.longitude as Double
			data["latitude"] = currentLocation!.coordinate.latitude as Double
		}
		
		data["notes"] = noteTv.text
		
		data["photo_data"] = imageHelper.getImageData()
		data["photo_path"] = imageHelper.getImagePath()
		
		data["day"] = "Day\(currentDay)"
		
		data["tripName"] = currentTrip.name
		
		imageHelper.getFileHelper().saveTripDetail(self, data: data, parent: currentTrip)
	}
	
	@IBAction func didOnExit(sender: AnyObject) {
		sender.resignFirstResponder()
	}
	
	/*Bind UI Components*/
	@IBOutlet var locationTx: UITextField!
	@IBOutlet var noteTv: UITextView!
	@IBOutlet var imageCv: UICollectionView!
	
	/*Local Varible*/
	var imageHelper: TripImageHelper!
	var currentTrip: Trip!
	var currentDay: Int!
	var currentLocation: CLLocation?
}
