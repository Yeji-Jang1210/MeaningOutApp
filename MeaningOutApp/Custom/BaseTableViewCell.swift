//
//  BaseTableViewCell.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/25/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){
        
    }
    
    func configureLayout(){
        
    }
    
    func configureUI(){
        
    }
}
