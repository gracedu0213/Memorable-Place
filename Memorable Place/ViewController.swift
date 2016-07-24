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

class ViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate{
  
  var myMapView = MKMapView()

  override func viewDidLoad() {
    
    
    
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.navigationItem.title = "Map"
//    let barButtonRight = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addPlaces))
//    self.navigationItem.setRightBarButtonItem(barButtonRight, animated: true)
    
    
    //create the navigation bar
    let navBar = UINavigationBar(frame: CGRectMake(0, 20, UIScreen.mainScreen().bounds.width, 44))
    self.view.addSubview(navBar)
    let navItem = UINavigationItem(title: "Map")
    let barButtonRight = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addPlaces))
    navItem.setRightBarButtonItem(barButtonRight, animated: true)
    navBar.setItems([navItem], animated: true)
    
    //create the map view
    myMapView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64)
    self.view.addSubview(myMapView)
    //43.659431, -79.385088 at 761 Bay Street
    let latitude: CLLocationDegrees = 43.659431
    let longitude: CLLocationDegrees = -79.385088
    let latDelta: CLLocationDegrees = 0.1
    let longDelta: CLLocationDegrees = 0.1
    let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
    let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
    myMapView.setRegion(region, animated: true)
  
    let ulpgr = UILongPressGestureRecognizer(target: self, action: #selector(pressAction))
    ulpgr.minimumPressDuration = 1
    myMapView.addGestureRecognizer(ulpgr)
  
    }
  
  //long pressed function
  func pressAction(gestureRecognizer: UILongPressGestureRecognizer){
    let touchPoint = gestureRecognizer.locationInView(myMapView)
    let location: CLLocationCoordinate2D = myMapView.convertPoint(touchPoint, toCoordinateFromView: myMapView)
    
    //add alert window before add the new place to the list
    let myAlert = UIAlertController(title:"Alert", message: "Add new favoriate place", preferredStyle: .Alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    myAlert.addAction(cancelAction)
    let addAction = UIAlertAction(title: "Add", style: .Default, handler: nil)
    myAlert.addAction(addAction)
    if(self.navigationController == nil){
      print("nil")
    }
    //self.navigationController?.pushViewController(myAlert, animated: true)
    //self.presentViewController(myAlert, animated: true, completion: nil)
    
    
    
//    let myAlert = UIAlertView()
//    myAlert.addButtonWithTitle("Add")
//    myAlert.addButtonWithTitle("Cancel")
//    myAlert.title = "Alert"
//    myAlert.message = "Add new favorite place?"
//    myAlert.show()
    
  }
  
  
  //add new faviorate place
  func addPlaces(sender:UIButton!){
    print("pressed")
    let navController = UINavigationController(rootViewController: ListViewController())
    self.presentViewController(navController, animated: true, completion: nil)
//    let vc = ListViewController() as ListViewController
//    self.navigationController?.pushViewController(vc, animated: true)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

