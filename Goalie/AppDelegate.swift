//
//  AppDelegate.swift
//  Goalie
//
//  Created by Gregory Klein on 12/3/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
   var window: UIWindow?
   var managedObjectContext: NSManagedObjectContext!

   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
   {
      Fabric.with([Crashlytics.self])
      
      managedObjectContext = createGoalieMainContext()
      passManagedObjectContextToViewControllers(managedObjectContext)
      
      return true
   }
   
   private func passManagedObjectContextToViewControllers(moc: NSManagedObjectContext)
   {
      if let tabBarController = window?.rootViewController as? UITabBarController,
      let controllers = tabBarController.viewControllers
      {
         for controller in controllers
         {
            let failureMessage = preconditionFailureMessageForController(controller)
            if let navController = controller as? UINavigationController
            {
               guard let firstVC = navController.viewControllers.first as? ManagedObjectContextSettable else { fatalError(failureMessage) }
               firstVC.managedObjectContext = managedObjectContext
            }
            else
            {
               guard let vc = controller as? ManagedObjectContextSettable else { fatalError(failureMessage) }
               vc.managedObjectContext = managedObjectContext
            }
         }
      }
   }
   
   private func preconditionFailureMessageForController(controller: UIViewController) -> String
   {
      return "All of the view controllers in GoalieTabBarController must comform to ManagedObjectContextSettable -- \(controller) does not!"
   }
}

