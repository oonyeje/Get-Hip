//
//  ForgotPassViewController.swift
//  GetHip
//
//  Created by Okechi on 3/29/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class ForgotPassViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resestPass: UIButton!
    
    @IBAction func dismiss(sender:UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func sendResetRequest(sender: UIButton){
        PFUser.requestPasswordResetForEmailInBackground(self.emailField.text!) {
            (succeeded, error) -> Void in
            
            if (error == nil){
                let alert = UIAlertController(title: "Success", message: "Check your email to start the password reset cycle.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)}))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                let errorMessage = error!.userInfo!["error"] as! NSString
                let alert = UIAlertController(title: "Failure", message:( errorMessage as? String)!, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{(action: UIAlertAction!) in alert.dismissViewControllerAnimated(true, completion: nil)}))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //dismisses keyboard when screen is tapped
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
        
        self.emailField.delegate = self
        
        // Do any additional setup after loading the view.
        self.resestPass!.layer.borderWidth = 1
        self.resestPass!.layer.cornerRadius = 5
        self.resestPass!.layer.borderColor = UIColor.blackColor().CGColor
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
