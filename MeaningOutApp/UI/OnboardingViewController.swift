//
//  OnboardingViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit
import SnapKit

class OnboardingViewController: BaseVC {
    
    //MARK: - object
    let titleLabel: UILabel = {
        let object = UILabel()
        object.text = Localized.title.text
        object.textAlignment = .center
        object.font = .systemFont(ofSize: 40, weight: .heavy)
        object.textColor = Color.primaryOrange
        return object
    }()
    
    let startButton: BaseButton = {
        let object = BaseButton(style: .primary)
        object.setTitle(Localized.start.text, for: .normal)
        return object
    }()
    
    let launchImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        object.image = ImageAssets.launch
        return object
    }()
    //MARK: - properties
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAction()
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(titleLabel)
        view.addSubview(startButton)
        view.addSubview(launchImageView)
    }
    
    override func configureLayout(){
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(launchImageView.snp.top).offset(-20)
        }
        
        launchImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(launchImageView.snp.width)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(20)
            make.height.equalTo(BaseButtonStyle.primary.height)
        }
    }
    
    //MARK: - function
    private func configureAction(){
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc func startButtonTapped(){
        let vc = ProfileSettingViewController(type: .setting)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
