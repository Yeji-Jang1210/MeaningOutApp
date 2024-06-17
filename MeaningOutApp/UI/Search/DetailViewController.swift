//
//  DetailViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import WebKit
import SnapKit
import Toast

class DetailViewController: BaseVC {
    
    //MARK: - object
    let webView: WKWebView = {
        let object = WKWebView()
        return object
    }()
    
    let rightBarButtonItem: UIBarButtonItem = {
        let object = UIBarButtonItem()
        object.tintColor = .clear
        return object
    }()
    
    //MARK: - properties
    var url: String = ""
    var productId: String = ""
    var isSelected: Bool = false {
        didSet {
            print(isSelected)
            rightBarButtonItem.image = isSelected ? ImageAssets.like_selected.image :  ImageAssets.like_unselected.image
        }
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        loadWebLink()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.reload()
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        view.addSubview(webView)
    }
    
    private func configureLayout(){
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI(){
        configureNavigationBar()
        rightBarButtonItem.isSelected = User.cartList.contains(productId)
    }
    
    private func configureNavigationBar(){
        navigationItem.rightBarButtonItem = rightBarButtonItem
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(likeButtonTapped)
        isSelected = User.cartList.contains(productId)
    }
    
    //MARK: - function
    private func loadWebLink(){
        print(url)
        guard let url = URL(string: url) else { return }
        webView.load(URLRequest(url: url))
    }
    
    @objc func likeButtonTapped(_ sender: UIBarButtonItem){
        isSelected.toggle()
        if isSelected {
            print("append")
            User.cartList.append(productId)
        } else {
            print("delete")
            User.cartList.removeAll { $0 == productId }
        }
        print(User.cartList)
        
        view.makeToast(isSelected ? Localized.like_select_message.message : Localized.like_unselect_message.message)
    }
    
    public func setData(url: String, id: String){
        self.url = url
        productId = id
    }
}
