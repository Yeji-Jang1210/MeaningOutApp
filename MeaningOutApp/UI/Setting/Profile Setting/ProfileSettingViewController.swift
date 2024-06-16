//
//  ProfileSettingViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit
import SnapKit
import SwiftyUserDefaults

class ProfileSettingViewController: BaseVC, SendProfileImageId {
    
    //MARK: - object
    let characterView: CharacterView = {
        let object = CharacterView(style: .setting)
        return object
    }()
    
    let nicknameTextField: UITextField = {
        let object = UITextField()
        object.attributedPlaceholder = NSAttributedString(string: Localized.nickname_placeholder.text,
                                                          attributes: [.font : BaseFont.medium.basicFont, .foregroundColor : Color.warmGray])
        object.borderStyle = .none
        return object
    }()
    
    let separatorLine: UIView = {
        let object = UIView()
        object.backgroundColor = Color.warmGray
        return object
    }()
    
    let nicknameStatusLabel: UILabel = {
        let object = UILabel()
        object.font = BaseFont.medium.basicFont
        object.textColor = Color.primaryOrange
        object.text = "닉네임에 @ 는 포함할 수 없어요."
        return object
    }()
    
    let acceptButton: BaseButton = {
        let object = BaseButton(style: .primary)
        object.setTitle(Localized.complete.text, for: .normal)
        return object
    }()
    
    //MARK: - properties
    var type: ProfileVCType?
    var imageNum: Int = 0 {
        didSet {
            characterView.image = Character.getImage(num: imageNum)
        }
    }
    
    //MARK: - life cycle
    init(type: ProfileVCType){
        super.init(title: type.navTitle, isChild: true)
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        bindAction()
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        view.addSubview(characterView)
        view.addSubview(separatorLine)
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameStatusLabel)
        view.addSubview(acceptButton)
    }
    
    private func configureLayout(){
        characterView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(120)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(separatorLine.snp.horizontalEdges).inset(10)
            make.top.equalTo(characterView.snp.bottom).offset(40)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(24)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.height.equalTo(0.5)
        }
        
        nicknameStatusLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nicknameTextField.snp.horizontalEdges)
            make.top.equalTo(separatorLine.snp.bottom).offset(12)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameStatusLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(separatorLine.snp.horizontalEdges)
            make.height.equalTo(BaseButtonStyle.primary.height)
        }
    }
    
    private func configureUI(){
        if type == .edit {
            acceptButton.isHidden = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localized.profile_edit_save_button.title, style: .done, target: self, action: #selector(saveData))
            navigationItem.rightBarButtonItem?.tintColor = Color.black
            setData()
        }
    }
    
    //MARK: - function
    private func bindAction(){
        //characterView Tap Action
        let gesture = UITapGestureRecognizer(target: self, action: #selector(characterViewTapped))
        characterView.addGestureRecognizer(gesture)
        
        //accept button Tap Action
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    @objc func characterViewTapped(){
        guard let type else { return }
        let vc = SelectCharacterViewController(title: type.navTitle, isChild: true)
        //delegate 연결
        vc.delegate = self
        vc.selectNumber = imageNum
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func acceptButtonTapped(){
        saveData()
    }
    
    func dataSend(id: Int) {
        imageNum = id
    }
    
    func setData(){
        nicknameTextField.text = User.nickname
        imageNum = User.profileImageId ?? 0
    }
    
    @objc func saveData(){
        //validate 작업 필요
        User.nickname = nicknameTextField.text!
        
        User.profileImageId = imageNum
        User.signupDate = Date.now
        
        switch type {
        case .setting:
            let vc = MainTabBarController()
            self.changeRootViewController(vc)
            return
        case .edit:
            navigationController?.popViewController(animated: true)
        case nil:
            print("error")
        }
    }
}

