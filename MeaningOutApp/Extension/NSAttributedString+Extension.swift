//
//  NSAttributedString+Extension.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/11/24.
//

import Foundation

extension NSAttributedString {
    static func placeHolderSetting(text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font : BaseFont.medium.basicFont,
                         .foregroundColor : Color.warmGray])
    }
}
