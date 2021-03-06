//
//  VCMapView.swift
//  MapKitTest
//
//  Created by snqu-ios on 16/4/13.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

import Foundation
import MapKit

extension ViewController: MKMapViewDelegate {
    
    // 1
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            }else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                view.pinColor = annotation.pinColor()
            }
            return view
        }
        return nil
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    func mapView(mapView: MKMapView, viewForOverlay overlay: MKOverlay) -> MKOverlayView {
        var overlayView: MKOverlayView!
        if overlay.isKindOfClass(MKCircle.self) {
            let cirView = MKCircleView()
            cirView.backgroundColor = UIColor.redColor()
            cirView.alpha = 0.1
            overlayView = cirView
        }
        return overlayView
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        var render: MKOverlayRenderer!
        if overlay.isKindOfClass(MKCircle.self) {
            render = MKOverlayRenderer(overlay: overlay)
            render.alpha = 0.2
        }
        return render
    }
    
    
}


