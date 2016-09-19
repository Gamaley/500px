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
    @IBOutlet weak private var indicatorView: UIActivityIndicatorView!
    
    //MARK: - Public Properties
    
    var picture: Picture?
    var image: UIImage? {
        didSet {
            guard let image = image else { return }
            pictureImageView.image = image
        }
    }

    //MARK: - Public Methods
    
    override func prepareForReuse() {
        pictureImageView.image = UIImage.init(named: "placeholder.png")
        indicatorView.hidden = false
        image = nil
    }
    
    func animateIndicator(start: Bool) {
        indicatorView.hidden = !start
        if start {
            indicatorView.startAnimating()
            return
        }
        indicatorView.stopAnimating()        
    }
}
