//
//  ViewController.swift
//  OnTheRoadB
//
//  Created by Cunqi.X on 14/10/24.
//  Copyright (c) 2014年 CS9033. All rights reserved.
//

import UIKit
import MapKit

class LocationPickerViewController: UITableViewController, CLLocationManagerDelegate {
	var locationDelegate: LocationInformationDelegate!
    var locationManager:CLLocationManager!
    var sections = ["Restaurants","Parks","Museums","Hotels","Attractions"]
    var locationCategories = [
        "Restaurants":[],
        "Parks":[],
        "Museums":[],
        "Hotels":[],
        "Attractions":[]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		if CLLocationManager.locationServicesEnabled() == false {
			println("Can't get location")
		}
		
		self.locationManager = CLLocationManager();
		self.locationManager.requestWhenInUseAuthorization()
		
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.startUpdatingLocation()
    }

    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        let location = locations.last as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
     
        
        var requests = [String:MKLocalSearchRequest]()
        var searches = [String:MKLocalSearch]()
        for (category, closestPlaces)in self.locationCategories{
            requests[category] = MKLocalSearchRequest()
            requests[category]!.region = region
            requests[category]!.naturalLanguageQuery = category
        
            searches[category] = MKLocalSearch(request: requests[category])
            searches[category]!.startWithCompletionHandler { (response, error) in
                self.locationCategories[category] = response.mapItems as [MKMapItem]
            }
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        return self.locationCategories.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var category = self.locationCategories[self.sections[section]] as [MKMapItem]
        return category.count
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = self.tableView.dequeueReusableCellWithIdentifier("location", forIndexPath: indexPath) as UITableViewCell
        let category = self.sections[indexPath.section]
        let rows = self.locationCategories[category] as [MKMapItem]
		
        cell.textLabel!.text = rows[row].name
		
		let partOfAddress = rows[row].placemark.addressDictionary["FormattedAddressLines"] as? NSArray
		cell.detailTextLabel!.text = mergeToAddress(partOfAddress!)
		
        return cell
    }
	
	private func mergeToAddress(partOfAddress: NSArray)-> String {
		let result = NSMutableString()
		for element in partOfAddress {
			
			result.appendString(element as String)
		}
		
		return result.description
	}
	
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let category = self.sections[indexPath.section]
        let rows = self.locationCategories[category] as [MKMapItem]
        
        let placemark = rows[row].placemark as MKPlacemark
		
		var location = [String: AnyObject]()
		
		location["name"] = placemark.name
		location["address"] = placemark.addressDictionary["FormattedAddressLines"]
		location["location"] = placemark.location
		
		locationDelegate.setCurrentLocation(location)
		
		self.navigationController?.popViewControllerAnimated(true)
    }
}

