//
//  DetailTableViewController.swift
//  OnTheRoadB
//
//  Created by Hao Zheng on 12/9/14.
//  Copyright (c) 2014 CS9033. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var fileHelper : FileHelper!
    var selectedTripDetail : TripDetail!
    var images : [Photo]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        if let set = selectedTripDetail.tripToPhoto{
            if (set.count > 0) {
                images = set.allObjects as [Photo]
                
            }
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section==0{
            return 1
        }
        else {
            
            if images.isEmpty {return 0}
            else {return images.count}
            
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section==0){
            let str = selectedTripDetail.notes
            let attributedStr = NSAttributedString(string: str)
            //let maxSize = CGSizeMake(300, 9999)
            //let myFont = UIFont.systemFontOfSize(17)
            let textHeight = textViewHeight(attributedStr, width: 150)
            return textHeight + 75
            
            
        }
        else {
            let photo : Photo = images[indexPath.row]
            let image = UIImage(contentsOfFile: fileHelper.getCurrentFolderPath().stringByAppendingPathComponent(photo.photoPath))
            let height = image!.size.height/(image!.size.width/320)
            
            return height}
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section==0{
        let cell = tableView.dequeueReusableCellWithIdentifier("description", forIndexPath: indexPath) as UITableViewCell
          
            let textView = cell.contentView.viewWithTag(1) as UITextView
            textView.text = selectedTripDetail.notes
            textView.textContainerInset = UIEdgeInsets(top: 11, left: 8, bottom: 0, right: 0)
            let locationLabel = cell.contentView.viewWithTag(3) as UILabel
            locationLabel.text = selectedTripDetail.location
            let nameLabel = cell.contentView.viewWithTag(2) as UILabel
            nameLabel.text = selectedTripDetail.name
            
        // Configure the cell...

        return cell 
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("photoCell", forIndexPath: indexPath) as UITableViewCell
            let photo : Photo = images[indexPath.row]
            let photoView = cell.contentView.viewWithTag(4) as UIImageView
            photoView.image = UIImage(contentsOfFile: fileHelper.getCurrentFolderPath().stringByAppendingPathComponent(photo.photoPath))
            cell.contentView.layer.masksToBounds = true;
            return cell
        }
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }
    

    func textViewHeight(text: NSAttributedString, width: CGFloat) ->CGFloat{

        let textView = UITextView()
        textView.attributedText = text
      
        let size = textView.sizeThatFits(CGSizeMake(width, 9999))
        return size.height
    }

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
