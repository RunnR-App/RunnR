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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var runButton: RunButton!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        mapView.delegate = self
        
        runButton.backgroundColor = UIColor.green
        // Do any additional setup after loading the view.
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        locationManager.distanceFilter = kCLDistanceFilterNone
    }
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let reigon = MKCoordinateRegion.init(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
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
    
    var sourceCord: CLLocationCoordinate2D?
    var destCord: CLLocationCoordinate2D?
    
    var currentDistance: Double?
    
    @IBAction func onClick(_ sender: Any) {
        if (!runButton.isRunning){
            // The user is starting a run
            
            locationManager.startUpdatingLocation()
            centerViewOnUserLocation()
            sourceCord = locationManager.location?.coordinate
            
            //Get start time
            //Get starting coordinates
            //etc
        } else {
            // The user is ending a run
            
            // Get finish time
            // Get finish coordinates
            centerViewOnUserLocation()
            destCord = locationManager.location?.coordinate
            drawMap()
            // etc
            
            // Finalize entry in database
            
            let run = PFObject(className: "Runs")
            
            run["author"] = PFUser.current()!
            //run["miles"] = currentDistance
            run["content"] = "  just ran \(String(describing: currentDistance)) miles"
            
            run.saveInBackground()
        }
        
        
        runButton.changeStatus()
    }
    
    func drawMap(){
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCord!)
        let destPlaceMark = MKPlacemark(coordinate: destCord!)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        let dir = MKDirections.Request()
        dir.source = sourceItem
        dir.destination = destItem
        dir.transportType = .walking
        dir.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: dir)
        directions.calculate { (response, error) in
            guard let response = response else {
                if error != nil {
                    print("Calculation error")
                }
                return
            }
            
            let route = response.routes[0]
            self.currentDistance = route.distance * 0.000621371 
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
        
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) ->MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .red
        return render
    }
    
    @IBAction func onLogout(_ sender: Any) {
        
        PFUser.logOutInBackground()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: false, completion: nil)
    }

}
