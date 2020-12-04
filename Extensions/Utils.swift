//
//  Utils.swift
//  Middlezap
//
//  Created by Matheus Damasceno.
//  Copyright © 2020 Matheus Damasceno. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(views: [UIView]) {
        views.forEach { (view) in
            self.addSubview(view)
        }
    }
}
