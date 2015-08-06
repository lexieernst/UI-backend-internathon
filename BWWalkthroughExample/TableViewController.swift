//
//  TableViewController.swift
//  BWWalkthroughExample
//
//  Created by Lexie Ernst on 8/5/15.
//  Copyright (c) 2015 Yari D'areglia. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return myData.count
    }

    //this was commented out before, demo had me uncomment
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellId: String = "Cell"
        
        //For Mohammad Thursday AM before intern proj
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellId) as UITableViewCell
        
        if let ip = indexPath {
            cell.textLabel.text = myData[ip.row] as String
        }
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    let placesByBeacons = [
        // beacon 1
        "32592:1607": [
            "Philips Norelco Shaver": 100 // read as: 100 meters from location1 to beacon with major as major1 and minor as minor1
            // ...
        ],
        
        // beacon 2
        "19392:878": [
            "Britax Strollers": 250
            // ...
        ],
        
        // beacon 3
        "2234:41999": [
            "Lego Duplo": 250
            // ...
        ]
        
        
        // add more beacons if necessary
    ]
    
    // method that takes a beacon and returns a sorted list of all the places (from least possible
    // TODO: updating UI here is necessary
    func placesNearBeacon(beacon: CLBeacon) -> [String] {
        let beaconKey = "\(beacon.major):\(beacon.minor)"
        if let departments = self.placesByBeacons[beaconKey] {
            let sortedDepartments = Array(departments).sorted { $0.1 < $1.1 }.map { $0.0 }
            return sortedDepartments
        }
        return []
    }
    //lexie
    
    var myData: Array<AnyObject> = []
    
    
    func beaconManager(
        
        
        manager: AnyObject!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
            if let nearestBeacon = beacons.first as? CLBeacon {
                let dept = placesNearBeacon(nearestBeacon)
                // TODO: update UI here
                //                    println("lexie rox")
                print("")
                for value in dept {
                    //                        print(value)
                    myData.append(dept)
                }
                println(myData[-1])
            }
    }
    
    // ranging beaconManager
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"),
        identifier: "ranged region")
    
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // setting the beaconManager's delegate
//        self.beaconManager.delegate = self
//        // request authorization for every beaconManager
//        self.beaconManager.requestAlwaysAuthorization()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if !userDefaults.boolForKey("walkthroughPresented") {
            
            showWalkthrough()
            
            userDefaults.setBool(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }
    
    // start ranging as viewController appears on screen
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    // stop ranging as viewController disappears on screen
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
    
    @IBAction func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewControllerWithIdentifier("walk0") as! UIViewController
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1") as! UIViewController
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2")as! UIViewController
        let page_three = stb.instantiateViewControllerWithIdentifier("walk3") as! UIViewController
        
        // Attach the pages to the master
//        walkthrough.delegate = self
//        walkthrough.addViewController(page_one)
//        walkthrough.addViewController(page_two)
//        walkthrough.addViewController(page_three)
//        walkthrough.addViewController(page_zero)
        
        self.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(pageNumber: Int) {
        println("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
