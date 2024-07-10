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
    let viewModel = SettingViewModel()
    
    var cartListText: NSMutableAttributedString!
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.editSettingButton.addTarget(self, action: #selector(editSettingButtonTapped), for: .touchUpInside)
        bindAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        headerView.setData()
        viewModel.inputRefreshCartListCountTrigger.value = ()
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
        viewModel.outputCartListText.bind { boldString, fullString in
            let attributedString = NSMutableAttributedString(string: fullString)
            let boldFontAttribute: [NSAttributedString.Key: Any] = [.font: BaseFont.medium.boldFont]
            
            if let boldRange = fullString.range(of: boldString){
                let nsRange = NSRange(boldRange, in: fullString)
                
                attributedString.addAttributes(boldFontAttribute, range: nsRange)
            }
            
            self.cartListText = attributedString
            
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
        
        viewModel.outputSelectSettingType.bind { type in
            guard let type else { return }
            switch type {
            case .cartList:
                self.navigationController?.pushViewController(CartCategoryViewController(title: Localized.usersCartList.title, isChild: true), animated: true)
            case .deleteAccount:
                self.presentDeleteAlert()
            default:
                return
            }
        }
        
        viewModel.outputIsDeleteSucceeded.bind { result in
            guard let result else { return }
            if result {
                let nvc = UINavigationController(rootViewController: OnboardingViewController())
                self.changeRootViewController(nvc)
            }
        }
    }
    
    @objc func editSettingButtonTapped(){
        let vc = ProfileSettingViewController(type: .edit)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentDeleteAlert(){
        self.presentAlert(localized: Localized.deleteAccount_dlg) {
            self.viewModel.inputDeleteAccountTrigger.value = ()
        } cancel: {
            
        }
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
        viewModel.inputSelectSettingType.value = indexPath.row
    }
}
