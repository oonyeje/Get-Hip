//
//  FriendRequestViewController.swift
//  GetHip
//
//  Created by Okechi on 1/29/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit

class FriendRequestViewController: UIViewController {
    
    @IBOutlet var displayImage: UIImageView!
    @IBOutlet var foundName: UILabel!
    @IBOutlet var sendRequest: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayImage.layer.cornerRadius = self.displayImage.frame.size.width/2
        self.sendRequest.enabled = false
        self.sendRequest.tintColor = UIColor.grayColor()
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
