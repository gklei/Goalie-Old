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
      tintColor = UIColor.whiteColor()
      
      titleTextAttributes = [
         NSFontAttributeName : UIFont.mediumGoalieFontWithSize(16),
         NSForegroundColorAttributeName : UIColor.lightBlueTextColor()
      ]
      
      let barButtonItemAttrs = [
         NSFontAttributeName : UIFont.mediumGoalieFontWithSize(16),
         NSForegroundColorAttributeName : UIColor.lightBlueTextColor()
      ]
      leftBarButtonItem?.setTitleTextAttributes(barButtonItemAttrs, forState: .Normal)
      rightBarButtonItem?.setTitleTextAttributes(barButtonItemAttrs, forState: .Normal)

      let backgroundImage = UIImage.imageWithColor(UIColor.mainNavBarColor())
      setBackgroundImage(backgroundImage, forBarMetrics: UIBarMetrics.Default)
   }
   
   func updateTitleFontSize(size: CGFloat)
   {
      titleTextAttributes?[NSFontAttributeName] = UIFont.mediumGoalieFontWithSize(size)
   }
   
   func updateTitleFont(font: UIFont)
   {
      titleTextAttributes?[NSFontAttributeName] = font
   }
   
   func updateKerningValue(value: Int)
   {
      titleTextAttributes?[NSKernAttributeName] = value
   }
   
   func updateTitleColor(color: UIColor)
   {
      titleTextAttributes?[NSForegroundColorAttributeName] = color
   }
   
   func updateTitle(title: String)
   {
      items?.first?.title = title
   }
   
   func updateBackgroundColor(color: UIColor)
   {
      setBackgroundImage(UIImage.imageWithColor(color), forBarMetrics: .Default)
   }
   
   func updateLeftBarButtonItemTitle(title: String)
   {
      leftBarButtonItem?.title = title
   }
   
   func updateRightBarButtonItemTitle(title: String)
   {
      rightBarButtonItem?.title = title
   }
}
