//
//  DetailViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import WebKit

import Lottie
import SnapKit
import Toast

class DetailViewController: BaseVC {
    
    //MARK: - object
    let webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        
        let object = WKWebView(frame: .zero, configuration: configuration)
        return object
    }()
    
    let rightBarButtonItem: UIBarButtonItem = {
        let object = UIBarButtonItem()
        object.tintColor = .clear
        return object
    }()
    
    let container: UIView = {
        let object = UIView()
        object.isHidden = true
        object.backgroundColor = .white.withAlphaComponent(0.4)
        return object
    }()
    
    let loadingAnimationView: LottieAnimationView = {
        let object = LottieAnimationView(name: "loading")
        object.loopMode = .loop
        return object
    }()
    
    //MARK: - properties
    var repository = CartRepository()
    var url: String = ""
    var product: Product?
    var isSelected: Bool = false {
        didSet {
            rightBarButtonItem.image = isSelected ? ImageAssets.like_selected :  ImageAssets.like_unselected
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                container.isHidden = false
                loadingAnimationView.play()
            } else {
                loadingAnimationView.stop()
                container.isHidden = true
            }
        }
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebLink()
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(webView)
        view.addSubview(container)
        
        container.addSubview(loadingAnimationView)
    }
    
    override func configureLayout(){
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingAnimationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(loadingAnimationView.snp.width)
        }
    }
    
    override func configureUI(){
        configureNavigationBar()
        webView.navigationDelegate = self
    }
    
    private func configureNavigationBar(){
        navigationItem.rightBarButtonItem = rightBarButtonItem
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(likeButtonTapped)
        if let id = product?.productId {
            isSelected = repository.findProductId(productId: id)
        }
    }
    
    //MARK: - function
    private func loadWebLink(){
        guard let url = URL(string: url) else { return }
        self.webView.load(URLRequest(url: url))
    }
    
    @objc func likeButtonTapped(_ sender: UIBarButtonItem){
        isSelected.toggle()
        
        if let product = product {
            let item = CartItem(product)
            if isSelected {
                print("append")
                
                repository.addItem(item: item)
                
            } else {
                print("delete")
                repository.deleteItemForId(productId: product.productId)
            }
            
            view.makeToast(isSelected ? Localized.like_select_message.message : Localized.like_unselect_message.message)
        }
    }
    
    public func setData(url: String, product: Product){
        self.url = url
        self.product = product
    }
}

extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        isLoading = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isLoading = false
    }
}
