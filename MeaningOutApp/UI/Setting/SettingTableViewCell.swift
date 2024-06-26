//
//  SettingTableViewCell.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/16/24.
//

import UIKit
import SnapKit

class SettingTableViewCell: BaseTableViewCell {
    
    static var identifier: String = String(describing: SettingTableViewCell.self)
    
    //MARK: - object
    let settingLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.medium.basicFont
        return object
    }()
    
    let detailView: UIStackView = {
        let object = UIStackView()
        object.axis = .horizontal
        object.spacing = 4
        object.alignment = .fill
        return object
    }()
    
    let detailViewIcon: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        return object
    }()
    
    let detailLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.medium.basicFont
        return object
    }()
    //MARK: - properties
    
    //MARK: - initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        addSubview(settingLabel)
        addSubview(detailView)
        detailView.addArrangedSubview(detailViewIcon)
        detailView.addArrangedSubview(detailLabel)
    }
    
    override func configureLayout(){
        settingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        detailView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        detailViewIcon.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    //MARK: - function
    public func setCartList(attributes: NSMutableAttributedString){
        detailViewIcon.image = ImageAssets.like_selected
        detailLabel.attributedText = attributes
    }
}
