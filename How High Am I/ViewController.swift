//
//  ViewController.swift
//  How High Am I?
//
//  Created by Work on 9/2/15.
//  Copyright (c) 2015 Kevin Kirkhoff. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate
{
    
    @IBOutlet weak var altitude: UILabel!
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var unitSetting: Units = .Feet
    @IBOutlet weak var cityLabel: UILabel!
    
    enum Units {
        case Feet
        case Meters
    }
    
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else
        {

        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedAction(sender: UISegmentedControl)
    {
        if segmentedOutlet.selectedSegmentIndex == 0
        {
            // Use feet
            unitSetting = .Feet
        }
        else
        {
            // Use meters
            unitSetting = .Meters
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let newLocation = locations.last
        location = newLocation
        if let location = location
        {
            if (unitSetting == .Feet)
            {
                // Convert the meters to feet
                let alt:CLLocationDistance = location.altitude * 3.2808399

                altitude.text = String(format: "%.0f ft", alt)
            }
            else
            {
                let alt:CLLocationDistance = location.altitude
                
                altitude.text = String(format: "%.0f m", alt)
            }
        }
        else
        {
            altitude.text = "N/A"
        }
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) -> Void in
            if (error != nil)
            {
                print("Error:" + error!.localizedDescription)
                return
            }
            if placemarks?.count > 0
            {
                let pm = placemarks?[0]
                
                self.cityLabel.text = pm?.locality
            }
            else
            {
                self.cityLabel.text = "N/A"
                
            }
        })
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        locationManager.stopUpdatingLocation()
    }
    
    
}

