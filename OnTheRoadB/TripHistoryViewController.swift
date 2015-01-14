//
//  ViewController.swift
//  OnTheRoadB
//
//  Created by Cunqi.X on 14/10/24.
//  Copyright (c) 2014年 CS9033. All rights reserved.
//

import UIKit
import CoreData

class TripHistoryViewController: UITableViewController {
	
	var tripData: [Trip]!
	var fileHelper: FileHelper!
	var databaseHelper: DataBaseHelper!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		fileHelper = FileHelper()
		databaseHelper = DataBaseHelper()
		
		fetchdata()
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return tripData.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCellWithIdentifier("TripCells", forIndexPath: indexPath) as TripHistoryViewCell
		let selectedTrip = tripData[indexPath.row]

		if let cover = selectedTrip.cover as String? {
			fileHelper.setCurrentFolderPath(selectedTrip.name)
			if let image = UIImage(contentsOfFile: fileHelper.getCurrentFolderPath().stringByAppendingPathComponent("cover")) {
				cell.thumbnail!.image = image
			}
		}
		
		cell.title?.text = selectedTrip.name
		cell.location?.text = selectedTrip.desc
		
		return cell
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 61
	}
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if (editingStyle == UITableViewCellEditingStyle.Delete){
			let  dataToDelete = tripData[indexPath.row]
			
			databaseHelper.deleteData(dataToDelete)
			
			fetchdata()
			
			tableView.reloadData()
		}
	}
	override func viewWillAppear(animated: Bool) {
		fetchdata()
	}
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if(segue.identifier == "showTripDetails") {
			let index = self.tableView.indexPathForSelectedRow()!.row
			
			let viewController = segue.destinationViewController as CurrentTripViewController
			
			viewController.selectedTrip = tripData[index]
		}
	}
	func fetchdata(){
		tripData = databaseHelper.fetchDataByTripName("")
		tripData.sort { (Trip A, Trip B) -> Bool in
			return A.startDate.compare(B.startDate) == NSComparisonResult.OrderedDescending
		}
		tableView.reloadData()
	}
	
}

