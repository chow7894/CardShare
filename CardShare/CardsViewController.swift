//
//  CardsViewController.swift
//  CardShare
//
//  Created by Christine Abernathy on 10/12/14.
//  Copyright (c) 2014 Elidora LLC. All rights reserved.
//

import UIKit

class CardsViewController: UITableViewController {
  var selectedCard: Card?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.tableView!.reloadData()
  }
  
  // MARK: - Table view data source
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let delegate = UIApplication.sharedApplication().delegate as AppDelegate
    return delegate.otherCards.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let delegate = UIApplication.sharedApplication().delegate as AppDelegate
    let card = delegate.otherCards[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier("CardsCell", forIndexPath: indexPath) as UITableViewCell
    cell.textLabel.text = "\(card.firstName) \(card.lastName)"
    cell.detailTextLabel?.text = card.company
    cell.imageView.image = card.image
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100.0
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let delegate = UIApplication.sharedApplication().delegate as AppDelegate
    self.selectedCard = delegate.otherCards[indexPath.row]
    self.performSegueWithIdentifier("SegueToCardDetail2", sender: self)
  }
  
  // MARK: - Navigation methods
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let identifier = segue.identifier {
      if identifier == "SegueToCardDetail2" {
        let singleCardViewController = segue.destinationViewController as SingleCardViewController
        singleCardViewController.card = self.selectedCard
      }
    }
  }
}
