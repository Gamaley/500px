//
//  PicturesCollectionViewController.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 15.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "Cell"

public final class PicturesCollectionViewController: UICollectionViewController {
    
    // MARK: - Private Properties
    
    private var dataSource: [Picture] = []
    private var isNewDataLoading = false
    private var paginator = Paginator<Picture>()
    
    //MARK: - Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        fetchPictures()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Private Methods
    
    private func fetchPictures() {
        paginator.setDefaultPage()
        paginator.next(fetchNextPage) { [weak self] (pictures) in
            guard let strongSelf = self else { return }
            strongSelf.updateUserInterface(pictures)
        }
    }
    
    private func fetchNextPage(page: Int, count: Int, completion: ([Picture] -> Void )) -> Void {
        isNewDataLoading = true
        Picture.getPictures(page, count: count) { [weak self] (items, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showAlert("Error", message: error, buttonAction: nil)
            }
            guard let pictures = items as? [Picture] else { return }
            completion(pictures)
        }
    }
    
    private func updateUserInterface(pictures: [Picture]) {
        isNewDataLoading = false
        dataSource += pictures
        self.collectionView?.reloadData()
    }
    
    //MARK: - Navigation
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? PictureDetailsViewController {
            guard let picture = (sender as? PictureCollectionViewCell)?.picture else { return }
            destinationViewController.picture = picture
            destinationViewController.picturesArray = dataSource
        }
    }
    
}

    //MARK: - UICollectionViewDelegate

extension PicturesCollectionViewController {
    
    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PictureCollectionViewCell.identifier, forIndexPath: indexPath) as! PictureCollectionViewCell
        cell.picture = dataSource[indexPath.item]
        return cell
    }

}

//MARK: - UICollectionViewDelegate

extension PicturesCollectionViewController {
    
    public override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == self.dataSource.count - 1) {
            if !isNewDataLoading {
                paginator.next(fetchNextPage, onFinish: updateUserInterface)
            }
        }
    }
    
    public override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
    }
}

//MARK: - UIScrollViewDelegate
    
//extension PicturesCollectionViewController {

//    public override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
//            if !isNewDataLoading {
//                paginator.next(fetchNextPage, onFinish: updateUserInterface)
//            }
//        }
//    }
    
//}
