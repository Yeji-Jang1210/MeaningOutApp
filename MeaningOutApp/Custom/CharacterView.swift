//
//  CharacterView.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit
import SnapKit
import Kingfisher

class CharacterView: UIView {
    //MARK: - object
    let characterImageView: UIImageView = {
        let object = UIImageView()
        object.backgroundColor = .clear
        object.clipsToBounds = true
        object.contentMode = .scaleAspectFill
        return object
    }()
    
    let cameraBackgroundView: UIView = {
        let object = UIView()
        object.isHidden = true
        object.backgroundColor = Color.primaryOrange
        object.clipsToBounds = true
        return object
    }()
    
    let cameraImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        object.image = ImageAssets.camera.image
        object.tintColor = Color.white
        return object
    }()
    
    //MARK: - properties
    var style: CharacterStyle? {
        didSet {
            configureUI()
        }
    }
    
    var image: UIImage? {
        get {
            return characterImageView.image
        }
        
        set {
            characterImageView.image = newValue
        }
    }
    
    //MARK: - initialize
    init(style: CharacterStyle){
        super.init(frame: .zero)
        self.style = style
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        addSubview(characterImageView)
        addSubview(cameraBackgroundView)
        cameraBackgroundView.addSubview(cameraImageView)
    }
    
    private func configureLayout(){
        characterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(characterImageView.snp.width)
        }
        
        cameraBackgroundView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
            make.size.equalTo(32)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
            make.width.equalTo(cameraImageView.snp.height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        characterImageView.layer.cornerRadius = characterImageView.bounds.width / 2
        cameraBackgroundView.layer.cornerRadius = cameraBackgroundView.bounds.width / 2
    }
    
    private func configureUI(){
        if let style = self.style {
            self.alpha = style.alpha
            characterImageView.layer.borderWidth = style.borderWidth
            characterImageView.layer.borderColor = style.borderColor
            
            if style == .setting {
                cameraBackgroundView.isHidden = false
            }
        }
    }
    
    //MARK: - function
    public func setImage(image: UIImage){
        characterImageView.image = image
    }
}
