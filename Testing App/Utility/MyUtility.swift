//
//  MyUtility.swift
//  Testing App
//
//  Created by Lee Yik Kong on 28/10/2020.
//

import UIKit

class MyUtility: NSObject {
    public static func checkStringJson(_ object: Dictionary<String, Any>,_ key: String) -> String{
        if let value = object[key] as? String{
            return value
        }
        
        return ""
    }
    
    public static func checkIntJson(_ object: Dictionary<String, Any>,_ key: String) -> Int{
        if let value = object[key] as? Int{
            return value
        }
        
        return 0
    }
    
    public static func checkJsonArray(_ object: Dictionary<String, Any>,_ key: String) -> Array<Dictionary<String, Any>>{
        if let objectList: Array<Dictionary<String, Any>> = object[key] as? Array<Dictionary<String, Any>> {
            return objectList
        }
        return Array<Dictionary<String, Any>>()
    }
    
    public static func loadAllPostUrl(url: String, completion: @escaping ((_ callBackObject: Any?) -> ())) {
        do {
            if let dataFile = URL(string: url) {
                let data = try Data(contentsOf: dataFile)
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    completion(jsonArray)
                } else {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    completion(jsonObject)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
