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
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
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
