//
//  SearchResults.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import Foundation
import SwiftyUserDefaults

class SearchResults {
    
    static var shared = SearchResults()
    
    private init(){}
    
    var list: [String] {
        get {
            return Defaults.currentSearchList
        }
        
        set {
            Defaults.currentSearchList = newValue
        }
    }
    
    func saveItem(_ text: String){
        if list.contains(text){
            while let index = list.firstIndex(of: text) {
                list.remove(at: index)
            }
        }
        list.insert(text, at: 0)
    }
    
    func deleteItem(_ index: Int){
        list.remove(at: index)
    }
    
    func deleteAll(){
        list = []
    }
}
