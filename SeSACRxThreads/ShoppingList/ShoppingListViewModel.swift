//
//  ShoppingListViewModel.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

struct ShoppingItem {
    var isCheck: Bool
    let title: String
    var isLike: Bool
}

let shoppingLists = [
    ShoppingItem(isCheck: false, title: "탕후루사기", isLike: false),
    ShoppingItem(isCheck: true, title: "화장품 사기", isLike: true),
    ShoppingItem(isCheck: false, title: "아이스 아메리카노 사기", isLike: true),
    ShoppingItem(isCheck: false, title: "키보드 구입", isLike: false),
    ShoppingItem(isCheck: true, title: "마우스 구입", isLike: false)
]

class ShoppingListViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidAppear: Observable<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let items: BehaviorRelay<[ShoppingListTableViewCellViewModel]>
    }
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[ShoppingListTableViewCellViewModel]>(value: [])
        
        input.viewDidAppear
            .bind(with: self){ owner, _ in
                var viewModels:[ShoppingListTableViewCellViewModel] = []
                
                for item in shoppingLists {
                    viewModels.append(ShoppingListTableViewCellViewModel(item))
                }
                
                elements.accept(viewModels)
            }
            .disposed(by: disposeBag)

//        input.searchText
//            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .bind(with: self) { owner, text in
//                 
//            }
//            .disposed(by: disposeBag)
        
        
        
        return Output(items: elements)
    }
}
