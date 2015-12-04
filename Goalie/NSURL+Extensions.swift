//
//  NSURL+Extensions.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation

extension NSURL
{
   static func temporaryURL() -> NSURL
   {
      return try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent(NSUUID().UUIDString)
   }
   
   static var documentsURL: NSURL
   {
      return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
   }
}
