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
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        
    }
    
    private func configureLayout(){
        
    }
    
    private func configureUI(){
        
    }
    //MARK: - function
    
}
