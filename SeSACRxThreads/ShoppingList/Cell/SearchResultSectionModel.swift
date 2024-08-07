//
//  SearchResultSectionModel.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/7/24.
//

import Foundation
import RxDataSources

struct SearchResultSectionModel {
    //var header: String
    var items: [String]
    
    init(items: [String]/* , header: String*/){
        //self.header = header
        self.items = items
    }
}

extension SearchResultSectionModel: SectionModelType {
    init(original: SearchResultSectionModel, items: [String]) {
        self = original
        self.items = items
    }
}
