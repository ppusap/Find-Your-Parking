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

//enum SupermarketLocation {
//    case walmart, hyvee, dollarGeneral
//}

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //var decodedmapValue:String!
    var supermarketName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        //NotificationCenter.default.addObserver(self, selector: #selector(addAnnotations(notification:)), name: NSNotification.Name("annotationsReceived"), object: nil)
        addAnnotation()
        mapView.delegate = self
        print(supermarketName)
        
    }
    func addAnnotation(){
        let myAnnotation = MKPointAnnotation()
        print("hi")

        print(supermarketName!)
        switch supermarketName!{
        case "walmart":
            myAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.329998, longitude: -94.870303)
            mapView.addAnnotation(myAnnotation)
        case "Hy-Vee":
            myAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.333483,longitude: -94.872222)
            mapView.addAnnotation(myAnnotation)
        case "Dollar General":
            myAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.334027,longitude: -94.872064)
            mapView.addAnnotation(myAnnotation)
        default:
            print(Error.self)
        }
        
        //myAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.3461, longitude: -94.8725)
        
        //var valueSplit = decodedmapValue?.split(separator: "-")
        
        //myAnnotation.title = String(valueSplit![0])
        //myAnnotation.subtitle = String(valueSplit![1])
        //mapView.addAnnotation(myAnnotation)
        
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
            //callBTN.addTarget(self, action: #selector(clickMe(sender:)), for: UIControl.Event.touchUpInside)
            //annotationView!.rightCalloutAccessoryView = callBTN
            annotationView?.pinTintColor = UIColor.green
            //annotationView!.markerTintColofr = UIColor.green
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    //@objc
    //func clickMe(sender:UIButton){
     //   let parkingCVC = self.storyboard?.instantiateViewController(withIdentifier: "ParkingCollectionVC")
      //  self.present(parkingCVC!, animated: true, completion: nil) // probably not quite what we want ;-(
   // }

    
    
    
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


extension MapViewController: CLLocationManagerDelegate{
    
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



