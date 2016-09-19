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
    
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak private var indicatorView: UIActivityIndicatorView!
    
    //MARK: - Public Properties
    
    var picture: Picture? {
        didSet {
            pictureImageView.removeAllGradients()
            pictureImageView.addGradientWithFrame(pictureImageView.bounds, color: UIColor.blackColor())
            guard let picture = picture else { return }
            likesCountLabel.text = "\u{2764} " + String(picture.votesCount!) + "\n" + dateString()
        }
    }
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
    
    //MARK: - Private Methods
    
    private func dateString() -> String {
        guard let createdAt = picture?.createdAt else {return ""}
        let format = "dd MMM YY"
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        
        return formatter.stringFromDate(createdAt)
    }
}
