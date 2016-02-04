//
//  ViewController.swift
//  GetHip
//
//  Created by Okechi on 1/1/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate{
    var autoSignin: Bool! = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if (PFUser.currentUser() == nil){
            let loginViewController = LoginViewController()
            loginViewController.delegate = self
            loginViewController.fields = .UsernameAndPassword | .LogInButton | .PasswordForgotten | .SignUpButton //add fb button later, need to figure out error
            
            //loginViewController.signUpController?.delegate = self 
            //*no longer needed since I am assigning custom signupController that inherits the signupController
            
            //hides parse logo
            loginViewController.logInView?.logo?.hidden = true
            loginViewController.signUpController?.signUpView?.logo?.hidden = true
            
            self.presentViewController(loginViewController, animated: false, completion: nil)
        }
        else{
            
                presentLoggedInAlert()
            
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        presentLoggedInAlert()
        self.autoSignin = false
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        presentLoggedInAlert()
    }
    
    func presentLoggedInAlert() {
        
        
        self.performSegueWithIdentifier("HomeScreenSegue", sender: nil)
        
    }
    
    
    
}

