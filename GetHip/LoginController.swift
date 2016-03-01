//
//  LoginController.swift
//  GetHip
//
//  Created by Okechi on 2/12/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class LoginController: UIViewController, PFLogInViewControllerDelegate, UITextFieldDelegate {
    @IBOutlet var userEmailField: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signIn: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var forgotPassBtn: UIButton!
    

    
    @IBAction func loginBtnPressed(sender: UIButton){
        //check if user logging in with email
        if(contains(self.userEmailField.text!, "@")){
            let predicate: NSPredicate = NSPredicate(format: "(email = %@)", argumentArray: [self.userEmailField.text!])
            var userQuery: PFQuery = PFQuery(className: "_User", predicate: predicate)
            
            //log in user through email look up in db
            dispatch_async(dispatch_get_main_queue(), {
                userQuery.getFirstObjectInBackgroundWithBlock({
                    (object, error) -> Void in
                    
                    if(object != nil && error == nil){
                        PFUser.logInWithUsernameInBackground(object!.objectForKey("username") as! String, password: self.password.text!, block: {
                            (user, error) -> Void in
                            
                            if(user != nil){
                                self.performSegueWithIdentifier("LoginToHomeSegue", sender: self)
                            }else{
                                var alert = UIAlertController(title: "Invalid Login", message: "Your username/email or password is incorrect!", preferredStyle: .Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)}))
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        })                    }
                })
            })
        }else{
            PFUser.logInWithUsernameInBackground(userEmailField.text!, password: password.text!, block: {
                (user, error) -> Void in
                
                if(user != nil){
                    self.performSegueWithIdentifier("LoginToHomeSegue", sender: self)
                }else{
                    var alert = UIAlertController(title: "Invalid Login", message: "Your username/email or password is incorrect!", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)}))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    @IBAction func signUpBtnPressed(sender: UIButton){
        self.performSegueWithIdentifier("signUpSegue", sender: self)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //check if user already signed in
        /*if(PFUser.currentUser() != nil){
            
            presentLoggedInAlert()
            
        }*/
        
        self.userEmailField.delegate = self
        self.password.delegate = self
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
        self.performSegueWithIdentifier("LoginToHomeSegue", sender: self)
        
    }
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "LoginToHomeSegue" {
            
        }
    }
    
  */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
