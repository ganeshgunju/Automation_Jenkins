//
//  ViewController.swift
//  DrawRouteMapKit
//
//  Created by GaneshKumar Gunju on 24/05/18.
//  Copyright © 2018 vaayooInc. All rights reserved.
//

import UIKit
//import GoogleMaps
import MapKit


class customPin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    init(pinTitle:String,pinSubtitle:String,location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubtitle
        self.coordinate = location
    }
    
}

class ViewController: UIViewController ,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let camera = GMSCameraPosition.camera(withLatitude: 14.4222, longitude: 78.2263, zoom: 20.0)
//        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
//        self.view = mapView
//        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: 14.4222, longitude: 78.2263))
//        marker.title = "My Home Town"
//        marker.snippet = "Pulivendula,India"
//        marker.map = mapView

        let sourceLocation = CLLocationCoordinate2D(latitude: 14.4222, longitude: 78.2263)
        let destination = CLLocationCoordinate2D(latitude: 14.4674, longitude: 78.8241)
        
        let sourcePin = customPin(pinTitle: "Pulivendula", pinSubtitle: "", location: sourceLocation)
        let destinationPin = customPin(pinTitle: "kadapa", pinSubtitle: "", location: destination)
         self.mapView.addAnnotation(sourcePin)
         self.mapView.addAnnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destination)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResone = response else {
                if let error = error {
                    print("We have error getting directions==\(error.localizedDescription)")
                }
                
                return
            }
            let route = directionResone.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        self.mapView.delegate = self
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

