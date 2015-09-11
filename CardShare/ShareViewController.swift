//
//  ShareViewController.swift
//  CardShare
//
//  Created by Christine Abernathy on 10/12/14.
//  Copyright (c) 2014 Elidora LLC. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class ShareViewController: UIViewController,
  UITableViewDataSource, UITableViewDelegate, MCBrowserViewControllerDelegate {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var emptyAddButton: UIButton!
  @IBOutlet weak var exchangeNavBarButton: UIBarButtonItem!
  @IBOutlet weak var emptyInstructionsLabel: UILabel!
  
  var selectedCard: Card?
  
  // MARK: - View lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataReceived:", name: DataReceivedNotification, object: nil)
  }
  
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    dataReceived(nil)
  }
  
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: DataReceivedNotification, object: nil)
  }
  
  
  // MARK: - Action methods
  @IBAction func addCardPressed(sender: AnyObject) {
    let delegate =
    UIApplication.sharedApplication().delegate as! AppDelegate
    
    // Check if the user has set up their business card
    if delegate.myCard == nil {
      showMessage("Please set up your business card first")
    } else {
      if delegate.session?.connectedPeers.count == 0 {
        let browserViewController = MCBrowserViewController(serviceType: kServiceType, session: delegate.session)
        browserViewController.view.tintColor = UIColor.whiteColor()
        browserViewController.delegate = self
        self.presentViewController(browserViewController, animated: true, completion: nil)
      } else  {
        sendCard()
      }
    }
  }
  
  func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
    browserViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
      self.sendCard()
      
    })
  }
  
  
  func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
    browserViewController.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let identifier = segue.identifier {
      if identifier == "SegueToCardDetail" {
        let singleCardViewController =
        segue.destinationViewController as! SingleCardViewController
        singleCardViewController.card = self.selectedCard
        singleCardViewController.enableAddToCards = true
      }
    }
  }
  
  // MARK: - UITableView delegate and datasource methods  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    return delegate.cards.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let card = delegate.cards[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier("CardsCell", forIndexPath: indexPath) as! UITableViewCell
    cell.textLabel!.text = "\(card.firstName) \(card.lastName)"
    cell.detailTextLabel?.text = card.company
    cell.imageView!.image = card.image
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100.0
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    self.selectedCard = delegate.cards[indexPath.row]
    self.performSegueWithIdentifier("SegueToCardDetail", sender: self)
  }
  
  // MARK: - Helper methods
  private func showHideNoDataView() {
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    if delegate.cards.count == 0 {
      self.emptyAddButton.hidden = false
      self.emptyInstructionsLabel.hidden = false
      self.tableView.hidden = true
      self.navigationItem.rightBarButtonItem = nil
    } else {
      self.emptyAddButton.hidden = true
      self.emptyInstructionsLabel.hidden = true
      self.tableView.hidden = false
      self.navigationItem.rightBarButtonItem = self.exchangeNavBarButton
    }
  }
  
  private func showMessage(message: String) {
    let alert = UIAlertController(
      title: "",
      message: message,
      preferredStyle: .Alert)
    alert.addAction(UIAlertAction(
      title: "OK",
      style: .Default,
      handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  private func sendCard() {
    let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
    delegate?.sendCardToPeer()
    showMessage("Card sent to nearbt device")
  }
  
  func dataReceived(notification: NSNotification?) {
    showHideNoDataView()
    self.tableView.reloadData()
    
  }
  
}