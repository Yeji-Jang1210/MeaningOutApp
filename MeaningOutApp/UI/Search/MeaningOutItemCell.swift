//
//  MeaningOutItemCell.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import Kingfisher
import SwiftyUserDefaults

protocol PassImageDelegate {
    func passImage(_ image: UIImage)
}

class MeaningOutItemCell: UICollectionViewCell {
    
    static var identifier = String(describing: MeaningOutItemCell.self)
    var delegate: PassImageDelegate?
    
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
        object.setImage(ImageAssets.like_selected, for: .selected)
        object.setImage(ImageAssets.like_unselected, for: .normal)
        object.backgroundColor = object.isSelected ? Color.white : Color.black.withAlphaComponent(0.5)
        object.clipsToBounds = true
        return object
    }()
    
    let errorView: UIView = {
        let object = UIView()
        object.isHidden = true
        object.backgroundColor = .systemGray6
        object.clipsToBounds = true
        return object
    }()
    
    let errorImagView: UIImageView = {
        let object = UIImageView()
        object.image = UIImage(systemName: "exclamationmark.triangle")
        object.tintColor = .darkGray
        object.contentMode = .scaleAspectFit
        return object
    }()

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
    
    override func layoutSubviews() {
        cartButton.backgroundColor = cartButton.isSelected ? Color.white : Color.black.withAlphaComponent(0.5)
    }
    //MARK: - configure function
    private func configureHierarchy(){
        addSubview(itemImageView)
        addSubview(errorView)
        addSubview(mallLabel)
        addSubview(itemTitle)
        addSubview(priceLabel)
        addSubview(cartButton)
        
        
        errorView.addSubview(errorImagView)
        
    }
    
    private func configureLayout(){
        itemImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(itemImageView.snp.width).multipliedBy(1.2)
        }
        
        errorView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(itemImageView.snp.width).multipliedBy(1.2)
        }
        
        errorImagView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.center.equalToSuperview()
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
        errorView.layer.cornerRadius = 8
    }
    
    //MARK: - function
    public func setData(_ data: Product, searchText: String, isSelected: Bool){
        
        if let url = URL(string: data.image) {
            itemImageView.kf.setImage(with: url)
        }
        
        mallLabel.text = data.mallName
        itemTitle.attributedText = data.removedHTMLTagTitle.highlightSearchText(searchText: searchText)
        priceLabel.text = data.priceStr
        
        cartButton.isSelected = isSelected
    }
    
    public func setData(data: CartItem, isSelected: Bool){
        if let url = URL(string: data.image) {
            itemImageView.kf.setImage(with: url)
        } else {
            itemImageView.isHidden = true
            errorView.isHidden = false
        }
        
        mallLabel.text = data.mallName
        itemTitle.text = data.title
        priceLabel.text = Product.formattedPrice(data.price)
        
        cartButton.isSelected = isSelected
    }
}
