//
//  UIView + Extensions.swift
//  MiddleZapClient
//
//  Created by Gabriel Palhares on 03/12/20.
//  Copyright © 2020 Gabriel Palhares. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(views: [UIView]) {
        views.forEach { (view) in
            self.addSubview(view)
        }
    }
}
