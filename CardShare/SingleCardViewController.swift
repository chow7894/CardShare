//
//  ViewController.swift
//  CardShare
//
//  Created by Christine Abernathy on 9/28/14.
//  Copyright (c) 2014 Elidora LLC. All rights reserved.
//

import UIKit

class SingleCardViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var companyLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var websiteLabel: UILabel!
  @IBOutlet weak var addToCardsButton: UIButton!
  
  var card: Card?
  var enableAddToCards = false
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if self.card == nil {
      let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
      self.fetchCardInfo(delegate.myCard)
    } else {
      self.fetchCardInfo(self.card)
      self.navigationItem.rightBarButtonItem = nil
    }
    if self.enableAddToCards {
      self.addToCardsButton.hidden = false
    }
  }
  
  @IBAction func addToCardsPressed(sender: AnyObject) {
    if let cardToAdd = self.card {
      let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
      delegate.addToOtherCardsList(cardToAdd)
      
      // Remove the card from the exchange card list
      delegate.removeCardFromExchangeList(cardToAdd)
      
      // Display a confirmation message to the user
      let alert = UIAlertController(
        title: "Success",
        message: "Added the selected business card to your list",
        preferredStyle: .Alert)
      let action = UIAlertAction(
        title: "OK",
        style: .Default) { _ in
          // Show the card list if got here from that flow
          if self.navigationController != nil {
            self.navigationController!.popToRootViewControllerAnimated(true)
          }
      }
      alert.addAction(action)
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }
  
  private func fetchCardInfo(card: Card!) {
    if card != nil {
      self.imageView.image = card.image
      self.fullNameLabel.text = "\(card.firstName) \(card.lastName)"
      self.companyLabel.text = card.company
      self.emailLabel.text = card.email
      self.phoneLabel.text = card.phone
      self.websiteLabel.text = card.website
      
      // Un-gray out the default fonts
      self.fullNameLabel.textColor = UIColor.blackColor()
    }
  }
  
}

