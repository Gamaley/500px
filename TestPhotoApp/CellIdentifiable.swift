//
//  CellIdentifiable.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 16.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import UIKit

protocol CellIdentifiable {
    static var identifier: String { get }
}

extension CellIdentifiable {
    static var identifier: String {
        return String(self)
    }
}
