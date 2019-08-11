//
//  ConnectionManager.swift
//  sureEcosystem Inspect
//
//  Created by admin on 04/06/18.
//

import UIKit
import MobileCoreServices

class ConnectionManager: NSObject {
    
    
    class func callPostMethodWith(url: String, completionHandler : @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error? )->Void){
        
        let finalUrlString = url
        
        let finalUrl = URL(string: finalUrlString)!
        
        let encodedConsumerKeyString:String = "Sh4JYw4aQ773emLJTL9zlFFF2".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        
        let encodedConsumerSecretKeyString:String = "KYZk6x2O0HO8e1ClUyqDDMjXOnYJhjwHBXrY4PJ6M7OFBxkE7z".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        
        let combinedString = encodedConsumerKeyString+":"+encodedConsumerSecretKeyString
        print(combinedString)
        //Base64 encoding
        
        let data = combinedString.data(using: .utf8)
        let encodingString = "Basic "+(data?.base64EncodedString())!
        print(encodingString)
   
        //Create URL request
        var request = URLRequest(url: URL(string: "https://api.twitter.com/oauth2/token")!)
        request.httpMethod = "POST"
        request.setValue(encodingString, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let bodyData = "grant_type=client_credentials".data(using: .utf8)!
        request.setValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data, error == nil else { // check for fundamental networking error
            print("error=\(String(describing: error))")
            return
            }

            completionHandler(data,response,error)
        }
        
        task.resume()
    }
    
    
    
    class func callGetMethodWith(url: String, appenDict : NSDictionary, completionHandler : @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error? )->Void){
       
        var appendString = ""
        
        if appendString == GET_FOLLOWERS_LIST{
            appendString = self.getLoginParams(dict: appenDict)
        }else{
            appendString = self.getUserDetailsParams(dict: appenDict)
        }
      
        let finalUrlString = BASE_URL + url
        
        let urlAppended = finalUrlString + "?" + appendString
        
        let url = URL(string: urlAppended)
        
        let authToken : String? = appenDict.value(forKey: "secretKey") as! String
        
        var finalAuthToken : String?
        
        if authToken != nil {
            finalAuthToken = "Bearer " + authToken!
        }
        
        let sessionConfig = URLSessionConfiguration.default
        // Session Configuration
        let sessionUrl = URLSession(configuration: sessionConfig)
        // Load configuration into Session
        let urlNew = URL(string: urlAppended)!
       
        var urlRequest = URLRequest(url : url!)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(finalAuthToken, forHTTPHeaderField: "Authorization")
        
        let task = sessionUrl.dataTask(with: urlRequest, completionHandler: { data, response, error in
           
            completionHandler(data,response,error)

        })
     
        task.resume()
    }
   
    class func getLoginParams(dict: NSDictionary) ->String {
        
        let cursor : String = dict.object(forKey: "cursor") as! String
        let screenName : String = dict.object(forKey: "screen_name") as! String
        let skipStatus : String = dict.object(forKey: "skip_status") as! String
        let includeUserEntities : String = dict.object(forKey: "include_user_entities") as! String
        
        
        let stringToSend = "cursor" + "=" + cursor + "&" +
            "screen_name" + "=" + screenName + "&" +
            "skip_status" + "=" + skipStatus + "&" +
                "include_user_entities" + "=" + includeUserEntities
        
        return stringToSend
    }
    
    class func getUserDetailsParams(dict: NSDictionary) ->String {
        
          let screenName : String = dict.object(forKey: "screen_name") as! String
        
        let stringToSend = "screen_name" + "=" + screenName
        
        return stringToSend
    }
    
    
    class func getDocumentParams(dict: NSDictionary) ->String {
        
        let inspectionQueId: String  = (dict.object(forKey: "inspectionQueId") as! String)
        let completed_on: String  = (dict.object(forKey: "completed_on") as! String)
        
        let stringToSend = "?inspectionQueId" + "=" + inspectionQueId + "&" +
            "completed_on" + "=" + completed_on
        
        
        return stringToSend
    }
    
  
}



