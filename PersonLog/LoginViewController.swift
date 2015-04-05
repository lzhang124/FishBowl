//
//  LoginViewController.swift
//  FishBowl
//
//  Created by Larry Zhang on 4/5/15.
//  Copyright (c) 2015 com.fishbowl. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var loginView: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.readPermissions = ["public_profile", "user_friends", "user_photos"]
        loginView.delegate = self
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error) != nil {
            println(error)
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            self.returnUserData()
            println("logged in")
            
            let appDelegateTemp:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegateTemp.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? UIViewController
        }
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(nil, forKey: "f_name")
        defaults.setValue(nil, forKey: "l_name")
        defaults.setValue(nil, forKey: "phone")
        defaults.setValue(nil, forKey: "photo_url")
        defaults.setValue(nil, forKey: "fb_id")
    }

    func returnUserData() {
       let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
       graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if error == nil {
                let userID = result.valueForKey("id") as NSString
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue(result.valueForKey("first_name") as NSString, forKey: "f_name")
                defaults.setValue(result.valueForKey("last_name") as NSString, forKey: "l_name")
                defaults.setValue("000-000-0000", forKey: "phone")
                defaults.setValue("https://graph.facebook.com/\(userID)/picture?type=large", forKey: "photo_url")
                defaults.setValue(userID, forKey: "fb_id")
                println("set defaults")
            } else {
                println("Error: \(error)")
            }
        })
    }
}