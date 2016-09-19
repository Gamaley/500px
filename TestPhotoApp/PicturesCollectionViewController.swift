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
    
    private let queueHandler = OperationQueueHandler()
    
    private var dataSource: [Picture] = []
    private var isNewDataLoading = false
    private var paginator = Paginator<Picture>()
    
    
    //MARK: - Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        fetchPictures()
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
        collectionView?.reloadData()
    }
    
    private func startOperationsForPicture(picture: Picture, indexPath: NSIndexPath) {
        switch (picture.state) {
        case .New:
            download(picture, indexPath: indexPath)
        case .Downloaded:
            filter(picture, indexPath: indexPath)
        case .Failed:
            download(picture, indexPath: indexPath)
        default:
            return
        }
    }
    
    private func download(picture: Picture, indexPath: NSIndexPath){
        if let _ = queueHandler.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ImadeDownloadOperation(picture: picture)
        downloader.completionBlock = { [unowned downloader] in
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.queueHandler.downloadsInProgress.removeValueForKey(indexPath)
                self.collectionView!.reloadItemsAtIndexPaths([indexPath])
            })
        }
        queueHandler.downloadsInProgress[indexPath] = downloader
        queueHandler.downloadQueue.addOperation(downloader)
    }
    
    private func filter(picture: Picture, indexPath: NSIndexPath) {
        if let _ = queueHandler.filtrationsInProgress[indexPath] {
            return
        }
        
        let filterer = ImageFilterOperation(picture: picture)
        filterer.completionBlock = { [unowned filterer] in
            if filterer.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.queueHandler.filtrationsInProgress.removeValueForKey(indexPath)
                self.collectionView!.reloadItemsAtIndexPaths([indexPath])
            })
        }
        queueHandler.filtrationsInProgress[indexPath] = filterer
        queueHandler.filtrationQueue.addOperation(filterer)
    }
    
    
    private func loadImagesForVisibleItems() {
        
        if let pathsArray = collectionView?.indexPathsForVisibleItems() {
            var allqueueOperations = Set(queueHandler.downloadsInProgress.keys)
            allqueueOperations.unionInPlace(queueHandler.filtrationsInProgress.keys)
            
            var toBeCancelled = allqueueOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtractInPlace(visiblePaths)
            
            var toBeStarted = visiblePaths
            toBeStarted.subtractInPlace(allqueueOperations)
            
            for indexPath in toBeCancelled {
                if let pendingDownload = queueHandler.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                queueHandler.downloadsInProgress.removeValueForKey(indexPath)
                if let pendingFiltration = queueHandler.filtrationsInProgress[indexPath] {
                    pendingFiltration.cancel()
                }
                queueHandler.filtrationsInProgress.removeValueForKey(indexPath)
            }
            
            for indexPath in toBeStarted {
                let indexPath = indexPath as NSIndexPath
                let pictureToProcess = dataSource[indexPath.item]
                startOperationsForPicture(pictureToProcess, indexPath: indexPath)
            }
        }
    }
    
    private func setupCell(cell: PictureCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        let pictureObject = dataSource[indexPath.item]
        guard let _ = pictureObject.imageURL else { return }
        cell.image = pictureObject.image
        cell.picture = pictureObject
        
        switch pictureObject.state {
        case .Filtered:
            cell.animateIndicator(false)
        case .Failed:
            cell.animateIndicator(false)
        case .New, .Downloaded:
            cell.animateIndicator(true)
            if (!collectionView!.dragging && !collectionView!.decelerating) {
                startOperationsForPicture(pictureObject, indexPath:indexPath)
            }
        }
    }
    
    //MARK: - Navigation
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? PictureDetailsViewController {
            guard let picture = (sender as? PictureCollectionViewCell)?.picture else { return }
            destinationViewController.pictureID = picture.id
        }
    }
    
}

//MARK: - UICollectionViewDataSource

extension PicturesCollectionViewController {
    
    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PictureCollectionViewCell.identifier, forIndexPath: indexPath) as! PictureCollectionViewCell
        setupCell(cell, atIndexPath: indexPath)
        return cell
    }

}

//MARK: - UICollectionViewDelegate

extension PicturesCollectionViewController {
    public override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == dataSource.count - 10) {
            if !isNewDataLoading {
                paginator.next(fetchNextPage, onFinish: updateUserInterface)
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension PicturesCollectionViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width: CGFloat!
        if UIDevice.currentDevice().orientation == .Portrait {
           width = UIScreen.mainScreen().bounds.size.width/4
        } else {
            width = UIScreen.mainScreen().bounds.size.height/4
        }
        return CGSizeMake(width, width)
    }
}

//MARK: - UIScrollViewDelegate

extension PicturesCollectionViewController {
    
    override public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        queueHandler.suspendAllOperations()
    }
    
    override public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForVisibleItems()
            queueHandler.resumeAllOperations()
        }
    }
    
    override public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        loadImagesForVisibleItems()
        queueHandler.resumeAllOperations()
    }
    
}
