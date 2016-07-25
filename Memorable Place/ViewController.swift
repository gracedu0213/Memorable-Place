//
//  ViewController.swift
//  Memorable Place
//
//  Created by Grace Du on 7/22/16.
//  Copyright © 2016 Grace Du. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FavPlace{
  var address:String
  var lat:CLLocationDegrees = 0
  var lon:CLLocationDegrees = 0
  init (name:String){
    self.address = name
  }
}

class ViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{
  

  var myMapView = MKMapView()
  var locationManager = CLLocationManager()
  
  var newPlace: FavPlace?
  var updateView:Int = 0
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    
    if returnIndex == -1{
      //add first annonation on the map
      let latitude: CLLocationDegrees = 43.659431
      let longitude: CLLocationDegrees = -79.385088
      let latDelta: CLLocationDegrees = 0.02
      let longDelta: CLLocationDegrees = 0.02
      let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
      let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
      let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
      myMapView.setRegion(region, animated: true)
    }
    else{
      print("return index \(returnIndex)")
      let addedPlace:FavPlace = placeList[returnIndex] as! FavPlace
      addAnnotation(addedPlace, updated: true)
    }
    
    self.navigationItem.title = "Map"
    let barButtonRight = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addPlaces))
    self.navigationItem.setRightBarButtonItem(barButtonRight, animated: true)
    
    //create the map view
    myMapView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64)
    self.view.addSubview(myMapView)
  
    let ulpgr = UILongPressGestureRecognizer(target: self, action: #selector(pressAction))
    ulpgr.minimumPressDuration = 1
    myMapView.addGestureRecognizer(ulpgr)
    
    
    }
  
  //long pressed function
  func pressAction(gestureRecognizer: UILongPressGestureRecognizer){
    if gestureRecognizer.state == .Began{
    let touchPoint = gestureRecognizer.locationInView(myMapView)
    let coordinate: CLLocationCoordinate2D = myMapView.convertPoint(touchPoint, toCoordinateFromView: myMapView)
    let location: CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    var title:String = ""
      
    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
      
      if error != nil {
        print("there is an error")
      }
      if placemarks?.count > 0{
        let pm = CLPlacemark(placemark: placemarks![0])
        var thoroughfare:String = ""
        var subthoroughfare:String = ""
        if pm.thoroughfare != nil{
          thoroughfare = pm.thoroughfare!
        }
        if pm.subThoroughfare != nil{
          subthoroughfare = pm.subThoroughfare!
        }
        
        title = "\(thoroughfare) \(subthoroughfare)"

      }
      else {
        print("Problem with the data received from geocoder")
      }
      
      if title != " "{
        self.newPlace = FavPlace(name: title)
        self.newPlace?.lat = coordinate.latitude
        self.newPlace?.lon = coordinate.longitude
        placeList.addObject(self.newPlace!)
      }
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      annotation.title = self.newPlace!.address
      self.myMapView.addAnnotation(annotation)
      
    })
    
    //add alert window before add the new place to the list
    if gestureRecognizer.state == .Began{
      var myAlertView = UIAlertController()
      myAlertView = UIAlertController(title:"Alert", message: "Add new favoriate place", preferredStyle: .Alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    myAlertView.addAction(cancelAction)
      let addAction = UIAlertAction(title: "Add", style: .Default, handler: {action in self.pressed()})
    myAlertView.addAction(addAction)
    self.presentViewController(myAlertView, animated: true, completion: nil)
    }
    }
  }
  
  func pressed(){
    let vc = ListViewController()
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  //add new faviorate place
  func addPlaces(sender:UIButton!){
    print("pressed")
//    let navController = UINavigationController(rootViewController: ListViewController())
//    self.presentViewController(navController, animated: true, completion: nil)
    let vc = ListViewController() as ListViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func addAnnotation(addedPlace: FavPlace, updated: Bool){
    let latitude: CLLocationDegrees = addedPlace.lat
    let longitude: CLLocationDegrees = addedPlace.lon
    let latDelta: CLLocationDegrees = 0.02
    let longDelta: CLLocationDegrees = 0.02
    let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
    let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
    myMapView.setRegion(region, animated: true)
    let annotation = MKPointAnnotation()
    annotation.coordinate = location
    annotation.title = addedPlace.address
    self.myMapView.addAnnotation(annotation)
    if updated{
    myMapView.selectAnnotation(annotation, animated: true)
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation:CLLocation = locations[0]
    let latitude: CLLocationDegrees = userLocation.coordinate.latitude
    let longitude: CLLocationDegrees = userLocation.coordinate.longitude
    let latDelta: CLLocationDegrees = 0.02
    let longDelta: CLLocationDegrees = 0.02
    let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
    let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
    self.myMapView.setRegion(region, animated: true)
  }
  
  override func viewWillAppear(animated: Bool) {
    for place in placeList{
      addAnnotation(place as! FavPlace, updated: false)
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

