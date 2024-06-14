//
//  MeaningOutListViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import Alamofire
import Toast

class MeaningOutListViewController: BaseVC {
    //MARK: - object
    
    //MARK: - properties
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        callAPI()
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        
    }
    
    private func configureLayout(){
        
    }
    
    private func configureUI(){
        
    }
    //MARK: - function
    private func callAPI(){
        let param = APIParameters(query: "고양이")
        APIService.networking(params: param) { networkResult in
            switch networkResult {
            case .success(let data):
                dump(data.items.map{$0.removedHTMLTagTitle})
            case .error(let error):
                print(error)
            }
        }
    }
}
