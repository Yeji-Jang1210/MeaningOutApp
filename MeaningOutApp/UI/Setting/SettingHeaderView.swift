//
//  SettingHeaderView.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/16/24.
//

import UIKit
import SnapKit

class SettingHeaderView: UIView {
    //MARK: - object
    let characterView: CharacterView = {
        let object = CharacterView(style: .select)
        //이미지 설정(Defaults에서 가져오기)
        return object
    }()
    
    let nicknameLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.nickname.boldFont
        return object
    }()
    
    let signupDateLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.medium.basicFont
        object.textColor = Color.warmGray
        return object
    }()
    
    let editSettingButton: UIButton = {
        let object = UIButton()
        object.setImage(ImageAssets.rightArrow.image, for: .normal)
        object.tintColor = Color.warmGray
        return object
    }()
    
    let stackView: UIStackView = {
       let object = UIStackView()
        object.axis = .vertical
        object.alignment = .fill
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
        addSubview(characterView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(nicknameLabel)
        stackView.addArrangedSubview(signupDateLabel)
        
        addSubview(editSettingButton)
    }
    
    private func configureLayout(){
        characterView.snp.makeConstraints { make in
            make.size.equalTo(75)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(characterView.snp.centerY)
            make.leading.equalTo(characterView.snp.trailing).offset(20)
        }
        
        editSettingButton.snp.makeConstraints { make in
            make.centerY.equalTo(characterView.snp.centerY)
            make.trailing.equalToSuperview().inset(12)
            make.leading.equalTo(stackView.snp.trailing).offset(12)
            make.size.equalTo(30)
        }
    }
    
    private func configureUI(){
        setData()
    }
    //MARK: - function
    
    public func setData(){
        nicknameLabel.text = User.shared.nickname
        signupDateLabel.text = User.shared.signupDateText
        characterView.image = Character.getImage(num: User.shared.profileImageId ?? 0)
    }
}
