//
//  UIViewController+Extension.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit

extension UIViewController {
    func changeRootViewController(_ vc: UIViewController){
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        //entry point
        sceneDelegate?.window?.rootViewController = vc
        
        //show
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
