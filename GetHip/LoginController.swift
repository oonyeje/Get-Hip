//
//  LoginController.swift
//  GetHip
//
//  Created by Okechi on 2/12/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class LoginController: UIViewController, PFLogInViewControllerDelegate {
    @IBOutlet var userEmailField: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signIn: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var forgotPassBtn: UIButton!
    

    
    @IBAction func loginBtnPressed(sender: UIButton){
        //check if user logging in with email, implement later
        
        PFUser.logInWithUsernameInBackground(userEmailField.text!, password: password.text!, block: {
            (user, error) -> Void in
            
            if(user != nil){
                self.performSegueWithIdentifier("LoginToHomeSegue", sender: self)
            }else{
                var alert = UIAlertController(title: "Invalid Login", message: "Your friend request was sent successfully!", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)}))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        
    }
    
    @IBAction func signUpBtnPressed(sender: UIButton){
        self.performSegueWithIdentifier("signUpSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //check if user already signed in
        if(PFUser.currentUser() != nil){
            
            presentLoggedInAlert()
        
        }
        
        self.signIn.layer.borderWidth = 1
        self.signIn.layer.cornerRadius = 5
        self.signIn.layer.borderColor = UIColor.whiteColor().CGColor
        //self.navigationController?.navigationBarHidden = true
            
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentLoggedInAlert() {
        var story = UIStoryboard(name: "Main", bundle: nil)
        var homeVC: HomeScreenViewController = story.instantiateViewControllerWithIdentifier("HomeVC") as! HomeScreenViewController!
        
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
