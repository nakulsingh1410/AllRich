//
//  SelectLocationVC.swift
//  DemoHome
//
//  Created by supapon pucknavin on 1/15/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Place: MKPointAnnotation {
    
    var name:String? = ""
    var detail:String? = ""
    var tag:NSInteger? = 0
    
    
    
    override init(){
        super.init()
    }
    
}


class SelectLocationVC: UIViewController {

    @IBOutlet weak var viTopBar: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btBack: UIButton!
    
    @IBOutlet weak var btOk: UIButton!
    var strTitle:String = "LOCATION"
    var screenSize:CGRect = UIScreen.main.bounds
    
    @IBOutlet weak var myMap: MKMapView!
    
    @IBOutlet weak var viPinBG: UIView!
    
    @IBOutlet weak var viBalloon: UIView!
    
    @IBOutlet weak var viBalloon_Layout_Width: NSLayoutConstraint!
    
    @IBOutlet weak var viBalloon_Layout_Height: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var lbLocation: UILabel!
    
    
    @IBOutlet weak var imageBalloonBG: UIImageView!
    
    
    
    
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    
    
    var startLatitude:Double = 0.0
    var startLongitude:Double = 0.0
    
    
    var callBack:(Double, Double, [String:String], String) -> Void = {(latitude, longitude, locationData, locationDetail) in }
    
    var myPin:MKPointAnnotation! = nil
    
    
    var strLocationName:String = ""
    
    var arLocationAddressLines:String = ""
    
    
    var readyGetLocation:Bool = false
    
    var lbFont:UIFont? = nil
    
  
    enum MyLocationKey:String{
        case Name = "Name"
        case Street = "Street"
        case City = "City"
        case State = "State"
        case Zip = "Zip"
        case Country = "Country"
    }
    
    var locationData:[String:String] = [String:String]()
    
    
    var originalImageBalloon:UIImage! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.lbFont = UIFont(name: "Avenir-Roman", size: 16)
        
        self.lbLocation.font = self.lbFont
        
        self.viTopBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.viTopBar.layer.shadowOpacity = 0.05
        self.viTopBar.layer.shadowRadius = 1
        
        self.viTopBar.clipsToBounds = false
        
        
        
        
        self.btOk.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.btOk.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.btOk.layer.shadowOpacity = 0.05
        self.btOk.layer.shadowRadius = 1
        
        self.btOk.clipsToBounds = false
        
        
        
        self.lbTitle.text = strTitle
        
        self.myMap.delegate = self
        
        self.viBalloon.alpha = 0
        
