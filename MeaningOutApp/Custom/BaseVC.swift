//
//  BaseVC.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit

class BaseVC: UIViewController {

//MARK: - property
    private var isChild: Bool = false
  
//MARK: - life cycle
    init(title: String = "", isChild: Bool = false){
        super.init(nibName: nil, bundle: nil)
        self.isChild = isChild
        self.navigationItem.title = title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : Color.black, .font: UIFont.boldSystemFont(ofSize: 16)]
        
        if isChild {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: ImageAssets.leftArrow, style: .done, target: self, action: #selector(dismissButtonTapped))
            navigationItem.leftBarButtonItem?.tintColor = .black
        }
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
//MARK: - configure function
    func configureHierarchy(){ }
    
    func configureLayout(){ }
    
    func configureUI(){ }
    
//MARK: - function
    @objc private func dismissButtonTapped(){
        if isChild {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
}
