//
//  SearchResults.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import Foundation
import SwiftyUserDefaults

class SearchResults {
    
    private init(){}
    
    static var list: [String] {
        get {
            return Defaults.currentSearchList
        }
        
        set {
            Defaults.currentSearchList = newValue
        }
    }
    
    static func saveItem(_ text: String){
        if list.contains(text){
            while let index = list.firstIndex(of: text) {
                list.remove(at: index)
            }
        }
        list.insert(text, at: 0)
    }
    
    static func deleteItem(_ index: Int){
        list.remove(at: index)
    }
    
    static func deleteAll(){
        list = []
    }
}
