//
//  UIView+Extension.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/6/24.
//

import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
