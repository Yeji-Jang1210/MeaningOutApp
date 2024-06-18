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
    
    func highlightSearchText(searchText: String?) -> NSAttributedString {
        guard let searchKey = searchText?.lowercased(), !searchKey.isEmpty else {
            return NSAttributedString(string: self)
        }
        
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes([ .backgroundColor : Color.primaryOrange, .foregroundColor : Color.white], range: (self as NSString).range(of: searchKey, options: .caseInsensitive))
        
        return attributedString
    }
    
}
