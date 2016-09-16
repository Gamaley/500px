//
//  PictureCollectionViewCell.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 15.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import UIKit
import SDWebImage

final class PictureCollectionViewCell: UICollectionViewCell, CellIdentifiable {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var pictureImageView: UIImageView!
    
    
    //MARK: - Public Properties
    
    var picture: Picture? {
        didSet {
            guard let picture = picture else { return }
            guard let pictureUrlString = picture.imageURL, let url = NSURL(string: pictureUrlString) else { return }
            pictureImageView.sd_setImageWithURL(url)
                
        }
    }

}
