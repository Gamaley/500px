//
//  ImadeDownloadOperation.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 19.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import UIKit

final class ImadeDownloadOperation: NSOperation {

    let picture: Picture
    
    init(picture: Picture) {
        self.picture = picture
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        let imageData = NSData(contentsOfURL:NSURL(string:self.picture.imageURL!)!)
        if self.cancelled {
            return
        }
        if imageData?.length > 0 {
            self.picture.image = UIImage(data:imageData!)
            self.picture.state = .Downloaded
        } else {
            self.picture.state = .Failed
            self.picture.image = UIImage(named: "Failed.jpg")
        }
    }
}
