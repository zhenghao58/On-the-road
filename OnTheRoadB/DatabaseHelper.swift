//
//  DatabaseHelper.swift
//  OnTheRoadB
//
//  Created by Cunqi.X on 12/3/14.
//  Copyright (c) 2014 CS9033. All rights reserved.
//

import UIkit
import CoreData
class DataBaseHelper: NSObject {
	override init() {
		super.init()
		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		managedObjectContext = appDelegate.managedObjectContext!
		
	}
	
	func createManagedObjectByName(name: String) -> NSManagedObject {
		let managedObject: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedObjectContext) as NSManagedObject
		
		return managedObject
	}
	
	func fetchDataByTripName(tripName: String) -> [Trip] {
		var fetchRequest = NSFetchRequest(entityName: "Trip")
		if(!tripName.isEmpty) {
			var predicate = NSPredicate(format: "name = %@", tripName)
			fetchRequest.predicate = predicate
		}
		
		let fetchResult = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as [Trip]
		
		return fetchResult
	}
	
	func deleteData(data: NSManagedObject) {
		managedObjectContext.deleteObject(data);
		managedObjectContext.save(nil)
	}
	
	func save() {
		managedObjectContext.save(nil)
	}
	
	class func defaultHelper() -> DataBaseHelper {
		return DataBaseHelper()
	}
	
	private var managedObjectContext: NSManagedObjectContext!
	
}
