//
//  Trip.swift
//  OnTheRoadB
//
//  Created by 季必才 on 12/4/14.
//  Copyright (c) 2014 CS9033. All rights reserved.
//

import Foundation
import CoreData

class Trip: NSManagedObject {

    @NSManaged var cover: String?
    @NSManaged var desc: String
    @NSManaged var name: String
    @NSManaged var state: String
    @NSManaged var masterDetail: NSSet
	@NSManaged var startDate: NSDate
	
}
