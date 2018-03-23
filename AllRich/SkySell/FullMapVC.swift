//
//  FullMapVC.swift
//  SkySell
//
//  Created by DW02 on 7/4/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import MapKit




class FullMapVC: UIViewController {

    @IBOutlet weak var btBack: UIButton!
    
    
    @IBOutlet weak var myMap: MKMapView!
    
    
    
    var latitude:CGFloat = -21.128606
    var longitude:CGFloat = 55.495201
    
    var myTitle:String = ""
    var myPin:MKPointAnnotation! = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btBack.layer.shadowRadius = 5
        self.btBack.layer.shadowColor = UIColor.black.cgColor
        self.btBack.layer.shadowOpacity = 0.45
        
        
        self.myMap.delegate = self
        
        self.myMap.clipsToBounds = true
        
        
        self.view.clipsToBounds = true
        
        self.view.bringSubview(toFront: self.btBack)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.addPin()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addPin() {
        
        
        if self.myPin != nil {
            //            self.myMap.removeAnnotation(self.myPin)
            //            self.myPin = nil
            
            return
        }
        
        
        self.myPin = MKPointAnnotation()
        self.myPin.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        self.myPin.title = self.myTitle
        self.myMap.addAnnotation(self.myPin)
        
        self.myMap.showAnnotations([self.myPin], animated: false)
    }
    
    
    func removePin() {
        if self.myPin != nil {
            self.myMap.removeAnnotation(self.myPin)
            self.myPin = nil
        }
        
    }
    
    
    @IBAction func tapOnBack(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    

}


extension FullMapVC:MKMapViewDelegate{
    
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