        originalImageBalloon = UIImage(named: "combinedShape.png")!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        print("\(self.startLatitude) , \(self.startLatitude)" )
        
        
        if((self.startLatitude != 0.0) && (self.startLongitude != 0.0)){
            self.zoomToLocation(Latitude: self.startLatitude, Longitude: self.startLongitude)
        }else{
            //self.zoomToLocation(Latitude: 1.35, Longitude: 103.80)
            self.startGetLocation()
        }
        
        
        
        
        if(self.readyGetLocation == false){
            let seconds = 3.0
            
            let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                self.readyGetLocation = true
                self.getLocation()
                
            }
            
        }
 
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Action
    
    @IBAction func tapOnBack(_ sender: UIButton) {
        
        
        self.exitScene()
    }
    
    
    
    @IBAction func tapOnOK(_ sender: Any) {
        
        self.callBack(self.startLatitude, self.startLongitude, self.locationData, self.arLocationAddressLines)
        self.exitScene()
    }
    
    
    
    func exitScene() {
        if let navigation = self.navigationController{
            navigation.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
    
    
    
    
    func getLocation() {
        
        let location = self.myMap.convert(self.viPinBG.center, toCoordinateFrom: self.view)
        
        self.startLatitude = location.latitude
        self.startLongitude = location.longitude
        print(location)
        

        
        
        self.getLocationNameWith(location: location)
    }
    
    func zoomToLocation(Latitude lat:Double, Longitude log:Double) {
        let location = CLLocationCoordinate2D(latitude: lat, longitude: log)
        let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        self.myMap.setRegion(region, animated: true)
    }
    
    
    
    func addPin() {
        
        
        if self.myPin != nil {
            self.removePin()
        }
        
        
        self.myPin = MKPointAnnotation()
        self.myPin.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.startLatitude), longitude: CLLocationDegrees(self.startLongitude))
        self.myPin.title = self.strLocationName
        self.myMap.addAnnotation(self.myPin)
        
        self.myMap.showAnnotations([self.myPin], animated: true)
    }
    
    
    func removePin() {
        if self.myPin != nil {
            self.myMap.removeAnnotation(self.myPin)
            self.myPin = nil
        }
        
    }
    
    
    func getLocationNameWith(location:CLLocationCoordinate2D) {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
           // print(placeMark.addressDictionary)
            self.arLocationAddressLines = ""
            let formattedAddressLines:[String]? = placeMark.addressDictionary?["FormattedAddressLines"] as? [String]
            
            if let formattedAddressLines = formattedAddressLines{
                //print(formattedAddressLines)
                
                for a in formattedAddressLines{
                    
                    if(self.arLocationAddressLines.count <= 0){
                        self.arLocationAddressLines = a
                    }else{
                        self.arLocationAddressLines = String(format: "%@ %@", self.arLocationAddressLines, a)
                    }
                  
                }
            }
            
            
            
            
            
            self.locationData = [String:String]()
            
            self.strLocationName = ""
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? String {
                //print(locationName)
                self.strLocationName = locationName
                
                self.locationData[MyLocationKey.Name.rawValue] = locationName
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? String {
                print(street)
                
                if(self.strLocationName.count == 0){
                    self.strLocationName = street
                }else{
                    self.strLocationName = String(format: "%@ %@", self.strLocationName, street)
                }
                
                self.locationData[MyLocationKey.Street.rawValue] = street
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? String {
                //print(city)
                if(self.strLocationName.count == 0){
                    self.strLocationName = city
                }else{
                    self.strLocationName = String(format: "%@ %@", self.strLocationName, city)
                }
                
                self.locationData[MyLocationKey.City.rawValue] = city
                
            }
            
            // City
            if let state = placeMark.addressDictionary!["State"] as? String {
                //print(city)
                if(self.strLocationName.count == 0){
                    self.strLocationName = state
                }else{
                    self.strLocationName = String(format: "%@ %@", self.strLocationName, state)
                }
                
                self.locationData[MyLocationKey.State.rawValue] = state
                
            }
            
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? String {
                print(zip)
                if(self.strLocationName.count == 0){
                    self.strLocationName = zip
                }else{
                    self.strLocationName = String(format: "%@ %@", self.strLocationName, zip)
                }
                
                self.locationData[MyLocationKey.Zip.rawValue] = zip
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? String {
                //print(country)
                
                if(self.strLocationName.count == 0){
                    self.strLocationName = country
                }else{
                    self.strLocationName = String(format: "%@ %@", self.strLocationName, country)
                }
                
                self.locationData[MyLocationKey.Country.rawValue] = country
            }
            
        print(self.strLocationName)
            
            
            var lbW:CGFloat = 100
            var lbH:CGFloat = 30
            if let font = self.lbFont{
                lbW = widthForView(text: self.strLocationName, Font: font, Height: 25) + 16
                
                if(lbW > 200){
                    lbW = 216
                    lbH = heightForView(text: self.strLocationName, Font: font, Width: 200) + 24
                    
                }
            }
            
            self.viBalloon_Layout_Width.constant = lbW
            self.viBalloon_Layout_Height.constant = lbH
            
            
            UIView.animate(withDuration: 0.25, animations: { 
                self.view.layoutIfNeeded()
                self.view.updateConstraints()
            })
            
            let inset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            let imageStretch = self.originalImageBalloon.resizableImage(withCapInsets: inset)
            self.imageBalloonBG.image = imageStretch
            
            
            self.lbLocation.text = self.arLocationAddressLines//self.strLocationName
            self.viBalloon.alpha = 1
            //self.addPin()
        })
    }
        
    
}

extension SelectLocationVC:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.viBalloon.alpha = 0
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        
        if(self.readyGetLocation == true){
            self.getLocation()
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if(annotation is MKPointAnnotation){
            
            let pinview:MKPinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.title!)
         
            pinview.animatesDrop = false
            pinview.canShowCallout = true
            
            //pinview.alpha = 0
            return pinview
        }else{
            return nil
        }
    }
}


// MARK: - CLLocationManagerDelegate
extension SelectLocationVC:CLLocationManagerDelegate{
    
    
    func startGetLocation() {
        
        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        
        
        if(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0){
            
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("get User location didFai")
        
        
        self.readyGetLocation = true
        self.getLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        
        print("get User location")
        
        // let currentLocation:CLLocation = newLocation
        
        
        
        //self.myData.myPostDraft.latitude = currentLocation.coordinate.latitude
        //self.myData.myPostDraft.longitude = currentLocation.coordinate.longitude
        
        
        
        
        
        
        self.locationManager.stopUpdatingLocation()
        
        
        self.readyGetLocation = true
        self.getLocation()
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
    }
}
