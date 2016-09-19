//
//  PictureDetailsViewController.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 15.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import UIKit

final class PictureDetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    //MARK: - Public Properties
    
    var picturesArray = [Picture]()
    var pictureID: Int?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.maximumZoomScale = 15
        loadPicture()
    }
    
    //MARK: - IBActions

    @IBAction func close(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Private Methods
    
    private func loadPicture() {
        guard let id = pictureID else { return }
        Picture.getPictureByID(id) { [weak self] (item, error) in
            guard let strongSelf  = self else { return }
            guard let picture = item as? Picture else { return }
            strongSelf.updateUserInterface(picture)
        }
    }
    
    private func updateUserInterface(picture: Picture) {
        guard let pictureUrlString = picture.imageURL, let url = NSURL(string: pictureUrlString) else { return }
        imageView.sd_setImageWithURL(url)
    }

}

//MARK: - UIScrollViewDelegate

extension PictureDetailsViewController: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
