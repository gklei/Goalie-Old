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

private let UserHasOnboardedKey = "UserHasOnboardedKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
   var window: UIWindow?
   var managedObjectContext: NSManagedObjectContext!
   private let _mainTabBarController = UIStoryboard.mainTabBarController()

   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
   {
      Fabric.with([Crashlytics.self])
      
      managedObjectContext = createGoalieMainContext()
      _passViewControllersManagedObjectContext(managedObjectContext)
      
      window = UIWindow(frame: UIScreen.mainScreen().bounds)
      _setupNormalWindow()
      
      // As hacky as this is, I'm cool with it for now.  It's so that the keyboard doesn't lag the first time it shows up
      _removeInitialKeyboardLag()
      window?.makeKeyAndVisible()
      
      let selectionView = UIView()
      selectionView.backgroundColor = UIColor.lightPurpleTextColor().colorWithAlphaComponent(0.3)
      UITableViewCell.appearance().selectedBackgroundView = selectionView
      
      return true
   }
   
   private func _removeInitialKeyboardLag()
   {
      let dummyTextField = UITextField()
      window?.addSubview(dummyTextField)
      dummyTextField.becomeFirstResponder()
      dummyTextField.resignFirstResponder()
      window?.removeFromSuperview()
   }
   
   private func _passViewControllersManagedObjectContext(moc: NSManagedObjectContext)
   {
      if let controllers = _mainTabBarController.viewControllers {
         for controller in controllers {
            let failureMessage = preconditionFailureMessageForController(controller)
            if let navController = controller as? UINavigationController {
               guard let firstVC = navController.viewControllers.first as? ManagedObjectContextSettable else { fatalError(failureMessage) }
               firstVC.managedObjectContext = managedObjectContext
            }
            else {
               guard let vc = controller as? ManagedObjectContextSettable else { fatalError(failureMessage) }
               vc.managedObjectContext = managedObjectContext
            }
         }
      }
   }
   
   private func _setupNormalWindow()
   {
      window?.rootViewController = _mainTabBarController
   }
   
   private func preconditionFailureMessageForController(controller: UIViewController) -> String
   {
      return "All of the view controllers in GoalieTabBarController must comform to ManagedObjectContextSettable -- \(controller) does not!"
   }
}

