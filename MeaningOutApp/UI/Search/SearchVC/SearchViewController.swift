//
//  SearchViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import Alamofire
import SnapKit

class SearchViewController: BaseVC {
    //MARK: - object
    let searchController: UISearchController = {
        let object = UISearchController(searchResultsController: nil)
        object.searchBar.placeholder = Localized.searchBar_placeholder.text
        object.searchBar.tintColor = Color.primaryOrange
        object.hidesNavigationBarDuringPresentation = false
        return object
    }()
    
    let headerView: UIView = {
        let object = UIView()
        return object
    }()
    
    
    let tableView: UITableView = {
        let object = UITableView()
        object.backgroundColor = .clear
        object.separatorStyle = .none
        return object
    }()
    
    let emptyView: UIView = {
        let object = UIView()
        return object
    }()
    
    let emptyImageView: UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        object.image = ImageAssets.empty
        return object
    }()
    
    let emptyLabel: UILabel = {
        let object = UILabel()
        object.text = Localized.empty.text
        object.textAlignment = .center
        object.font = BaseFont.large.boldFont
        object.textColor = Color.black
        return object
    }()
    
    //Header View
    let headerLabel: UILabel = {
        let object = UILabel()
        object.text = Localized.current_search.text
        object.font = BaseFont.large.boldFont
        return object
    }()
    
    let headerButton: UIButton = {
        let object = UIButton(type: .system)
        object.setTitle(Localized.delete_all.text, for: .normal)
        object.setTitleColor(Color.primaryOrange, for: .normal)
        return object
    }()
    
    //MARK: - properties
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = Localized.search_tab_nav.title
        reloadTableView()
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(tableView)
        view.addSubview(emptyView)
        view.addSubview(headerView)
        
        emptyView.addSubview(emptyImageView)
        emptyView.addSubview(emptyLabel)
        
        headerView.addSubview(headerLabel)
        headerView.addSubview(headerButton)
    }
    
    override func configureLayout(){
        
        headerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(tableView.snp.edges)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(emptyImageView.snp.width)
            make.centerY.equalToSuperview().multipliedBy(0.8)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(emptyImageView.snp.bottom).offset(-20)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        headerButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func configureUI(){
        configureTableView()
        configureNavigationBar()
    }
    
    private func configureNavigationBar(){
        navigationItem.scrollEdgeAppearance = UINavigationBarAppearance()
        navigationItem.scrollEdgeAppearance?.backgroundColor = Color.white
        navigationItem.scrollEdgeAppearance?.shadowColor = Color.darkGray
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView(){
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchItemCell.self, forCellReuseIdentifier: SearchItemCell.identifier)
    }
    
    //MARK: - function
    private func bindAction(){
        headerButton.addTarget(self, action: #selector(deleteListAll), for: .touchUpInside)
    }
    
    private func checkIsTableViewEmpty(){
        tableView.isHidden = SearchResults.shared.list.isEmpty
        emptyView.isHidden = !SearchResults.shared.list.isEmpty
        headerView.isHidden = SearchResults.shared.list.isEmpty
    }
    
    private func reloadTableView(){
        checkIsTableViewEmpty()
        tableView.reloadData()
    }
    
    @objc func deleteItem(_ sender: UIButton){
        SearchResults.shared.deleteItem(sender.tag)
        reloadTableView()
    }
    
    @objc func deleteListAll(){
        SearchResults.shared.deleteAll()
        reloadTableView()
    }
    
    func searchItem(text: String){
        SearchResults.shared.saveItem(text)
        reloadTableView()
        
        let vc = MeaningOutListViewController(title: text, isChild: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchResults.shared.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchItemCell.identifier, for: indexPath) as! SearchItemCell
        cell.titleLabel.text = SearchResults.shared.list[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchItem(text: SearchResults.shared.list[indexPath.row])
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = nil
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text ,!text.isEmpty{
            searchItem(text: text)
        }
    }
}
