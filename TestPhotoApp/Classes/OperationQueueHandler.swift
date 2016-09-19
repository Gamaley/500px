//
//  OperationQueueHandler.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 19.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import UIKit

final public class OperationQueueHandler {

    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var filtrationsInProgress = [NSIndexPath:NSOperation]()
    lazy var filtrationQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Filtration"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    public func suspendAllOperations () {
        downloadQueue.suspended = true
        filtrationQueue.suspended = true
    }
    
    public func resumeAllOperations () {
        downloadQueue.suspended = false
        filtrationQueue.suspended = false
    }

    
}
