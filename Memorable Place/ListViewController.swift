//
//  ListViewController.swift
//  Memorable Place
//
//  Created by Grace Du on 7/22/16.
//  Copyright © 2016 Grace Du. All rights reserved.
//

import Foundation
import UIKit

var placeList = NSMutableArray()
var returnIndex: Int = -1
//let defaults = NSUserDefaults.standardUserDefaults()


class ListViewController: UIViewController,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var myTableView = UITableView()
    
    
    override func viewDidLoad() {
        
        self.title = "My favorite places"
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.frame = CGRectMake(0, 20, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        
        self.navigationItem.hidesBackButton = true
        let leftBarButton = UIBarButtonItem(title: "Map", style: .Bordered, target: self, action: #selector(map))
        self.navigationItem.leftBarButtonItem = leftBarButton
//        defaults.setObject(placeList[returnIndex], forKey: "myPlaceList")
//        defaults.synchronize()
    }
    
    func map(sender:UIBarButtonItem){
        self.navigationController?.pushViewController(ViewController(), animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let addedPlace:FavPlace = placeList.objectAtIndex(indexPath.row) as! FavPlace
        cell.textLabel!.text = addedPlace.address
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        returnIndex = indexPath.row
        print(returnIndex)
        self.navigationController?.pushViewController(ViewController(), animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        returnIndex = indexPath.row
        return indexPath
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == .Delete{
            placeList.removeObjectAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }

        
    override func viewWillAppear(animated: Bool) {
        myTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
