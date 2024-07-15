//
//  CategoryListCollectionViewCell.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/13/24.
//

import UIKit
import SnapKit
import Kingfisher

class CategoryListCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CategoryListCollectionViewCell.self)
    
    let backView: UIView = {
        let object = UIView()
        object.backgroundColor = .clear
        return object
    }()
    
    let imageView: UIImageView = {
        let object = UIImageView()
        object.backgroundColor = .lightGray
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
        object.layer.cornerRadius = 8
        return object
    }()
    
    let titleLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.medium.boldFont
        object.textAlignment = .left
        return object
    }()
    
    let descriptionLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.small.basicFont
        object.textColor = Color.darkGray
        object.textAlignment = .left
        return object
    }()
    
    //MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil 
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        contentView.addSubview(backView)
        
        backView.addSubview(imageView)
        backView.addSubview(titleLabel)
        backView.addSubview(descriptionLabel)
    }
    
    private func configureLayout(){
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.height.equalTo(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(imageView)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.height.equalTo(14)
        }
    }
    
    public func setData(_ category: Category){
        if let urlStr = category.products.first?.image, let url = URL(string: urlStr){
            imageView.kf.setImage(with: url)
        }
        
        titleLabel.text = category.name
        descriptionLabel.text = category.categoryDescription
        
    }
}

