//
//  AppDelegate.swift
//  CardShare
//
//  Created by Christine Abernathy on 9/28/14.
//  Copyright (c) 2014 Elidora LLC. All rights reserved.
//

import UIKit
import MultipeerConnectivity

let kServiceType = "rw-cardshare"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var myCard: Card? {
    didSet {
      // Store card when value set
      self.storeMyCard()
    }
  }
  var cards: [Card] = []
  var otherCards: [Card] = []
  
  var session: MCSession?
  var peerID: MCPeerID?
  
  private var advertiserAssistant: MCAdvertiserAssistant?
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    // Set appearance info
    UITabBar.appearance().tintColor = UIColor.whiteColor()
    UITabBar.appearance().barTintColor = self.mainColor()
    
    UINavigationBar.appearance().barStyle = UIBarStyle.Black
    UINavigationBar.appearance().barTintColor = self.mainColor()
    
    UIToolbar.appearance().barStyle = UIBarStyle.Black
    UIToolbar.appearance().barTintColor = self.mainColor()
    
    // Initialize any stored data
    let defaults = NSUserDefaults.standardUserDefaults()
    if let myCardData = defaults.dataForKey("myCard") {
      myCard = NSKeyedUnarchiver.unarchiveObjectWithData(myCardData) as? Card
    }
    if let otherCardsData = defaults.dataForKey("otherCards") {
      otherCards = NSKeyedUnarchiver.unarchiveObjectWithData(otherCardsData) as! [Card]
    }
    
    //1
    let firstName = self.myCard?.firstName
    let peerName = firstName != nil ? firstName: UIDevice.currentDevice().name
    self.peerID = MCPeerID(displayName: peerName)
    //2
    self.session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .None)
    self.session?.delegate = nil
    //3
    self.advertiserAssistant = MCAdvertiserAssistant(serviceType: kServiceType, discoveryInfo: nil, session: self.session)
    //4
    self.advertiserAssistant?.start()
    
    return true
  }
  
  // MARK: - Public helper methods
  func mainColor() -> UIColor {
    return UIColor(red: 28.0/255.0, green: 171.0/255.0, blue: 116.0/255.0, alpha: 1.0)
  }
  
  func addToOtherCardsList(card: Card) {
    self.otherCards.append(card)
    // Update stored value
    let defaults = NSUserDefaults.standardUserDefaults()
    let data = NSKeyedArchiver.archivedDataWithRootObject(self.otherCards)
    defaults.setObject(data, forKey: "otherCards")
    defaults.synchronize()
  }
  
  func removeCardFromExchangeList(card: Card) {
    var cardsSet = NSMutableSet(array: self.cards)
    cardsSet.removeObject(card)
    self.cards = cardsSet.allObjects as! [Card]
  }
  
  // MARK: - Private methods
  private func storeMyCard() {
    if let aCard = self.myCard {
      let defaults = NSUserDefaults.standardUserDefaults()
      // Create an NSData representation
      let data = NSKeyedArchiver.archivedDataWithRootObject(aCard)
      defaults.setObject(data, forKey: "myCard")
      defaults.synchronize()
    }
  }
}

