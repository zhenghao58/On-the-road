//
//  CardTableViewCell.swift
//  CardTilt
//
//  Created by Ray Fix on 6/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore

class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
	func useMember(member:TripDetail, fileHelper: FileHelper) {
        // Round those corners
		self.photoView.layer.cornerRadius = 5
		self.photoView.layer.masksToBounds = true
        //mainView.layer.cornerRadius = 10;
        //mainView.layer.masksToBounds = true;
        
        // Fill in the data
        nameLabel.text = member.name
        
        locationLabel.text = member.location
		
		println(member.name)
        
		if let set = member.tripToPhoto {
			if (set.count > 0) {
				let detailCover = set.allObjects[0] as Photo
				photoView.image = UIImage(contentsOfFile: fileHelper.getCurrentFolderPath().stringByAppendingPathComponent(detailCover.photoPath))
			}
		}
    }
    
    
    
}
