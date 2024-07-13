//
//  ProductWebViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import WebKit

import Lottie
import SnapKit
import Toast

class ProductWebViewController: BaseVC {
    
    //MARK: - object
    let webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        
        let object = WKWebView(frame: .zero, configuration: configuration)
        return object
    }()
    
    let rightBarButtonItem: UIBarButtonItem = {
        let object = UIBarButtonItem()
        object.tintColor = .clear
        object.isSelected = false
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
    var viewModel: ProductWebViewModel!
    
    //MARK: - life cycle
    init(title: String = "", isChild: Bool = false, url: String, product: Product) {
        super.init(title: title, isChild: isChild)
        viewModel = ProductWebViewModel(url: url, product: product)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputLoadWebLinkTrigger.value = ()
        viewModel.inputFindProductTrigger.value = ()
        bindAction()
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
    }
    
    private func bindAction(){
        viewModel.outputIsSelected.bind { isSelected in
            guard let isSelected else { return }
            
            self.rightBarButtonItem.isSelected = isSelected
            self.rightBarButtonItem.image = isSelected ? ImageAssets.like_selected :  ImageAssets.like_unselected
        }
        
        viewModel.outputPresentCategoryVC.bind { present in
            guard let present else { return }
            
            let vc = AddProductViewController()
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            
            vc.passIndex = { category in
                self.viewModel.inputAddProductTrigger.value = category
            }
            self.present(vc, animated: true)
        }
        
        viewModel.outputPresentToast.bind { isSelected in
            guard let isSelected else { return }
            
            DispatchQueue.main.async {
                self.view.makeToast(isSelected ? Localized.like_select_message.message : Localized.like_unselect_message.message)
            }
        }
        
        viewModel.outputWebLink.bind { url in
            guard let url else { return }
            print(url)
            self.webView.load(URLRequest(url: url))
        }
        
        viewModel.outputIsLoading.bind { [self] isLoading in
            guard let isLoading else { return }
            
            if isLoading {
                self.container.isHidden = false
                self.loadingAnimationView.play()
            } else {
                self.loadingAnimationView.stop()
                container.isHidden = true
            }
        }
    }
    
    //MARK: - function
    @objc func likeButtonTapped(_ sender: UIBarButtonItem){
        //sender.isSelected.toggle()
        viewModel.inputIsSelected.value = !sender.isSelected
    }
    
    public func setData(url: String, product: Product){
        self.viewModel.url = url
        self.viewModel.product = product
    }
}

extension ProductWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        viewModel.outputIsLoading.value = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.outputIsLoading.value = false
    }
}
