//
//  Card.swift
//  CardShare
//
//  Created by Christine Abernathy on 10/5/14.
//  Copyright (c) 2014 Elidora LLC. All rights reserved.
//

import Foundation
import UIKit

class Card: NSObject, NSCoding {
  var image: UIImage?
  var firstName: String!
  var lastName: String!
  var company: String!
  var email: String!
  var phone: String!
  var website: String!
  
  override init() {}
  
  required init(coder aDecoder: NSCoder) {
    super.init()
    if let imageData = aDecoder.decodeObjectForKey("image") as? NSData {
      image = UIImage(data: imageData)
    }
    firstName = aDecoder.decodeObjectForKey("firstName") as String
    lastName = aDecoder.decodeObjectForKey("lastName") as String
    company = aDecoder.decodeObjectForKey("company") as String
    email = aDecoder.decodeObjectForKey("email") as String
    phone = aDecoder.decodeObjectForKey("phone") as String
    website = aDecoder.decodeObjectForKey("website") as String
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    if let imageUnwrapped = image {
      let imageData = UIImagePNGRepresentation(imageUnwrapped)
      aCoder.encodeObject(imageData, forKey: "image")
    }
    aCoder.encodeObject(firstName, forKey: "firstName")
    aCoder.encodeObject(lastName, forKey: "lastName")
    aCoder.encodeObject(company, forKey: "company")
    aCoder.encodeObject(email, forKey: "email")
    aCoder.encodeObject(phone, forKey: "phone")
    aCoder.encodeObject(website, forKey: "website")
  }
}
