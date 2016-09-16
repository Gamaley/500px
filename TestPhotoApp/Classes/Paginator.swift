//
//  Paginator.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 16.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import Foundation

protocol AsyncGeneratorType {
    associatedtype Elements
    associatedtype Fetch
    mutating func next(fetchNextPage: Fetch, onFinish: ((Elements) -> Void)?)
}

public final class Paginator<T>: AsyncGeneratorType {

    typealias Elements = Array<T>
    typealias Fetch = (page: Int, count: Int, completion: (result: Elements) -> Void) -> Void

    //MARK: - Properties
    
    public var page: Int
    public var count: Int
    private var previousPage: Int
    
    //MARK: - Initializers
    
    public init(startPage: Int = 1, count: Int = 20) {
        self.previousPage = 0
        self.page = startPage
        self.count = count
    }
    
    //MARK: - Public Methods
    
    public func setDefaultPage() {
        self.page = 1
        self.previousPage = 0
    }
    
    //MARK: - AsyncGeneratorType

    func next(fetchNextPage: Fetch, onFinish: ((Elements) -> Void)? = nil) {
        if self.previousPage != self.page {
            fetchNextPage(page: page, count: count) { [unowned self] (items) in
                onFinish?(items)
                self.previousPage = self.page
                self.page += items.count / self.count
            }
        }
    }
}
