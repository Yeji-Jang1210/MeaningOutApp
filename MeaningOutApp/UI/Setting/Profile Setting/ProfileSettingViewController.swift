//
//  ProfileSettingViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit
import SnapKit
import SwiftyUserDefaults

enum ValidateNicknameError: Error {
    case invalid_range
    case contains_specific_character
    case contains_number
    
    var message: String {
        switch self {
        case .invalid_range:
            return Localized.nickname_range_error.text
        case .contains_specific_character:
            return Localized.nickname_contains_specific_character.text
        case .contains_number:
            return Localized.nickname_contains_number.text
        }
    }
}

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
        return object
    }()
    
    let acceptButton: BaseButton = {
        let object = BaseButton(style: .primary)
        object.setTitle(Localized.complete.text, for: .normal)
        return object
    }()
    
    //MARK: - properties
    var type: ProfileVCType = .edit
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
        bindAction()
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(characterView)
        view.addSubview(separatorLine)
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameStatusLabel)
        view.addSubview(acceptButton)
    }
    
    override func configureLayout(){
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
    
    override func configureUI(){
        if type == .edit {
            acceptButton.isHidden = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localized.profile_edit_save_button.title, style: .done, target: self, action: #selector(saveData))
            navigationItem.rightBarButtonItem?.tintColor = Color.black
            setData()
        }
        
        setNicknameStatusLabel(nicknameTextField.text)
    }
    
    //MARK: - function
    private func bindAction(){
        //characterView Tap Action
        let gesture = UITapGestureRecognizer(target: self, action: #selector(characterViewTapped))
        characterView.addGestureRecognizer(gesture)
        
        //accept button Tap Action
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        
        //nicknameTextField addAction
        nicknameTextField.addTarget(self, action: #selector(nicknameTextChanged), for: .editingChanged)
    }
    
    @objc func characterViewTapped(){
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
        nicknameTextField.text = User.shared.nickname
        imageNum = User.shared.profileImageId ?? 0
    }
    
    @objc func saveData(){
        //validate 작업 필요
        User.shared.nickname = nicknameTextField.text!
        
        User.shared.profileImageId = imageNum
        User.shared.signupDate = Date.now
        
        switch type {
        case .setting:
            let vc = MainTabBarController()
            self.changeRootViewController(vc)
            return
        case .edit:
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func nicknameTextChanged(_ sender: UITextField) {
        setNicknameStatusLabel(sender.text)
    }
    
    func setNicknameStatusLabel(_ text: String?){
        do {
            let result = try validateNickname(text)
            
            switch type {
            case .setting:
                acceptButton.isEnabled = result
            case .edit:
                navigationItem.rightBarButtonItem?.isEnabled = result
            }
            
            nicknameStatusLabel.text = ""
            
        } catch(let error) {
            let validateError = error as! ValidateNicknameError
            nicknameStatusLabel.text = validateError.message
            
            switch type {
            case .setting:
                acceptButton.isEnabled = false
            case .edit:
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    
    func validateNickname(_ text: String?) throws -> Bool {
        guard let nickname = text else { return false }
        
        let specificCharacter = CharacterSet(charactersIn: "@#$%")
        let numbers = CharacterSet.decimalDigits
        
        if nickname.count < 2 || nickname.count >= 10 {
            throw ValidateNicknameError.invalid_range
        }
        
        if nickname.rangeOfCharacter(from: specificCharacter) != nil {
            throw ValidateNicknameError.contains_specific_character
        }

        if nickname.rangeOfCharacter(from: numbers) != nil {
            throw ValidateNicknameError.contains_number
        }
        return true
    }
}
