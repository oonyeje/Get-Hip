//
//  SignUpViewController.swift
//  GetHip
//
//  Created by Okechi on 1/3/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

//DEPRECATED WILL DELETE WHEN PROJECT COMPLETED
import UIKit

class SignUpViewController: PFSignUpViewController{
    var backgroundImage: UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set custom logo background image
        backgroundImage = UIImageView(image: UIImage(named: "1x"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        signUpView!.insertSubview(backgroundImage, atIndex: 0)
        //self.signUpController?.signUpView!.insertSubview(backgroundImage, atIndex: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //stretch background image to fill screen
        backgroundImage.frame = CGRectMake(0, 0, signUpView!.frame.width, signUpView!.frame.height)
    }
}