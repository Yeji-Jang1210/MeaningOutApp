//
//  String+Extension.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit

extension String {
    func removingHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
