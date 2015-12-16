//
//  TodayTomorrowViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/3/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData

class TodayTomorrowViewController: UIViewController, ManagedObjectContextSettable
{
   var managedObjectContext: NSManagedObjectContext!
   
   @IBOutlet weak private var _topContainerView: UIView! {
      didSet {
         _topContainerView.layer.masksToBounds = true
         _topContainerView.layer.cornerRadius = 6
      }
   }
   @IBOutlet weak private var _bottomContainerView: UIView! {
      didSet {
         _bottomContainerView.layer.masksToBounds = true
         _bottomContainerView.layer.cornerRadius = 6
      }
   }
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      navigationItem.title = "Active"
      automaticallyAdjustsScrollViewInsets = false
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if let todayVC = segue.destinationViewController as? TodayViewController {
         todayVC.managedObjectContext = managedObjectContext
      }
      else if let tomorrowVC = segue.destinationViewController as? TomorrowViewController {
         tomorrowVC.managedObjectContext = managedObjectContext
      }
   }
}
