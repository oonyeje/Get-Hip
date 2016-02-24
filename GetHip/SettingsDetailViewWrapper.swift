//
//  SettingsDetailViewWrapper.swift
//  GetHip
//
//  Created by Okechi on 1/22/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class DisplayDetailViewController: UIViewController {
    var possibleName: String!
    
    @IBOutlet weak var textfield: UITextField?
    
    @IBOutlet weak var ChnDspName: UIButton!
    
    
    @IBAction func DspBtnConfrim(sender: UIButton) {
        
        self.possibleName = self.textfield?.text
        
        //sanitize and alert for input and success later
        
        var query = PFUser.query()
        var currentUser = PFUser.currentUser()
        
        query!.whereKey("username", equalTo: (currentUser?.username as String!))
        
        query!.getFirstObjectInBackgroundWithBlock {
            (object, error) -> Void in
            
            if error != nil || object == nil {
                println("Object request failed")
            }
            else if let object = object{
                object.setObject(self.possibleName, forKey: "displayName")
                object.saveInBackground()
                //NSNotificationCenter.defaultCenter().postNotificationName("savingName", object: nil)
            }
        }
        
        println(self.possibleName)
    }
    
    var displayName: String!
    
    func setData(display: String){
        self.displayName = display
    }
    
    func refreshView(notification: NSNotification){

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textfield?.placeholder = self.displayName
        
        self.ChnDspName.layer.borderWidth = 1
        self.ChnDspName.layer.cornerRadius = 5
        self.ChnDspName.layer.borderColor = UIColor.blackColor().CGColor
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshView:", name: "savingName", object: nil)
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

class EmailDetailViewController: UIViewController {
    var possibleEmail: String!
    
    @IBOutlet weak var textfield: UITextField?
    
    @IBOutlet weak var ChnEmailBtn: UIButton!
    
    @IBAction func ChnEmailComfirm(sender: UIButton) {
        
        self.possibleEmail = self.textfield?.text
        //sanitize and alert for input and success later
        
        var query = PFUser.query()
        var currentUser = PFUser.currentUser()
        
        query!.whereKey("username", equalTo: (currentUser?.username as String!))
        
        query!.getFirstObjectInBackgroundWithBlock {
            (object, error) -> Void in
            
            if error != nil || object == nil {
                println("Object request failed")
            }
            else if let object = object{
                object.setObject(self.possibleEmail, forKey: "email")
                object.saveInBackground()
                NSNotificationCenter.defaultCenter().postNotificationName("savingEmail", object: nil)
            }
        }

        println(self.possibleEmail)
    }
    
    
    var email: String!
    
    func setData(email: String){
        self.email = email
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textfield?.placeholder = self.email
        
        self.ChnEmailBtn.layer.borderWidth = 1
        self.ChnEmailBtn.layer.cornerRadius = 5
        self.ChnEmailBtn.layer.borderColor = UIColor.blackColor().CGColor
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshView:", name: "savingEmail", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshView(notification: NSNotification){
        
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

class ProfileDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var profileImg: UIImageView!
    private var picker = UIImagePickerController()
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var ChngPhtoBtn: UIButton!
    
    
    
    @IBAction func changePhoto(sender: UIButton) {
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
    
    
    func setData(proImage:UIImageView){
        self.profileImg = proImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.profileImg == nil{
            self.img!.backgroundColor = UIColor.grayColor()
        }
        else{
            self.img.image = self.profileImg.image!
        }
        self.img.layer.cornerRadius = self.img!.frame.size.width/2
        self.img.clipsToBounds = true
        
        self.ChngPhtoBtn!.layer.borderWidth = 1
        self.ChngPhtoBtn!.layer.cornerRadius = 5
        self.ChngPhtoBtn!.layer.borderColor = UIColor.blackColor().CGColor
        self.picker.delegate = self
        
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

extension ProfileDetailViewController: UIImagePickerControllerDelegate{
    //MARK: -Image Picker Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
