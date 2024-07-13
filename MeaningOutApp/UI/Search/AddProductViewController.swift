//
//  AddProductViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/13/24.
//

import UIKit
import SnapKit

final class AddProductViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let object = UITableView()
        object.backgroundColor = .clear
        object.separatorStyle = .none
        object.register(AddProductTableViewCell.self, forCellReuseIdentifier: AddProductTableViewCell.identifier)
        object.delegate = self
        object.dataSource = self
        return object
    }()
    
    let repository = CartRepository()
    lazy var categoryList = repository.fetchCategory()
    var passIndex: ((Int?) -> Void)?
    var selectIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        passIndex?(selectIndex)
    }
    
    func configureHierarchy(){
        view.addSubview(tableView)
    }
    
    func configureLayout(){
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension AddProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Localized.category.title
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddProductTableViewCell.identifier, for: indexPath) as! AddProductTableViewCell
        cell.setData(categoryList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        
        dismiss(animated: true)
    }
}
