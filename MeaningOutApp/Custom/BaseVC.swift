//
//  BaseVC.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit

class BaseVC: UIViewController {
    
    private var isChild: Bool = false
    
    init(title: String = "", isChild: Bool = false){
        super.init(nibName: nil, bundle: nil)
        self.isChild = isChild
        self.navigationItem.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : Color.black, .font: UIFont.boldSystemFont(ofSize: 16)]
        
        if isChild {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: ImageAssets.leftArrow.image, style: .done, target: self, action: #selector(dismissButtonTapped))
            navigationItem.leftBarButtonItem?.tintColor = .black
        }
    }
    
//MARK: - function
    @objc private func dismissButtonTapped(){
        if isChild {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
        
    }
}
