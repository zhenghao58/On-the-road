//
//  Photo.swift
//  OnTheRoadB
//
//  Created by Cunqi.X on 11/29/14.
//  Copyright (c) 2014 CS9033. All rights reserved.
//

import Foundation
import CoreData

class Photo: NSManagedObject {

    @NSManaged var photoPath: String
    @NSManaged var photoToTrip: TripDetail

}
