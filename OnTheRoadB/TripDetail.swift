//
//  TripDetail.swift
//  OnTheRoadB
//
//  Created by Cunqi.X on 11/29/14.
//  Copyright (c) 2014 CS9033. All rights reserved.
//

import Foundation
import CoreData

class TripDetail: NSManagedObject {

    @NSManaged var latitude: NSNumber
    @NSManaged var location: String
    @NSManaged var longitude: NSNumber
    @NSManaged var name: String
    @NSManaged var notes: String
    @NSManaged var tripDate: NSDate
    @NSManaged var detailToMaster: NSManagedObject
    @NSManaged var tripToPhoto: NSSet?

}
