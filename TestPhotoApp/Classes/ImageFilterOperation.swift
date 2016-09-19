//
//  ImageFilterOperation.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 19.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import UIKit

final class ImageFilterOperation: NSOperation {

    let picture: Picture
    
    init(picture: Picture) {
        self.picture = picture
    }
    
    override func main () {
        if self.cancelled {
            return
        }
        if self.picture.state != .Downloaded {
            return
        }
        if let filteredImage = self.picture.image {
            self.picture.image = filteredImage
            self.picture.state = .Filtered
        }
    }
}
