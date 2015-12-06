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
      
      let barButtonItemAttrs = Theme.titleTextAttributesForComponent(.NavBarButtonItem)
      leftBarButtonItem?.setTitleTextAttributes(barButtonItemAttrs, forState: .Normal)
      rightBarButtonItem?.setTitleTextAttributes(barButtonItemAttrs, forState: .Normal)
      
      let backgroundImage = UIImage.imageWithColor(UIColor.whiteColor())
      setBackgroundImage(backgroundImage, forBarMetrics: UIBarMetrics.Default)
   }
   
   func updateTitleFontSize(size: CGFloat)
   {
      titleTextAttributes = Theme.titleTextAttributesForComponent(.NavBar)
      if let font = titleTextAttributes?[NSFontAttributeName] as? UIFont
      {
         let newFont = UIFont(name: font.fontName, size: size)!
         titleTextAttributes?[NSFontAttributeName] = newFont
      }
   }
   
   func updateTitle(title: String)
   {
      items?.first?.title = title
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
