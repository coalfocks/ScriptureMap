//
//  MapViewController.swift
//  ScriptureMap
//
//  Created by Cole Fox on 11/18/17.
//  Copyright © 2017 Cole Fox. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    //MARK: Outlets
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    //MARK: Properties
    var locationManager: CLLocationManager?
    var selectedGeoPlace: GeoPlace?
    
    //MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.mapType = .hybridFlyover
        map.delegate = self
        map.showsUserLocation = true
        
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(31.7683, 35.2137)
        pin.title = "yoooooo"
        pin.subtitle = "hello subtitle"
        map.addAnnotation(pin)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let place = selectedGeoPlace {
            let camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2DMake(place.latitude, place.longitude),
                                     fromEyeCoordinate: CLLocationCoordinate2DMake(place.viewLatitude, place.viewLongitude),
                                     eyeAltitude: place.viewAltitude)
            map.setCamera(camera, animated: true)
        } else {
            let camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2DMake(31.7683, 35.2137),
                                     fromEyeCoordinate: CLLocationCoordinate2DMake(31.7, 35.2137),
                                     eyeAltitude: 6000)
            map.setCamera(camera, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.selectedGeoPlace = nil
    }
    
    
    //MARK: helpers
    func setPins(pins: [GeoPlace]) {
        map.removeAnnotations(map.annotations)
        var up = 0.0
        var down = 0.0
        var left = 0.0
        var right = 0.0
        for place in pins {
            if place.latitude > up {
                up = place.latitude
            }
            if place.latitude < down {
                down = place.latitude
            }
            if place.longitude > right {
                right = place.longitude
            }
            if place.longitude < left {
                left = place.longitude
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude)
            annotation.title = place.placename
            map.addAnnotation(annotation)
        }
        if pins.count > 0 {
            let deltaLat = right - left
            let deltaLong = up - down
            let center = CLLocationCoordinate2DMake(pins[0].latitude, pins[0].longitude)
            let region = MKCoordinateRegionMake( center, MKCoordinateSpanMake(deltaLat / 2, deltaLong / 2))
            map.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "Pin"
        var view = map.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if view != nil {
            view?.annotation = annotation
        } else {
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annoView.canShowCallout = true
            annoView.animatesDrop = true
            annoView.pinTintColor = UIColor.yellow
            view = annoView
        }
        return view
    }
    
    func zoomOnPlace(place: GeoPlace) {
        mapLabel?.text = place.placename
        let camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2DMake(place.latitude, place.longitude),
                                 fromEyeCoordinate: CLLocationCoordinate2DMake(place.viewLatitude, place.viewLongitude),
                                 eyeAltitude: place.viewAltitude)
        map.setCamera(camera, animated: true)
    }
}
