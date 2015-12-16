//
//  GoalieTabBarController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/3/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class GoalieTabBarController: UITabBarController
{
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      tabBar.backgroundImage = UIImage.imageWithColor(UIColor.mainTabBarColor())
      tabBar.shadowImage = UIImage.imageWithColor(UIColor.clearColor())
      tabBar.tintColor = UIColor.lightBlueTextColor()

      if let tabBarItems = tabBar.items
      {
         let normalAttributes = [
            NSFontAttributeName : UIFont.mediumGoalieFontWithSize(14),
            NSForegroundColorAttributeName : UIColor.lightPurpleTextColor()
         ]
         let selectedAttributes = [
            NSFontAttributeName : UIFont.mediumGoalieFontWithSize(14),
            NSForegroundColorAttributeName : UIColor.lightBlueTextColor()
         ]
         
         for item in tabBarItems
         {
            item.setTitleTextAttributes(normalAttributes, forState: .Normal)
            item.setTitleTextAttributes(selectedAttributes, forState: .Selected)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
         }
      }
   }
}
