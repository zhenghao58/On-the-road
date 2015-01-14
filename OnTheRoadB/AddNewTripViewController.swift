//
//  NewTripView.swift
//  OnTheRoadB
//
//  Created by 季必才 on 12/4/14.
//  Copyright (c) 2014 CS9033. All rights reserved.
//

import UIkit
import CoreData

class AddNewTripViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
	
	@IBOutlet var coverImage: UIButton!
    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripDescription: UITextView!
	
	var databaseHelper: DataBaseHelper!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		databaseHelper = DataBaseHelper()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		self.view.endEditing(true)
	}
	
	
	func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		
		coverImage.setBackgroundImage(image, forState: .Normal)
		picker.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func pickCover(sender: AnyObject) {
		let pickerC = UIImagePickerController()
		pickerC.delegate = self
		pickerC.sourceType = .PhotoLibrary
		self.presentViewController(pickerC, animated: true, completion: nil)
	}
	
	@IBAction func saveTrip(sender: AnyObject) {
		let newTrip = databaseHelper.createManagedObjectByName("Trip") as Trip
		newTrip.name = tripName.text
		newTrip.desc = tripDescription.text
		newTrip.startDate = NSDate()
		
		let cover = coverImage.backgroundImageForState(UIControlState.Normal)
		
		let fileHelper = FileHelper.defaultFileHelper()
		fileHelper.setCurrentFolderPath(newTrip.name)
		fileHelper.createTripFolder(newTrip.name)
		var absolutePath = fileHelper.getCurrentFolderPath().stringByAppendingPathComponent("cover")
		
		newTrip.cover = absolutePath
		
		FileHelper.defaultFileHelper().saveImage(cover!, filePath: absolutePath)
		
		databaseHelper.save()
		
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
	
}