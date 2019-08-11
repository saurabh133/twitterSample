//
//  LoginViewController.swift
//  TwitterAssignment
//
//  Created by Saurabh Madne on 06/08/19.
//  Copyright © 2019 Saurabh Mjecadne. All rights reserved.
//

import UIKit
import TwitterKit
import TwitterCore

class LoginViewController: UIViewController {

    var name:String?
    var userID:String?
    var authrizationToken:String?
    var screenName:String?
    var secretKey:String?
    var accessToken:String?
    var userEmail:String?
    var userDetailsDict:NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        self.accessToken =  DEFAULT_ACCESS_TOKEN
        self.getAccessToken()
    }
 
    @IBAction func didSelectTwitterLogin(_ sender: Any) {
      
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if (session != nil) {
                self.screenName = session?.userName
                self.name = session?.userName ?? ""
                self.userID = session?.userID ?? ""
                self.authrizationToken = session?.authToken
                self.secretKey = session?.authTokenSecret
             
                self.getUserDetails()
                
                let client = TWTRAPIClient.withCurrentUser()
    
                client.requestEmail { email, error in
                    if (email != nil) {
                        print("signed in as \(String(describing: session?.userName))");
                    
                        self.userEmail = email ?? ""
                        
                    }else {
                        print("error: \(String(describing: error?.localizedDescription))");
                    }
                }
            }else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        }
        
    }
    
    func getAccessToken() {
        
        ConnectionManager.callPostMethodWith(url: GET_ACCESS_TOKEN) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    {
                        if  (json["access_token"] != nil)
                        {
                            self.accessToken = (json["access_token"] as! String)
                        }
                        
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
            
        }
   
    }
    
    func getUserDetails()
    {
        Utilities.startActivityIndicator(activity: self.activityIndicator)
        
        userDetailsDict.setValue(self.name, forKey: "screen_name")
        userDetailsDict.setValue(self.accessToken, forKey: "secretKey")
        
        ConnectionManager.callGetMethodWith(url: GET_USER_DETALIS_LIST, appenDict: userDetailsDict) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    {
                          DispatchQueue.main.async {
                            UserDetails.loadUserData(responseData: json)
                            Utilities.stopActivityIndicator(activity: self.activityIndicator)
                        }
                    
                      
                        self.movetoUserdetails()
                   
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        }

    }
    
   func movetoUserdetails()
   {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        controller.accessToken = self.accessToken
        controller.screenName = self.screenName
        controller.userEmail = self.userEmail
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
        }
   
    }

}
