//
//  SearchViewModel.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/10/24.
//

import Foundation

enum SearchResultAction {
    case searchForText(_ text: String)
    case delete(_ index: Int)
    case deleteAll
    case searchForIndex(_ index: Int)
}

final class SearchViewModel {
    var inputSearchList = Observable<[String]>(SearchResults.shared.list)
    var inputSearchResultTrigger = Observable<SearchResultAction?>(nil)
    
    var outputSearchList = Observable<[String]>([])
    var outputListisEmpty = Observable<Bool?>(nil)
    var outputSelectedCellTrigger = Observable<String?>(nil)
    
    init(){
        bind()
    }
    
    private func bind(){
        inputSearchList.bind { list in
            self.outputSearchList.value = list
            self.outputListisEmpty.value = list.isEmpty
        }
        
        inputSearchResultTrigger.bind { action in
            guard let action else { return }
            
            switch action {
            case .searchForText(let text):
                SearchResults.shared.saveItem(text)
                self.outputSelectedCellTrigger.value = text
            case .delete(let index):
                SearchResults.shared.deleteItem(index)
            case .deleteAll:
                SearchResults.shared.deleteAll()
            case .searchForIndex(let index):
                let selectText = self.outputSearchList.value[index]
                SearchResults.shared.saveItem(selectText)
                self.outputSelectedCellTrigger.value = selectText
            }
            
            self.inputSearchList.value = SearchResults.shared.list
        }
    }
}
