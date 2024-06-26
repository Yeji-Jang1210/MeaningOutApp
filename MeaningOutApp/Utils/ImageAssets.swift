//
//  ImageAssets.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit

struct ImageAssets {
    
    private init(){}
    
//MARK: systemNamed
    static var search = UIImage(systemName: "magnifyingglass")
    static var person = UIImage(systemName: "person")
    static var leftArrow = UIImage(systemName: "chevron.left")
    static var rightArrow = UIImage(systemName: "chevron.right")
    static var clock = UIImage(systemName: "clock")
    static var xmark = UIImage(systemName: "xmark")
    static var camera = UIImage(systemName: "camera.fill")

//MARK: - Assets
    static var empty = UIImage(named: "empty")
    static var launch = UIImage(named: "launch")
    static var like_selected = UIImage(named: "like_selected")
    static var like_unselected = UIImage(named: "like_unselected")
}
