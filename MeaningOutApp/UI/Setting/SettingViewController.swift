//
//  SettingViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import SnapKit
import SwiftyUserDefaults

class SettingViewController: BaseVC {
    //MARK: - object
    lazy var tableView: UITableView = {
        let object = UITableView()
        object.delegate = self
        object.dataSource = self
        object.alwaysBounceVertical = false
        object.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        return object
    }()
    
    let headerView: SettingHeaderView = {
        let object = SettingHeaderView()
        return object
    }()
    
    //MARK: - properties
    let repository = CartRepository()
    
    var cartListText: NSMutableAttributedString {
        let boldString = "\(repository.fetch().count)개"
        let fullString = boldString + "의 상품"
        
        let attributedString = NSMutableAttributedString(string: fullString)
        let boldFontAttribute: [NSAttributedString.Key: Any] = [.font: BaseFont.medium.boldFont]
        
        if let boldRange = fullString.range(of: boldString){
            let nsRange = NSRange(boldRange, in: fullString)
            
            attributedString.addAttributes(boldFontAttribute, range: nsRange)
        }
        
        return attributedString
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        headerView.setData()
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(headerView)
        view.addSubview(tableView)
    }
    
    override func configureLayout(){
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    //MARK: - function
    private func bindAction(){
        headerView.editSettingButton.addTarget(self, action: #selector(editSettingButtonTapped), for: .touchUpInside)
    }
    
    @objc func editSettingButtonTapped(){
        let vc = ProfileSettingViewController(type: .edit)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension SettingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        cell.settingLabel.text = SettingType.allCases[indexPath.row].title
        
        if SettingType(rawValue: indexPath.row) == .cartList {
            cell.setCartList(attributes: cartListText)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 4 || indexPath.row == 0 {
            return indexPath
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(CartCategoryViewController(title: Localized.usersCartList.title, isChild: true), animated: true)
        case 4:
            presentAlert(localized: Localized.deleteAccount_dlg) {
                User.shared.delete()
                let repository = CartRepository()
                repository.deleteAll()
                let nvc = UINavigationController(rootViewController: OnboardingViewController())
                self.changeRootViewController(nvc)
            } cancel: {
                
            }
        default:
            return
        }
    }
}
