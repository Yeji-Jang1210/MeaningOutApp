//
//  MeaningOutItemCell.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import Kingfisher

class MeaningOutItemCell: UICollectionViewCell {
    
    static var identifier = String(describing: MeaningOutItemCell.self)
    
    //MARK: - object
    let itemImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFill
        object.clipsToBounds = true
        return object
    }()
    
    let mallLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.small.basicFont
        object.textColor = Color.lightGray
        return object
    }()
    
    let itemTitle: UILabel = {
        let object = UILabel()
        object.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        object.font = BaseFont.medium.basicFont
        object.numberOfLines = 2
        return object
    }()
    
    let priceLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.large.boldFont
        return object
    }()
    
    let cartButton: UIButton = {
        let object = UIButton()
        object.setImage(ImageAssets.like_selected.image, for: .selected)
        object.setImage(ImageAssets.like_unselected.image, for: .normal)
        object.backgroundColor = object.isSelected ? Color.white : Color.black.withAlphaComponent(0.5)
        object.clipsToBounds = true
        return object
    }()
    
    //MARK: - properties
    
    //MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        addSubview(itemImageView)
        addSubview(mallLabel)
        addSubview(itemTitle)
        addSubview(priceLabel)
        addSubview(cartButton)
    }
    
    private func configureLayout(){
        itemImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(itemImageView.snp.width).multipliedBy(1.2)
        }
        
        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(14)
        }
        
        itemTitle.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemTitle.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(20)
        }
        
        cartButton.snp.makeConstraints { make in
            make.trailing.equalTo(itemImageView.snp.trailing).inset(12)
            make.bottom.equalTo(itemImageView.snp.bottom).inset(12)
            make.size.equalTo(24)
        }
    }
    
    private func configureUI(){
        itemImageView.layer.cornerRadius = 8
        cartButton.layer.cornerRadius = 4
    }
    
    //MARK: - function
    public func setData(_ data: Item){
        if let url = URL(string: data.image) {
            itemImageView.kf.setImage(with: url)
        }
        
        mallLabel.text = data.mallName
        itemTitle.text = data.removedHTMLTagTitle
        priceLabel.text = data.priceStr
    }
}
