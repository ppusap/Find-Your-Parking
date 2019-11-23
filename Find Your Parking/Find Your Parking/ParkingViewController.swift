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
        addAnnotation()
        mapView.delegate = self
    }
    
    // A function to add a pin in respective coordinates
    func addAnnotation(){
        let myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.3461, longitude: -94.8725)
        myAnnotation.title = Supermarkets.shared.displayMapDetails
      
        mapView.addAnnotation(myAnnotation)
        
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "anno") as? MKPinAnnotationView // MKMarkerAnnotationView
       
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "anno")
            annotationView!.canShowCallout = true
            let callBTN = UIButton(type: .detailDisclosure)
            callBTN.addTarget(self, action: #selector(clickMe(sender:)), for: UIControl.Event.touchUpInside)
            annotationView!.rightCalloutAccessoryView = callBTN
            annotationView?.pinTintColor = UIColor.green
          
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    @objc
    func clickMe(sender:UIButton){
        let parkingCVC = self.storyboard?.instantiateViewController(withIdentifier: "ParkingCollectionVC")
        self.present(parkingCVC!, animated: true, completion: nil)
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
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       checkLocationServices()
    }
}



