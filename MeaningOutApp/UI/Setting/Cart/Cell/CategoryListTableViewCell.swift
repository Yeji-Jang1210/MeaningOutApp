//
//  CategoryListTableViewCell.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/9/24.
//

import UIKit
import SnapKit

class CategoryListTableViewCell: BaseTableViewCell {
    
    static let identifier: String = String(describing: CategoryListTableViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        textLabel?.font = .systemFont(ofSize: 16)
        
        detailTextLabel?.textColor = Color.warmGray
        detailTextLabel?.font = .systemFont(ofSize: 12)
    }
    
    public func setData(_ category: Category){
        textLabel?.text = category.name
        detailTextLabel?.text = category.categoryDescription
        
    }
}
