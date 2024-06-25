//
//  SearchItemCell.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import SnapKit

class SearchItemCell: BaseTableViewCell {
    static let identifier = String(describing: SearchItemCell.self)
    
    //MARK: - object
    let clockImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        object.tintColor = Color.black
        object.image = ImageAssets.clock.image
        return object
    }()
    
    let titleLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.medium.basicFont
        return object
    }()
    
    let deleteButton: UIButton = {
        let object = UIButton(type: .system)
        object.tintColor = Color.black
        object.setImage(ImageAssets.xmark.image, for: .normal)
        return object
    }()
    
    //MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        contentView.addSubview(clockImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(deleteButton)
    }
    
    override func configureLayout(){
        clockImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(clockImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
