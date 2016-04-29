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
    
    var artworks = [Artwork]()
    var latitude = 21.282778
    var longitude = -157.829444
    var locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orangeColor()
        print("\(self)")
        
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        self.centerMapOnLocation(initialLocation)
        
        mapView.delegate = self
        
//        let artwork = Artwork(title: "King David Kalakaua",
//            locationName: "Waikiki Gateway Park",
//            discipline: "Sculpture",
//            coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
//        mapView.addAnnotation(artwork)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let circle = MKCircle(centerCoordinate: coordinate, radius: 500)
        circle.title = "test title"
        mapView.addOverlay(circle)
        
//        let circleRenderer = MKCircleRenderer(circle: circle)
        
        
        loadInitialData()
        mapView.addAnnotations(artworks)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "mapViewTaped:")
        mapView.addGestureRecognizer(tapGesture)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationAuthorizationStatus()
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
    
    
    func loadInitialData() {
        // 1
        let fileName = NSBundle.mainBundle().pathForResource("PublicArt", ofType: "json")
        do {
            let data = try NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(rawValue: 0))
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))

            // 3
            if let jsonObject = jsonObject as? [String : AnyObject] {
                let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array
                for artworkJSON  in jsonData! {
                    if let artworkJSON = artworkJSON.array {
                        let artwork = Artwork.fromJSON(artworkJSON)
//                        artworks.append(artwork!)
                    }
                }
            }
        }catch {
            
        }
        
    }
    
    
    /**
     *  检查 checkLocationAuthorizationStatus
     */
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        }else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    func mapViewTaped(gesture: UITapGestureRecognizer){
        let touchPoint = gesture.locationInView(mapView)
        let touchMapCoordinate = mapView.convertPoint(touchPoint, fromView: mapView)
        print("touchMapCoordinate = \(touchMapCoordinate)")
    }
}

