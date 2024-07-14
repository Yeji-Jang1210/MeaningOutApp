//
//  AddProductTableViewCell.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/13/24.
//

import UIKit
import SnapKit
import Kingfisher

final class AddProductTableViewCell: UITableViewCell {
    static let identifier = String(describing: AddProductTableViewCell.self)
    
    let categoryImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
        object.layer.cornerRadius = 8
        return object
    }()
    
    let emptyCategoryView: UIView = {
        let object = UIView()
        object.isHidden = true
        object.clipsToBounds = true
        object.layer.cornerRadius = 8
        object.layer.borderWidth = 0.5
        object.layer.borderColor = Color.lightGray.cgColor
        object.backgroundColor = .clear
        return object
    }()
    
    let emptyCategoryImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        object.clipsToBounds = true
        object.image = UIImage(systemName: "folder.circle")
        object.tintColor = Color.lightGray
        return object
    }()
    
    let titleLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.medium.boldFont
        return object
    }()
    
    let descriptionLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.small.basicFont
        object.textColor = Color.darkGray
        return object
    }()
    
    let accessoryImageView: UIImageView = {
        let object = UIImageView()
        object.image = ImageAssets.plusCircle
        object.contentMode = .scaleAspectFit
        object.tintColor = Color.primaryOrange
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){
        contentView.addSubview(categoryImageView)
        contentView.addSubview(emptyCategoryView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(accessoryImageView)
        
        emptyCategoryView.addSubview(emptyCategoryImageView)
    }
    
    func configureLayout(){
        categoryImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.width.equalTo(categoryImageView.snp.height)
        }
        
        emptyCategoryView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.width.equalTo(emptyCategoryView.snp.height)
        }
        
        emptyCategoryImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryImageView.snp.trailing).offset(8)
            make.top.equalTo(categoryImageView)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }
        
        accessoryImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-8)
            make.size.equalTo(24)
        }
    }
    
    func configureUI(){
        
    }
    
    public func setData(_ category: Category){
        if let urlStr = category.products.first?.image, let url = URL(string: urlStr){
            categoryImageView.kf.setImage(with: url)
        } else {
            emptyCategoryView.isHidden = false
        }
        
        titleLabel.text = category.name
        descriptionLabel.text = category.categoryDescription
    }
}
