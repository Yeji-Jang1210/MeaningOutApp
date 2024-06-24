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
    let tableView: UITableView = {
        let object = UITableView()
        return object
    }()
    
    let headerView: SettingHeaderView = {
        let object = SettingHeaderView()
        return object
    }()
    
    //MARK: - properties
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        bindAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        headerView.setData()
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        view.addSubview(headerView)
        view.addSubview(tableView)
    }
    
    private func configureLayout(){
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI(){
        configureTableView()
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
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
            cell.setCartList(attributes: User.cartListText)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 4 {
            return indexPath
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentAlert(localized: Localized.deleteAccount_dlg) {
            User.delete()
            let nvc = UINavigationController(rootViewController: OnboardingViewController())
            self.changeRootViewController(nvc)
        } cancel: {
            
        }
    }
}
