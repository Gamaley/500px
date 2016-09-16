//
//  UIViewController.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 16.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String, buttonAction: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler:buttonAction))
        presentViewController(alertController, animated: true, completion: nil)
    }

}
