//
//  AddCategoryViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/9/24.
//

import UIKit
import SnapKit

class AddCategoryViewController: UIViewController {
    
    let addButton: BaseButton = {
        let object = BaseButton(style: .primary)
        object.setTitle(Localized.save_button.title, for: .normal)
        return object
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy(){
        view.addSubview(addButton)
    }
    
    func configureLayout(){
        addButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(44)
        }
    }
    
    func configureUI(){
        
    }
}
