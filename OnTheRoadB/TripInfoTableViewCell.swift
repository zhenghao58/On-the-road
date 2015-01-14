//
//  TripInfoTableViewCell.swift
//  OnTheRoadB
//
//  Created by Hao Zheng on 12/6/14.
//  Copyright (c) 2014 CS9033. All rights reserved.
//

import UIKit

class TripInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func useSelectedTrip(trip: Trip){
        stateLabel.text = "Current"
        self.textLabel?.text = trip.name
        self.detailTextLabel?.text = trip.desc
    }
    
    
}
