//
//  MyBrowserViewController.swift
//  CardShare
//
//  Created by Christine Abernathy on 10/12/14.
//  Copyright (c) 2014 Elidora LLC. All rights reserved.
//

import UIKit
import MultipeerConnectivity

@objc protocol MyBrowserViewControllerDelegate {
  // Called when the user taps the Done button
  optional func myBrowserViewControllerDidFinish(browserViewController: MyBrowserViewController)
  
  // Called when the user taps the Cancel button
  optional func myBrowserViewControllerWasCancelled(browserViewController: MyBrowserViewController)
}

class MyBrowserViewController: UIViewController, UIToolbarDelegate {
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet var doneButton: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
  
  var delegate: MyBrowserViewControllerDelegate?
  
  var maximumNumberOfPeers = 8
  var minimumNumberOfPeers = 2
  
  private var nearbyPeers: [MCPeerID] = []
  private var acceptedPeers: [MCPeerID] = []
  private var declinedPeers: [MCPeerID] = []
  
  private var tableViewCellIdentifier = "NearbyDevicesCell"
  
  // MARK: - View lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the toolbar delegate to be able
    // to position it to the top of the view.
    self.toolbar.delegate = self
    
    self.tableView.registerClass(MyBrowserTableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
    
    showDoneButton(false)
  }
  
  // MARK: - UIToolbarDelegate methods
  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return UIBarPosition.TopAttached
  }
  
  // MARK: - Table view data source and delegate methods
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.nearbyPeers.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(
      tableViewCellIdentifier, forIndexPath: indexPath)
      as MyBrowserTableViewCell
    return cell
  }
  
  // MARK: - Action methods
  @IBAction func cancelButtonPressed(sender: AnyObject) {
    // Send the delegate a message that the controller was canceled.
    delegate?.myBrowserViewControllerWasCancelled?(self)
  }
  
  @IBAction func doneButtonPressed(sender: AnyObject?) {
    // Send the delegate a message that the controller was done browsing.
    delegate?.myBrowserViewControllerDidFinish?(self)
  }
  
  // MARK: - Helper methods  
  private func showDoneButton(display: Bool) {
    if display {
      // Show the done button
      if var toolbarButtons = self.toolbar.items as? [UIBarButtonItem] {
        if !contains(toolbarButtons, self.doneButton) {
          toolbarButtons.append(self.doneButton)
          self.toolbar.setItems(toolbarButtons, animated: false)
        }
      } else {
        self.toolbar.setItems([self.doneButton], animated: false)
      }
    } else {
      // Hide the done button
      if var toolbarButtons = self.toolbar.items as? [UIBarButtonItem] {
        if let doneButtonIndex = find(toolbarButtons, self.doneButton) {
          toolbarButtons.removeAtIndex(doneButtonIndex)
          self.toolbar.setItems(toolbarButtons, animated: false)
        }
      }
    }
  }
  
  private func removePeer(peerID: MCPeerID, list: [MCPeerID]) -> [MCPeerID] {
    var peersSet = NSMutableSet(array: list)
    peersSet.removeObject(peerID)
    return peersSet.allObjects as [MCPeerID]
  }
}