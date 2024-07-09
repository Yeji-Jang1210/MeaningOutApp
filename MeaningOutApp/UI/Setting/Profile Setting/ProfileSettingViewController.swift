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
        return object
    }()
    
    let acceptButton: BaseButton = {
        let object = BaseButton(style: .primary)
        object.setTitle(Localized.complete.text, for: .normal)
        return object
    }()
    
    //MARK: - properties
    let viewModel = ProfileSettingViewModel()
    var type: ProfileVCType = .edit
    
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
        configureUIAction()
        bindData()
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
        }
    }
    
    private func configureUIAction(){
        //characterView Tap Action
        let gesture = UITapGestureRecognizer(target: self, action: #selector(characterViewTapped))
        characterView.addGestureRecognizer(gesture)
        
        //accept button Tap Action
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        
        //nicknameTextField addAction
        nicknameTextField.addTarget(self, action: #selector(nicknameTextChanged), for: .editingChanged)
    }
    
    private func bindData(){
        viewModel.outputImageNum.bind { num in
            self.characterView.image = Character.getImage(num: num)
        }
        
        viewModel.outputNickname.bind { nickname in
            self.nicknameTextField.text = nickname
        }
        
        viewModel.outputNicknameStatus.bind { status in
            self.nicknameStatusLabel.text = status?.message
        }
        
        viewModel.outputIsNicknameValid.bind { result in
            switch self.type {
            case .setting:
                self.acceptButton.isEnabled = result
            case .edit:
                self.navigationItem.rightBarButtonItem?.isEnabled = result
            }
        }
        
        viewModel.outputIsSaved.bind { result in
            guard let result else { return }
            
            if result {
                switch self.type {
                case .setting:
                    let vc = MainTabBarController()
                    self.changeRootViewController(vc)
                    return
                case .edit:
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.view.makeToast(Localized.user_info_saved_error.text)
            }
            
        }
    }
    
    //MARK: - function
    @objc func characterViewTapped(){
        let vc = SelectCharacterViewController(title: type.navTitle, isChild: true)
        //delegate 연결
        vc.delegate = self
        vc.selectNumber = viewModel.outputImageNum.value
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func acceptButtonTapped(){
        viewModel.inputIsSaved.value = true
    }
    
    func dataSend(id: Int) {
        viewModel.inputImageNum.value = id
    }
    
    @objc func saveData(){
        viewModel.inputIsSaved.value = true
    }
    
    @objc func nicknameTextChanged(_ sender: UITextField) {
        viewModel.inputNickname.value = sender.text
    }
}
