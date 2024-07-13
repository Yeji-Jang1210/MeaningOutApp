//
//  AddCategoryViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/9/24.
//

import UIKit
import SnapKit

class AddCategoryViewController: UIViewController {
    
    lazy var addButton: BaseButton = {
        let object = BaseButton(style: .primary)
        object.setTitle(Localized.save_button.title, for: .normal)
        object.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return object
    }()
    
    lazy var categoryTitleTextField: UITextField = {
        let object = UITextField()
        object.attributedPlaceholder = NSAttributedString.placeHolderSetting(text: Localized.add_category_title_placeholder.text)
        object.borderStyle = .none
        return object
    }()
    
    let titleSeparatorLine: UIView = {
        let object = UIView()
        object.backgroundColor = Color.warmGray
        return object
    }()
    
    lazy var categoryDescriptionTextField: UITextField = {
        let object = UITextField()
        object.attributedPlaceholder = NSAttributedString.placeHolderSetting(text: Localized.add_category_description_placeholder.text)
        object.borderStyle = .none
        return object
    }()
    
    let descriptionSeparatorLine: UIView = {
        let object = UIView()
        object.backgroundColor = Color.warmGray
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
    }
    
    var saveCategory: (() -> Void)?
    
    func configureHierarchy(){
        view.addSubview(categoryTitleTextField)
        view.addSubview(titleSeparatorLine)
        view.addSubview(categoryDescriptionTextField)
        view.addSubview(descriptionSeparatorLine)
        view.addSubview(addButton)
    }
    
    func configureLayout(){
        categoryTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.horizontalEdges.equalTo(view).inset(20)
            make.height.equalTo(44)
        }
        
        titleSeparatorLine.snp.makeConstraints { make in
            make.top.equalTo(categoryTitleTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view).inset(20)
            make.height.equalTo(0.5)
        }
        
        categoryDescriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(titleSeparatorLine.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(view).inset(20)
            make.height.equalTo(44)
        }
        
        descriptionSeparatorLine.snp.makeConstraints { make in
            make.top.equalTo(categoryDescriptionTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view).inset(20)
            make.height.equalTo(0.5)
        }
        
        addButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(44)
        }
    }
    
    @objc
    func addButtonTapped(){
        let repository = CartRepository()
        guard let name = categoryTitleTextField.text,
              let description = categoryDescriptionTextField.text else { return }
        let category = Category(name: name, categoryDescription: description)
        repository.createCategory(category)
        saveCategory?()
        dismiss(animated: true)
    }
}
