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
    
    //MARK: - properties
    var url: String = ""
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        
        loadWebLink()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.stopLoading()
        webView.navigationDelegate = nil
        webView.removeFromSuperview()
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
    
    //MARK: - function
    private func loadWebLink(){
        print(url)
        guard let url = URL(string: url) else { return }
        webView.load(URLRequest(url: url))
    }
}
