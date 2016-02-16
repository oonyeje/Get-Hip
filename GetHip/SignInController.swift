//
//  SignInController.swift
//  GetHip
//
//  Created by Okechi on 2/14/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class SignInController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var userField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passField: UITextField!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var chngPhotoBtn: UIButton!
    @IBOutlet var profilePic: UIImageView!
    private var picker = UIImagePickerController()

    
    @IBAction func saveNewProfile(sender: UIButton){
        var user = PFUser()
        var img:PFFile = PFFile(data: UIImagePNGRepresentation(self.profilePic.image))!
        user.username = userField.text!
        user.password = passField.text!
        user.email = emailField.text!
        user.setObject(nameField.text!, forKey: "displayName")
        user.setObject(img, forKey: "profilePicture")
        
        //sign up new user
        user.signUpInBackgroundWithBlock({
            (succeeded: Bool, error: NSError?) -> Void in
            
            if error == nil {
                self.performSegueWithIdentifier("SignedUpSegue", sender: self)
            }
            else{
                
            }
        })
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
        self.navigationController?.title = "Create An Account"
        self.chngPhotoBtn.layer.borderWidth = 1
        self.chngPhotoBtn.layer.cornerRadius = 5
        self.chngPhotoBtn.layer.borderColor = UIColor.blackColor().CGColor
        self.picker.delegate = self
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
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
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

