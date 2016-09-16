//
//  Picture.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 15.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

final class Picture: Mappable {
    
    var id: Int?
    var name: String?
    var description: String?
    var createdAt: NSDate?
    var timesViewed: Int?
    var rating: Double?
    var votesCount: Int?
    var commentsCount: Int?
    var imageURL: String?
    
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        description     <- map["description"]
        createdAt       <- (map["created_at"], DateTransformer())
        timesViewed     <- map["times_viewed"]
        rating          <- map["rating"]
        votesCount      <- map["votes_count"]
        commentsCount   <- map["comments_count"]
        imageURL        <- map["image_url"]
        
    }
}

extension Picture {
    
    static func getPictures(page: Int = 0, completion: APIManager.ArrayErrorClosure, failure: APIManager.ObjectErrorClosure ) {
        var url = APIManager.sharedManager.BaseURL
        url.appendContentsOf(APIManager.Route.popularPhotos.rawValue)
        let params: [String : AnyObject] = ["page": page, "consumer_key": APIManager.sharedManager.ConsumerKey]
        
        Alamofire.request(.GET, url, parameters: params).validate().responseArray(keyPath: "photos") { (response: Response<[Picture], NSError>) in
            switch response.result {
            case .Success:
                print(APIManager.sharedManager.jsonFromData(response.data))
                if let pictures = response.result.value {
                    completion(items: pictures, error: nil)
                } else {
                    completion(items: [], error: nil)
                }
            case .Failure:
                print(APIManager.sharedManager.errorStringFromData(response.data!))
                failure(error: APIManager.sharedManager.errorStringFromData(response.data!))
            }
        }
    }
    
}
