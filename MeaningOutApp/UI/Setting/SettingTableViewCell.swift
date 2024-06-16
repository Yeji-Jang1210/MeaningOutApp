//
//  SettingTableViewCell.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/16/24.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
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
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        addSubview(settingLabel)
        addSubview(detailView)
        detailView.addArrangedSubview(detailViewIcon)
        detailView.addArrangedSubview(detailLabel)
    }
    
    private func configureLayout(){
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
    
    private func configureUI(){
        
    }
    
    //MARK: - function
    public func setCartList(attributes: NSMutableAttributedString){
        detailViewIcon.image = ImageAssets.like_selected.image
        detailLabel.attributedText = attributes
    }
}
