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
      
      let tabBarColor = ThemeNormalStateTextColor
      tabBar.backgroundImage = UIImage.imageWithColor(tabBarColor)
//      tabBar.shadowImage = UIImage.imageWithColor(UIColor.clearColor())
      tabBar.tintColor = ThemeSelectedStateTextColor

      if let tabBarItems = tabBar.items
      {
         var normalAttrs = Theme.titleTextAttributesForComponent(.TabBar, controlState: .Normal)
         normalAttrs[NSForegroundColorAttributeName] = ThemeTabBarColor
         
         let selectedAttrs = Theme.titleTextAttributesForComponent(.TabBar, controlState: .Selected)
         
         for item in tabBarItems
         {
            item.setTitleTextAttributes(normalAttrs, forState: .Normal)
            item.setTitleTextAttributes(selectedAttrs, forState: .Selected)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
         }
      }
   }
}
