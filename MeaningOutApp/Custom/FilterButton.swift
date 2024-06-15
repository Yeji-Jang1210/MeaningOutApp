//
//  FilterButton.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/15/24.
//

import UIKit
import SnapKit

class FilterButton: UIButton {
    override var isSelected: Bool {
        didSet {
            print(isSelected)
            backgroundColor = isSelected ? Color.darkGray : Color.white
            setTitleColor(isSelected ? Color.white : Color.black, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = isSelected ? UIColor.clear.cgColor : Color.lightGray.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = BaseFont.medium.basicFont
        setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
