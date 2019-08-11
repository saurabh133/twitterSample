//
//  Utilities.swift
//  TwitterAssignment
//
//  Created by Saurabh Madne on 10/08/19.
//  Copyright © 2019 Saurabh Mjecadne. All rights reserved.
//

import UIKit
import CoreData

class Utilities: NSObject {

    func isDeviceIpad() -> Bool {
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            return true
        }
        else{
            return false
        }
    }
    
    class func startActivityIndicator(activity:UIActivityIndicatorView){
        
        DispatchQueue.main.async {
            activity.startAnimating()
            activity.isHidden = false
        }
    }
    
    class func stopActivityIndicator(activity:UIActivityIndicatorView){
        
        DispatchQueue.main.async {
            activity.stopAnimating()
            activity.isHidden = true
        }
    }
    
    class func saveDefaultContext(){
        let context : NSManagedObjectContext = NSManagedObjectContext.mr_default()
        context.mr_saveToPersistentStoreAndWait()
    }
}
