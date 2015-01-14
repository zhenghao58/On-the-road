//
//  ViewController.swift
//  OnTheRoadB
//
//  Created by Cunqi.X on 14/10/24.
//  Copyright (c) 2014年 CS9033. All rights reserved.
//

import UIKit
import CoreData
class CurrentTripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    

	@IBOutlet var tableView: UITableView!
    
    var selectedTrip:Trip!
    var detailArr : [TripDetail]!
    var fileHelper : FileHelper!
    var databaseHelper : DataBaseHelper!
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        fileHelper = FileHelper()
        databaseHelper = DataBaseHelper()
        
        self.title = selectedTrip.name
		
		fileHelper.setCurrentFolderPath(selectedTrip.name)
        refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "addNewTripDetail") {
            let viewController = segue.destinationViewController as AddNewTripDetailViewController
            viewController.navigationItem.title = "Add New Day"
            viewController.currentTrip = self.selectedTrip
            viewController.currentDay = detailArr.count + 1
            
            println(selectedTrip.masterDetail.count)
        }
       if(segue.identifier == "showEachDetail"){
			let index = self.tableView.indexPathForSelectedRow()!.row
			let viewController = segue.destinationViewController as DetailTableViewController
				viewController.selectedTripDetail = self.detailArr[index]
				viewController.fileHelper = self.fileHelper
				viewController.navigationItem.title = detailArr[index].name
        }
    }
    
    
    /*
    The code below here are the simple code to show what I want the current trip
    screen looks like, we can use the first row as an indicator, and rest rows to
    show the records of current trip. change the row hight to make the first row
    and the rest rows diffierent.
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return detailArr.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 198
	}
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            let  data = detailArr[indexPath.row]
            databaseHelper.deleteData(data)
            refreshData()
            tableView.reloadData()
        }
    }
	
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("tripDetails", forIndexPath: indexPath) as CardTableViewCell
		
		cell.useMember(detailArr[indexPath.row], fileHelper: fileHelper)
		return cell
    }
    
    func refreshData(){
        
        detailArr = selectedTrip.masterDetail.allObjects as [TripDetail]
        detailArr.sort { (TripDetail A, TripDetail B) -> Bool in
            return A.name > B.name
        }
        
        tableView.reloadData()
    }
    
}

