//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 30/05/2023.
//

import Foundation
import Alamofire

extension Request {
    public func debugLog() -> Self {
        if let request = request, let httpBodyData = request.httpBody{
            
            let  requestString = "[" + String(data: httpBodyData, encoding: .utf8)! + "]"
            let data = requestString.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    print(jsonArray) // use the json here
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            return self
            
        }
        return self
    }
}
