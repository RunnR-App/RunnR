//
//  MapViewController.swift
//  RunnR
//
//  Created by MaKayla Day on 11/9/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        
        PFUser.logOutInBackground()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: false, completion: nil)
    }
    
    let locationManager = CLLocationManager()
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let reigon = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(reigon, animated: true)
        }
    }
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Tell the user that their location services are disabled
            print("Location services are disabled.")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            // Everything checks out
            print("Show User Location Activated!")
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            break
        case .denied:
            // Show alert and instruct
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // User has parental controls denying location
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }

}

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Later
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Later
    }
}
