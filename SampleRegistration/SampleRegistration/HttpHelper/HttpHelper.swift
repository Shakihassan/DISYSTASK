//
//  HttpHelper.swift
//  SampleRegistration
//
//  Created by hassan on 28/07/19.
//  Copyright © 2019 hassan. All rights reserved.
//

import UIKit

class HttpHelper: NSObject {
    
    public override init () {}
    
    public static func postAPICallHandleJson(anyDict:NSDictionary, urlString:String, completionHandler:@escaping ( Response?) -> Void)
    {
        let currentResponse = Response()
        
        if Network.reachability?.isReachable == false {
            currentResponse.status = ResponseStatus.Failure
            let errorString = "NoInternetConnectivity"
            currentResponse.SRResponseString = errorString
            completionHandler(currentResponse)
            
        }else
        {
            let url = URL(string: urlString)
            var request = URLRequest(url: url!)
            
           let httpBody = try? JSONSerialization.data(withJSONObject: anyDict, options: [])
            request.httpMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(" mobile_dev", forHTTPHeaderField: "consumer-key")
            request.addValue("20891a1b4504ddc33d42501f9c8d2215fbe85008", forHTTPHeaderField: "consumer-secret ")
            request.httpBody = httpBody

            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error == nil
                {
                    currentResponse.status = ResponseStatus.Success
                    let returnData = String(data: data!, encoding: .utf8)
                    let dictionary = ["jsonString":returnData]
                    print(returnData as Any)
                    do {
                        let response = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                        print(response)
                        currentResponse.returnDictionaryValues = response as [String : Any]
                        completionHandler(currentResponse)
                        
                    }catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                        currentResponse.returnDictionaryValues = dictionary as Any as! [String : Any]
                        completionHandler(currentResponse)
                        
                    }
                    
                }else
                {
                    currentResponse.status = ResponseStatus.Failure
                    let errorString = error?.localizedDescription
                    currentResponse.SRResponseString = errorString!
                    completionHandler(currentResponse)
                }
                }.resume()
        }
        
    }
    
    
    // Get API Call
    public static func handleGetAPICall(urlString:String, completionHandler:@escaping (Response?) -> Void)
    {
        
        let apiResponse = Response()
        
        if Network.reachability?.isReachable == false {
            apiResponse.status = ResponseStatus.Failure
            let errorString = "NoInternetConnectivity"
            apiResponse.SRResponseString = errorString
            completionHandler(apiResponse)
            
        }else
        {
            
            let url = URL(string: urlString)
 
             var request = URLRequest(url: url!)
            request.addValue(" mobile_dev", forHTTPHeaderField: "consumer-key")
            request.addValue("20891a1b4504ddc33d42501f9c8d2215fbe85008", forHTTPHeaderField: "consumer-secret ")
            request.httpMethod = "GET"
             let session = URLSession.shared

            session.dataTask(with: request){ (data, response, error) in

                if error == nil
                {
                    apiResponse.status = ResponseStatus.Success

                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])

                    print(json as Any)

                    do {
                        let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        if let responsedictionary = object as? [String: AnyObject] {
                            apiResponse.returnDictionaryValues = responsedictionary
                            print(responsedictionary)
                        }
                        else
                        {
                            let jsonArray = try? JSONSerialization.jsonObject(with: data!, options: [])

                            apiResponse.returnArrayValues = jsonArray as! NSArray

                            print(apiResponse.returnArrayValues)
                        }

                    } catch {

                    }
                    completionHandler(apiResponse)

                }else
                {
                    apiResponse.status = ResponseStatus.Failure
                    let errorString = error?.localizedDescription
                    apiResponse.SRResponseString = errorString!
                    completionHandler(apiResponse)
                }

            }.resume()
            
//            let session = URLSession.shared
//            session.dataTask(with: url!) { (data, response, error) in
//                if error == nil
//                {
//                    apiResponse.status = ResponseStatus.Success
//
//                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
//
//                    print(json as Any)
//
//                    do {
//                        let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                        if let responsedictionary = object as? [String: AnyObject] {
//                            apiResponse.returnDictionaryValues = responsedictionary
//                            print(responsedictionary)
//                        }
//                        else
//                        {
//                            let jsonArray = try? JSONSerialization.jsonObject(with: data!, options: [])
//
//                            apiResponse.returnArrayValues = jsonArray as! NSArray
//
//                            print(apiResponse.returnArrayValues)
//                        }
//
//                    } catch {
//
//                    }
//                    completionHandler(apiResponse)
//
//                }else
//                {
//                    apiResponse.status = ResponseStatus.Failure
//                    let errorString = error?.localizedDescription
//                    apiResponse.SRResponseString = errorString!
//                    completionHandler(apiResponse)
//                }
//
//                }.resume()
        }
    }
    

}
