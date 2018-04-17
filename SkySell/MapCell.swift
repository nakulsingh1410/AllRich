//
//  MapCell.swift
//  SkySell
//
//  Created by DW02 on 5/26/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

import MapKit



class MapCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var myMap: MKMapView!
    
    
    var latitude:CGFloat = -21.128606
    var longitude:CGFloat = 55.495201
    
    var title:String = ""
    var myPin:MKPointAnnotation! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.myMap.delegate = self
        
        self.myMap.clipsToBounds = true
        //self.myMap.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func addPin() {
        
        
        if self.myPin != nil {
            //            self.myMap.removeAnnotation(self.myPin)
            //            self.myPin = nil
            
            return
        }
        
        
        self.myPin = MKPointAnnotation()
        self.myPin.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        self.myPin.title = self.title
        self.myMap.addAnnotation(self.myPin)
        
        self.myMap.showAnnotations([self.myPin], animated: false)
    }
    
    
    func removePin() {
        if self.myPin != nil {
            self.myMap.removeAnnotation(self.myPin)
            self.myPin = nil
        }
        
    }
    
    
}


extension MapCell:MKMapViewDelegate{
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if(pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        return pinView
    }
    
    
}


