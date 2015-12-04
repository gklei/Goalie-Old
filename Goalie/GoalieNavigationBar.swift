//
//  GoalieNavigationBar.swift
//  Goalie
//
//  Created by Gregory Klein on 12/3/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class GoalieNavigationBar: UINavigationBar
{
   override func awakeFromNib()
   {
      hideBottomHairline()
      tintColor = ThemeTitleTextColor
      titleTextAttributes = Theme.titleTextAttributesForComponent(.NavBar)
      
      let backgroundImage = UIImage.imageWithColor(UIColor.whiteColor())
      setBackgroundImage(backgroundImage, forBarMetrics: UIBarMetrics.Default)
   }
}
