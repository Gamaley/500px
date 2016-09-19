//
//  APIManager.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 15.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import UIKit

final class APIManager: NSObject {

    static let sharedManager = APIManager()
    
    let BaseURL = "https://api.500px.com/v1/"
    let ConsumerKey = "tSjzFI2cVvAxg8hOBjsW1Yl8JGYxzZgJvO05NsSu"
    
    enum Route: String {
        case popularPhotos = "photos?feature=popular"
        case photosByID = "photos/%ld"
    }
    
    typealias ArrayErrorClosure = (items: [AnyObject], error: String?) -> Void
    typealias ObjectErrorClosure = (item: AnyObject?, error: String?) -> Void
    
    func jsonFromData(data: NSData?) -> [String:AnyObject]? {
        guard let data = data else {
            return nil
        }
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String:AnyObject] {
                return json
            }
        } catch {
            print(error)
        }
        return nil
    }
    
}
