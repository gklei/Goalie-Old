//
//  UIImage+Extensions.swift
//  Goalie
//
//  Created by Gregory Klein on 12/3/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

extension UIImage
{
   class func imageWithColor(color: UIColor, size: CGSize) -> UIImage
   {
      let rect = CGRectMake(0, 0, size.width, size.height)
      UIGraphicsBeginImageContextWithOptions(size, false, 0)
      
      color.setFill()
      UIRectFill(rect)
      
      let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      return image
   }
   
   class func sampleAlternatingColorImageWithSize(size: CGSize) -> UIImage
   {
      UIGraphicsBeginImageContextWithOptions(size, false, 0)
      
      UIColor(red: 45/255.0, green: 49/255.0, blue: 78/255.0, alpha: 1).setFill()
      let topHalf = CGRect(x: 0, y: size.height * 0.5, width: size.width, height: size.height * 0.5)
      UIRectFill(topHalf)
      
      UIColor(red: 55/255.0, green: 57/255.0, blue: 86/255.0, alpha: 1).setFill()
      let bottomHalf = CGRect(x: 0, y: 0, width: size.width, height: size.height * 0.5)
      UIRectFill(bottomHalf)
      
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      return image
   }
   
   class func alternateImageWithWidth(width: CGFloat, height: CGFloat, topPadding: CGFloat) -> UIImage
   {
      UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height + topPadding), false, 0)
      
      let topRect = CGRect(x: 0, y: 0, width: width, height: topPadding)
      UIColor.orangeColor().setFill()
      UIRectFill(topRect)
      
      let size = CGSize(width: width, height: height)
      
      UIColor(red: 45/255.0, green: 49/255.0, blue: 78/255.0, alpha: 1).setFill()
      let topHalf = CGRect(x: 0, y: size.height * 0.5 + topPadding, width: size.width, height: size.height * 0.5)
      UIRectFill(topHalf)
      
      UIColor(red: 55/255.0, green: 57/255.0, blue: 86/255.0, alpha: 1).setFill()
      let bottomHalf = CGRect(x: 0, y: topPadding, width: size.width, height: size.height * 0.5)
      UIRectFill(bottomHalf)
      
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      return image
   }
   
   // Meant for tiling
   class func imageWithColor(color: UIColor) -> UIImage
   {
      return imageWithColor(color, size: CGSize(width: 1, height: 1))
   }
}
