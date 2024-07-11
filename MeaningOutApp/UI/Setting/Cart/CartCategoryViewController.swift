//
//  CartCategoryViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/9/24.
//

import UIKit
import SnapKit

class CartCategoryViewController: BaseVC {
    //MARK: - object
    lazy var tableView: UITableView = {
        let object = UITableView()
        object.backgroundColor = .clear
        object.delegate = self
        object.dataSource = self
        object.register(CategoryListTableViewCell.self, forCellReuseIdentifier: CategoryListTableViewCell.identifier)
        return object
    }()
    
    //MARK: - properties
    let repository = CartRepository()
    lazy var list = repository.fetchCategory()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        super.configureHierarchy()
        view.addSubview(tableView)
    }
    
    override func configureLayout(){
        super.configureLayout()
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI(){
        super.configureUI()
        let barItem = UIBarButtonItem(image: ImageAssets.plus, style: .done, target: self, action: #selector(addCategoryButtonTapped))
        barItem.tintColor = .primaryOrange
        navigationItem.rightBarButtonItem = barItem
    }
    
    @objc 
    func addCategoryButtonTapped(){
        let vc = AddCategoryViewController()
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        self.present(vc, animated: true)
    }
}

extension CartCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListTableViewCell.identifier, for: indexPath) as! CategoryListTableViewCell
        cell.setData(list[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CartViewController(isChild: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}
