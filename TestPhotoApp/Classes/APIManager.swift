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
    }
    
}
