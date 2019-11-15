//
//  ViewController.swift
//  MapDemo
//
//  Created by Student on 11/13/19.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ParkingViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          checkLocationServices()
        //NotificationCenter.default.addObserver(self, selector: #selector(addAnnotations(notification:)), name: NSNotification.Name("annotationsReceived"), object: nil)
        addAnnotation()
        mapView.delegate = self
    }
    func addAnnotation(){
        let myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.3461, longitude: -94.8725)
        myAnnotation.title = "   Hyvee  "
        myAnnotation.subtitle = "A1 Parking slot"
        mapView.addAnnotation(myAnnotation)
        
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "anno") as? MKPinAnnotationView // MKMarkerAnnotationView
       
        if annotationView == nil {
            // no annotation view, we'll make one ...
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "anno")
            annotationView!.canShowCallout = true
            let callBTN = UIButton(type: .detailDisclosure)
            callBTN.addTarget(self, action: #selector(clickMe(sender:)), for: UIControl.Event.touchUpInside)
            annotationView!.rightCalloutAccessoryView = callBTN
            annotationView?.pinTintColor = UIColor.green
            //annotationView!.markerTintColor = UIColor.green
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    @objc
    func clickMe(sender:UIButton){
        let parkingCVC = self.storyboard?.instantiateViewController(withIdentifier: "ParkingCollectionVC")
        self.present(parkingCVC!, animated: true, completion: nil) // probably not quite what we want ;-(
    }
    
    
    
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 20000
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        tabBarItem.title = "Map Screen"
    }
     
    func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
       if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(location, regionInMeters, regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAuthorization()
        }else{
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
              mapView.showsUserLocation = true
              //centerViewOnUserLocation()
              locationManager.startUpdatingLocation()
              break
        case .denied:
            //show an alert
               break
        case .notDetermined:
               locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //show an alert
               break
        case .authorizedAlways:
               break
        }
    }
    
}


extension ParkingViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //guard let location = locations.last else {
         //   return
       // }
        //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude
         //   , longitude: location.coordinate.longitude)
        //let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
       // mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       checkLocationServices()
    }
}



