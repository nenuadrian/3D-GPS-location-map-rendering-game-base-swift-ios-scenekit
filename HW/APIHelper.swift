//
//  APIHelper.swift
//  HW
//
//  Created by Adrian Nenu on 02/01/2021.
//  Copyright © 2021 Adrian Nenu. All rights reserved.
//

import Foundation

import UIKit

class APIHelper {
    private static func dataTask(path: String, params: Dictionary<String, AnyObject>? = nil, method: String, completion: @escaping (_: Bool, _: JSON?) -> Void) {
        
        let request = requestForPathWithParams(path: path)
        
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSON(data: data)
                    let response = response as? HTTPURLResponse
                    if 200...299 ~= response!.statusCode {
                        completion(true, json)
                    } else {
                        completion(false, json)
                    }
                } catch {
                    completion(false, nil)
                }
            } else {
                completion(false, nil)
            }
        }).resume()
    }
    
    static func post(path: String, params: Dictionary<String, AnyObject>? = nil, completion: @escaping (_: Bool, _: JSON?) -> Void) {
        dataTask(path: path, params: params, method: "POST", completion: completion)
    }
    
    static func put(path: String, params: Dictionary<String, AnyObject>? = nil, completion: @escaping (_: Bool, _: JSON?) -> Void) {
        dataTask(path: path, params: params, method: "PUT", completion: completion)
    }
    
    static func get(path: String, params: Dictionary<String, AnyObject>? = nil, completion: @escaping (_: Bool, _: JSON?) -> Void) {
        dataTask(path: path, params: params, method: "GET", completion: completion)
    }
    
    private static func delete(path: String, params: Dictionary<String, AnyObject>? = nil, completion: @escaping (_: Bool, _: JSON?) -> Void) {
        dataTask(path: path, params: params, method: "DELETE", completion: completion)
    }
  
    
    private static func requestForPathWithParams(path: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "" + path)! as URL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
     
        
        return request
    }
    
    
    private static func stringToJSON(string: String) -> Array<AnyObject> {
        var json: Array<AnyObject>!
        do {
            json = try JSONSerialization.jsonObject(with: string.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions()) as? Array
        } catch {
            print(error)
        }
        
        return json
    }
   
        
    
}
