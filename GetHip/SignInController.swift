//
//  SignInController.swift
//  GetHip
//
//  Created by Okechi on 2/14/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class SignInController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    @IBOutlet var nameField: UITextField!
    //@IBOutlet var userField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passField: UITextField!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var chngPhotoBtn: UIButton!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var scrollView:UIScrollView!
    private var picker = UIImagePickerController()

    
    @IBAction func saveNewProfile(sender: UIButton){
        if(self.nameField.hasText() == false
            /*|| self.userField.hasText() == false*/
            || self.emailField.hasText() == false
            || self.passField.hasText() == false
            || self.profilePic.image == nil){
                
                
                //for ios 7 and lower compatibility
                
                if objc_getClass("UIAlertController") != nil {
                    let alert = UIAlertController(title: "Invalid Registration", message: "We're missing some information from you, before we can start the party!", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)}))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                    
                }else{
                    let alert = UIAlertView()
                    alert.title = "Invalid Registration"
                    alert.message = "We're missing some information from you, before we can start the party!"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }
                
        }else{
            if /*(!(contains(self.userField.text!, "@") ||*/ !contains(self.nameField.text!, "@"){
            
                let predicate: NSPredicate = NSPredicate(format: "(email = %@)", argumentArray: [self.emailField.text!])
                var userQuery: PFQuery = PFQuery(className: "_User", predicate: predicate)
                
                dispatch_async(dispatch_get_main_queue(), {
                    userQuery.getFirstObjectInBackgroundWithBlock({
                        (object, error) -> Void in
                        
                        if(object != nil && error == nil){
                            
                            //for ios 7 and lower compatibility
                            
                            if objc_getClass("UIAlertController") != nil {
                                let alert = UIAlertController(title: "User Info Taken", message: "Sorry this information is already registered to another user. Please try again.", preferredStyle: .Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)}))
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                
                            }else{
                                let alert = UIAlertView()
                                alert.title = "User Info Taken"
                                alert.message = "Sorry this information is already registered to another user. Please try again."
                                alert.addButtonWithTitle("OK")
                                alert.show()
                            }
                            
                        }else{
                            var user = PFUser()
                            var img:PFFile = PFFile(data: UIImageJPEGRepresentation(self.profilePic.image, 1.0))!
                            user.username = self.emailField.text!
                            user.password = self.passField.text!
                            user.email = self.emailField.text!
                            user.setObject(self.nameField.text!, forKey: "displayName")
                            user.setObject(img, forKey: "profilePicture")
                            
                            //sign up new user
                            user.signUpInBackgroundWithBlock({
                                (succeeded: Bool, error: NSError?) -> Void in
                                
                                if error == nil {
                                    //self.performSegueWithIdentifier("SignedUpSegue", sender: self)
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabControlVC") as! UITabBarController
                                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                    appDelegate.window?.rootViewController = tabBarController
                                }
                                else{
                                    
                                }
                            })
                            
                        }
                    })
                })

            
            }else{
                //for ios 7 and lower compatibility
                
                if objc_getClass("UIAlertController") != nil {
                    let alert = UIAlertController(title: "Illegal Characters", message: "The display name you entered contains illegal characters such as: '@'", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)}))
                    
                    self.presentViewController(alert, animated: true, completion: nil)

                    
                }else{
                    let alert = UIAlertView()
                    alert.title = "Illegal Characters"
                    alert.message = "The display name you entered contains illegal characters such as: '@'"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }
            }
            
        }
        
    }
    
    @IBAction func cancelSignUp(){
        self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func chngePhoto(sender: UIButton){
        let captureMenu = UIAlertController(title: nil, message:nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        let cameraAction = UIAlertAction(title: "Take a New Pic", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.picker.cameraCaptureMode = .Photo
            self.presentViewController(self.picker, animated: true, completion: nil)
            
        })
        
        let galleryAction = UIAlertAction(title: "Select a Profile Pic", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = .PhotoLibrary
            self.presentViewController(self.picker, animated: true, completion: nil)
        })
        
        captureMenu.addAction(galleryAction)
        captureMenu.addAction(cameraAction)
        captureMenu.addAction(cancelAction)
        self.presentViewController(captureMenu, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //dismisses keyboard when screen is tapped
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
        
        self.nameField.delegate = self
        self.passField.delegate = self
        //self.userField.delegate = self
        self.emailField.delegate = self
        
        
        self.navigationController?.title = "Create An Account"
        self.chngPhotoBtn.layer.borderWidth = 1
        self.chngPhotoBtn.layer.cornerRadius = 5
        self.chngPhotoBtn.layer.borderColor = UIColor.blackColor().CGColor
        self.picker.delegate = self
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        self.profilePic.clipsToBounds = true
        self.profilePic.backgroundColor = UIColor.grayColor()
        
        //add cancel bar to navigation bar
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationItem.leftBarButtonItem?.title = "Cancel"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 200), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignInController: UIImagePickerControllerDelegate{
    //MARK: -Image Picker Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.profilePic.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

