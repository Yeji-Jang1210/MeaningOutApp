//
//  BaseButton.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit

class BaseButton: UIButton {
    
    init(style: BaseButtonStyle) {
        super.init(frame: .zero)
        backgroundColor = style.backColor
        setTitleColor(style.fontColor, for: .normal)
        titleLabel?.font = style.font
        
        switch style {
        case .unselect:
            self.layer.borderColor = Color.lightGray.cgColor
            self.layer.borderWidth = 1
        default:
            break
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
