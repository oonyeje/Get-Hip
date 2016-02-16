//
//  LoginViewController.swift
//  GetHip
//
//  Created by Okechi on 1/2/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

//DEPRECATED WILL DELETE WHEN PROJECT COMPLETED
import UIKit

class LoginViewController: PFLogInViewController{
    var backgroundImage: UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signUpController = SignUpViewController()
        //set custom logo background image
        backgroundImage = UIImageView(image: UIImage(named: "1x"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.logInView!.insertSubview(backgroundImage, atIndex: 0)
        //customize common buttons in login
        customizeButtons(logInView?.logInButton!)
        
        //customize login button
        logInView!.logInButton?.setTitle("Sign In", forState: .Normal)
        
        //var loginFrame: CGRect = logInView!.logInButton!.frame
        //loginFrame.origin.x = loginFrame.origin.x
        //loginFrame.origin.y = loginFrame.origin.y
        //loginFrame.size.width = loginFrame.size.width - 100
        //loginFrame.size.height = loginFrame.size.height
        //logInView!.logInButton!.frame = loginFrame
        
        //customize password forget button
        logInView!.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
    }
    
    func customizeButtons(button: UIButton!){
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //stretch background image to fill screen
        backgroundImage.frame = CGRectMake(0, 0, self.logInView!.frame.width, self.logInView!.frame.height)
    }
}
