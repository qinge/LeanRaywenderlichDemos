//
//  ViewController.swift
//  MapKitTest
//
//  Created by snqu-ios on 16/4/12.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//
//  https://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial
//  wwdc2012中的session300

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var latitude = 21.282778
    var longitude = -157.829444

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orangeColor()
        print("\(self)")
        
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        self.centerMapOnLocation(initialLocation)
        
        mapView.delegate = self
        
        let artwork = Artwork(title: "King David Kalakaua",
            locationName: "Waikiki Gateway Park",
            discipline: "Sculpture",
            coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        mapView.addAnnotation(artwork)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

