//
//  MapWithStationViewController.swift
//  Bikes
//
//  Created by Kamil Gacek on 25.07.2018.
//  Copyright © 2018 Kamil Gacek. All rights reserved.
//

import UIKit
import MapKit

class MapWithStationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var idAndNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var availableBikesLabel: UILabel!
    @IBOutlet weak var availablePlacesLabel: UILabel!
    
    var selectedBikeStation: BikeStation?
    let regionRadius: CLLocationDistance = 700
    
    override func viewWillAppear(_ animated: Bool) {
        updateLabels()
        if let bikeStation = selectedBikeStation {
            let initialLocation =  CLLocation(latitude: CLLocationDegrees(bikeStation.coordinateY), longitude: CLLocationDegrees(bikeStation.coordinateX))
            centerMapOnLoaction(location: initialLocation)
            let annotation = MKPointAnnotation()
            let centerCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(bikeStation.coordinateY), longitude:CLLocationDegrees(bikeStation.coordinateX))
            annotation.coordinate = centerCoordinate
            mapView.addAnnotation(annotation)
        }
        mapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) { return nil }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "BikePlacemark")
        if let subView = Bundle.main.loadNibNamed("BikePlacemark", owner: self, options: nil)?.first  {
            guard let subView = subView as? BikePlacemark else { return MKAnnotationView() }
            annotationView.addSubview(subView)
            annotationView.frame = subView.frame
            subView.numberLabel.text = selectedBikeStation?.availableBikes
        }
        annotationView.canShowCallout = false
        return annotationView
    }
    
    func updateLabels(){
        if let bikeStation = selectedBikeStation {
            idAndNameLabel.text = bikeStation.id + " " + bikeStation.name
            availableBikesLabel.text = bikeStation.availableBikes
            availablePlacesLabel.text = bikeStation.availablePlaces
            distanceLabel.text = bikeStation.distance
        }
    }
    
    func centerMapOnLoaction(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
