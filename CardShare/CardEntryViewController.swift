//
//  CardEntryViewController.swift
//  CardShare
//
//  Created by Christine Abernathy on 10/12/14.
//  Copyright (c) 2014 Elidora LLC. All rights reserved.
//

import UIKit

class CardEntryViewController: UIViewController, UIToolbarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var companyTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var websiteTextField: UITextField!
  @IBOutlet weak var cardImageView: UIImageView!
  
  override func viewDidLoad() {
    // Set the toolbar delegate to be able
    // to position it to the top of the view.
    self.toolbar.delegate = self;
    
    // Get the current card values
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    if let myCard = delegate.myCard {
      self.cardImageView.image = myCard.image
      self.firstNameTextField.text = myCard.firstName
      self.lastNameTextField.text = myCard.lastName
      self.companyTextField.text = myCard.company
      self.emailTextField.text = myCard.email
      self.phoneTextField.text = myCard.phone
      self.websiteTextField.text = myCard.website
    }
  }
  
  // MARK: - Action methods
  @IBAction func cancelPressed(sender: AnyObject) {
    self.presentingViewController?.dismissViewControllerAnimated(
      true, completion: nil)
  }
  
  @IBAction func savePressed(sender: AnyObject) {
    // Validate minimum data: first name and photo
    var errorMessage = "Please "
    var displayError = false
    if self.firstNameTextField.text == "" {
      displayError = true
      errorMessage = "\(errorMessage)enter your first name"
    }
    if self.cardImageView.image == nil {
      if displayError {
        errorMessage = "\(errorMessage) and "
      }
      displayError = true
      errorMessage = "\(errorMessage)add a photo"
    }
     errorMessage = "\(errorMessage)."
    if displayError {
      showMessage(errorMessage)
      return
    }
    
    // Set the user's card info
    var card = Card()
    card.firstName = self.firstNameTextField.text
    card.lastName = self.lastNameTextField.text
    card.company = self.companyTextField.text
    card.email = self.emailTextField.text
    card.phone = self.phoneTextField.text
    card.website = self.websiteTextField.text
    card.image = self.cardImageView.image
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    delegate.myCard = card
    
    self.presentingViewController?.dismissViewControllerAnimated(
      true, completion: nil)
  }
  
  // MARK: - UIToolbarDelegate methods
  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return UIBarPosition.TopAttached
  }
  
  // MARK: - UIImagePickerControllerDelegate methods
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    // Based on Ray Wenderlich tutorial on how to make an Instagram app
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    // Resize the image from the camera
    let scaledImage = image.resizedImageWithContentMode(
      .ScaleAspectFill,
      bounds: CGSizeMake(self.cardImageView.frame.size.width, self.cardImageView.frame.size.height),
      interpolationQuality: kCGInterpolationHigh)
    // Crop the image to a square
    let croppedImageRect = CGRectMake(
      (scaledImage.size.width - self.cardImageView.frame.size.width) / 2,
      (scaledImage.size.height - self.cardImageView.frame.size.height) / 2,
      self.cardImageView.frame.size.width,
      self.cardImageView.frame.size.height)
    let croppedImage = scaledImage.croppedImage(croppedImageRect)
    self.cardImageView.image = croppedImage
    // Dismiss the image picker
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
  }
  
  /*
  * A simple way to dismiss the keyboard:
  * whenever the user clicks outside a text field.
  * Also handles click to add or edit a photo
  */
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    //if let imageData = aDecoder.decodeObjectForKey("image") as? NSData {
    if let touch = touches.first as? UITouch {
      if let textField = touch.view as? UITextField {
        if self.firstNameTextField.isFirstResponder() {
          self.firstNameTextField.resignFirstResponder()
        }
        if self.lastNameTextField.isFirstResponder() {
          self.lastNameTextField.resignFirstResponder()
        }
        if self.companyTextField.isFirstResponder() {
          self.companyTextField.resignFirstResponder()
        }
        if self.phoneTextField.isFirstResponder() {
          self.phoneTextField.resignFirstResponder()
        }
        if self.emailTextField.isFirstResponder() {
          self.emailTextField.resignFirstResponder()
        }
        if self.websiteTextField.isFirstResponder() {
          self.websiteTextField.resignFirstResponder()
        }
      }
      if touch.view === self.cardImageView {
        addPhotoPressed()
      }
    }
    super.touchesBegan(touches, withEvent: event)
    
  }
  
  // MARK: - Helper methods
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
  
  private func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
    // Initialize an image picker controller for a given source type
    let imagePickerController = UIImagePickerController()
    imagePickerController.navigationBar.tintColor = UIColor.whiteColor()
    imagePickerController.sourceType = sourceType
    imagePickerController.editing = true
    imagePickerController.delegate = self
    // Present the view controller
    self.presentViewController(imagePickerController, animated: true, completion: nil)
  }
  
  private func addPhotoPressed() {
    // If running in a simulator, show the photo library
    if UIDevice.currentDevice().model == "iPhone Simulator" {
      showImagePickerController(.PhotoLibrary)
    } else {
      // Otherwise, give the user a choice via an action sheet
      let actionSheet = UIAlertController(
        title: nil,
        message: nil,
        preferredStyle: .ActionSheet)
      actionSheet.addAction(UIAlertAction(
        title: "Camera",
        style: .Default,
        handler: {_ in
          self.showImagePickerController(.Camera)
      }))
      actionSheet.addAction(UIAlertAction(
        title: "Photo Library",
        style: .Default,
        handler: {_ in
          self.showImagePickerController(.PhotoLibrary)
      }))
      actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
      self.presentViewController(actionSheet, animated: true, completion: nil)
    }
  }
}