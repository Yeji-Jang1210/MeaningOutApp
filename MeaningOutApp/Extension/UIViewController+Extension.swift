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
    
    func presentAlert(localized: Localized, 
                      confirm: @escaping ()->Void,
                      cancel: @escaping ()->Void){
        let alert = UIAlertController(title: localized.title, message: localized.message, preferredStyle: .alert)
        
        if !localized.confirm.isEmpty {
            let confirmAction = UIAlertAction(title: localized.confirm, style: .default){ _ in
                confirm()
            }
            confirmAction.setValue(Color.primaryOrange, forKey: "titleTextColor")
            alert.addAction(confirmAction)
        }
        
        if !localized.cancel.isEmpty {
            let cancelAction = UIAlertAction(title: localized.cancel, style: .cancel){_ in
                cancel()
            }
            cancelAction.setValue(Color.warmGray, forKey: "titleTextColor")
            alert.addAction(cancelAction)
        }
        
        present(alert, animated: true)
    }
}
