//
//  PictureDetailsViewController.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 15.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import UIKit

final class PictureDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    var picturesArray = [Picture]()
    var picture: Picture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
    }

    private func setupImageView() {
        guard let picture = picture else { return }
        guard let pictureUrlString = picture.imageURL, let url = NSURL(string: pictureUrlString) else { return }
        imageView.sd_setImageWithURL(url)
    }
    
}
