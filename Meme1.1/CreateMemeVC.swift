//
//  ViewController.swift
//  Meme1.1
//
//  Created by mitch on 2/13/19.
//  Copyright © 2019 mitch. All rights reserved.
//

import UIKit
import Foundation


class CreateMemeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    
    
    // Outlets textfields, UIimageview and Navi bar buttons
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navgiBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    // UIImage placeholder
    let imagePicker = UIImagePickerController()
    
    /*
     func: viewWillAppear / preferredStatusBarStyle
     Input: Bool
     Output: none
     Note: set up KeyBoard notification, change battery icon and time to white
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        subscribeToKeyboardNotifications()
    }
    // MARK: UIStatusBarStyle to lightcolor
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    /*
     func: configureTextField
     input: UITextfield,FontAttributes, string
     output: none
     Note:
     - set front attributes
     - set default text for textfields
    */
    func configureTextField(textfield: UITextField,attributes:[NSAttributedString.Key: Any],withText:String){
        textfield.text = withText
        textfield.defaultTextAttributes = attributes
        textfield.textAlignment = NSTextAlignment.center;
        textfield.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    }
    
    /*
     func: viewDidLoad
     input: none
     output: none
     notes:
     -Check if camera exist on device
     -Create delegates for UIImage, textfields, and shareButton within navi controller
     -font for textfields
     -set attributes for textfields
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: camera exist
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // MARK: delegates
        imagePicker.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        shareButton.isEnabled = false
        // MARK: textfield fonts
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4
        ]
        // MARK: textfield attributes
        configureTextField(textfield: topTextField, attributes: memeTextAttributes, withText: "TOP")
        configureTextField(textfield: bottomTextField, attributes: memeTextAttributes, withText: "BOTTOM")
    }
    
    
    /*
     func: viewWillDisappear
     input: bool
     output: none
     notes:
     - unsubscribe from keyboard notification
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    /*
     func: subscribeToKeyboardNotifications / unsubscribeFromKeyboardNotifications
     input: none
     output: none
     notes:
     -manages keyboard notification
     -moves view up allowing space for the keyboard
     */
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    /*
     func: keyboardWillHide / keyboardWillShow
     input: notification
     output: none
     notes:
     -view is place back to default position when the keyboard is dismissed
     -checks what textfield is selected (only for the bottom textfield)
     -move view to notification height (height of keyboard)
     */
    
    // MARK: default view without keyboard
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    // MARK: moved view with keyboard
    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomTextField.isEditing) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // MARK: get height of keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    /// Erase the default text when editing
    ///
    /// - Parameter textField: User selects a textfield the default text will be gone
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField && textField.text == "TOP" {
            textField.text = ""
            
        } else if textField == bottomTextField && textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    
    /// return will dismiss keyboard
    ///
    /// - Parameter textField: textfield to end the edit
    /// - Returns: bool
    /// -When return is pressed keyboard will dismiss
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    

    /// User can pick between camera or photolibrary
    ///
    /// - Parameter _sender: AlbumButton,cameraButton
    /// - identifies what button is pressed by tag (1 = AlbumButton, 2 = cameraButton)
    /// - choosen picture is assigened to imagePicker (global UIImagePickerController)
    /// - Taken picture is assigened to imagePicker
    @IBAction func pickAImage(_sender: Any) {
        let button = _sender as! UIBarButtonItem
        let tag = button.tag
        imagePicker.allowsEditing = false
        if tag == 1 {
            // MARK: pick image from library
            imagePicker.sourceType = .photoLibrary
        }else{
            // MARK: use camera for picture
            imagePicker.sourceType = .camera;
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    /// Sets the UIImage
    ///
    /// - Parameters:
    ///   - picker: sets a image to a UIImagePickerController
    ///   - info: UIImage
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // MARK: PickImage
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            shareButton.isEnabled = true //enable the share button
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    /// resets the view to default (when the app first loads)
    func reloadView(){
        // MARK: Reset view
        imageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.isEnabled = false
    }
    

    /// connected to the cancel button within the navi controller
    ///
    /// - Parameter sender: Cancel button
    /// - Uses ReloadView to clear out the image and text
    
    @IBAction func cancelButton(_ sender: Any) {
        self.reloadView()
    }
    

    /// Sharing/saving of meme through a navigational controller
    ///
    /// - Parameter sender: Called when share button is pressed
    /// - Uses generateMemedImage function to create a UIImage (meme image)
    
    @IBAction func shareButton(_ sender: Any) {
        // MARK: Share/Save Meme
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = self.view
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if (completed) {
                self.save() // save the scene
                self.reloadView() // reset view after saving/sharing the meme
            }
        }
        present(controller,animated:true,completion:nil)
    }
    


    /// Handles the VC's if the user cancels on picking a image
    ///
    /// - Parameter picker: UIImagePickController Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
 
    /// Hides or shows the navigational and tool bar
    ///
    /// - Parameter isHidden: controls hiding (true) or show (false) the navigational and tool bar
    func configureBars(_ isHidden: Bool){
        self.navgiBar.isHidden = isHidden
        self.toolbar.isHidden = isHidden
    }
    

    /// takes a screenshot of the screen
    ///
    /// - Returns: memedImage:UIImage (image with text)
    func generateMemedImage() -> UIImage {
        
        configureBars(true) //tool,navi bar are hidden during the render of meme
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        configureBars(false)
        
        return memedImage
    }
    

    /// save the meme
    ///
    /// - Returns: None
    func save() {
        let MemeImage = generateMemedImage()
        // create meme struct
        let meme = memeConstruct(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage:  imageView.image!, memedImage: MemeImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        print (appDelegate.memes.count)
        print ("STUFF")
        appDelegate.memes.append(meme)
        
        
    }
    
}
