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
    override func viewDidAppear(_ animated: Bool) {
        centerViewOnUserLocation()
    }
    
    var sourceCord: CLLocationCoordinate2D?
    var destCord: CLLocationCoordinate2D?
    var startTime: NSDate?
    
    @IBAction func onClick(_ sender: Any) {
        if (!runButton.isRunning){
            // The user is starting a run
            
            locationManager.startUpdatingLocation()
            centerViewOnUserLocation()
            //Get starting coordinates
            sourceCord = locationManager.location?.coordinate
            startTime = NSDate()
            //Get start time
            
        } else {
            // The user is ending a run
            destCord = locationManager.location?.coordinate
            
            drawMap()
            centerViewOnUserLocation()
            // draw map func does everything needed to complete run and post to db
            // does all the final calcualtions for distance and time after response
            
        }
        
        
        runButton.changeStatus()
    }
    
    func drawMap(){
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCord!)
        let destPlaceMark = MKPlacemark(coordinate: destCord!)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        // get finish time
        
        let dir = MKDirections.Request()
        dir.source = sourceItem
        dir.destination = destItem
        dir.transportType = .walking
        dir.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: dir)
        
        directions.calculate { (response, error) in
            guard let response = response else {return}
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            let run = PFObject(className: "Runs")
            run["author"] = PFUser.current()!
            run["username"] = PFUser.current()?.username
            
            // run["time"] = finish - start
            let timeInterval: Double = self.startTime!.timeIntervalSinceNow
            let timeInHours = abs(timeInterval) * 0.00027778    // seconds to hours
            
            run["finishedAt"] = timeInHours
            
            // calculate distance
            let distInMiles = route.distance * 0.000621371
            run["miles"] = distInMiles
            
            let mph: Double = distInMiles / timeInHours
            run["mph"] = mph
            
            run["content"] = String(format: "   just ran %.2f miles. Average speed: %.2f mph.", distInMiles, mph)
            
            run.saveInBackground()
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

}
