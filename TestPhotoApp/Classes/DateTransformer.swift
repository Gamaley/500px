//
//  DateTransformer.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 15.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import UIKit
import ObjectMapper

public final class DateTransformer: TransformType {
    
    public typealias Object = NSDate
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> NSDate? {
        
        if let timeString = value as? String {
            let formatter = NSDateFormatter()
            formatter.timeZone = NSTimeZone(name: "GMT")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-zz:zz"
            return formatter.dateFromString(timeString)
        }
        return nil
    }
    
    public func transformToJSON(value: NSDate?) -> String? {
        if let date = value {
            let formatter = NSDateFormatter()
            formatter.dateFormat = ""
            return formatter.stringFromDate(date)
        }
        return nil
    }
}
