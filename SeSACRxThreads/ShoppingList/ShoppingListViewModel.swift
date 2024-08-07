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

struct ShoppingLists {
    private init(){}
    
    static var lists = [
        ShoppingItem(isCheck: false, title: "탕후루사기", isLike: false),
        ShoppingItem(isCheck: true, title: "화장품 사기", isLike: true),
        ShoppingItem(isCheck: false, title: "아이스 아메리카노 사기", isLike: true),
        ShoppingItem(isCheck: false, title: "키보드 구입", isLike: false),
        ShoppingItem(isCheck: true, title: "마우스 구입", isLike: false)
    ]
}

struct SearchLists {
    private init(){}
    
    static var lists = ["키보드", "손풍기", "컵", "마우스패드", "샌들"]
}



class ShoppingListViewModel {
    let disposeBag = DisposeBag()
    let searchItems = BehaviorRelay<[String]>(value: SearchLists.lists)
    
    struct Input {
        let viewDidAppear: Observable<Void>
        let searchText: ControlProperty<String>
        let tableViewModelSelected: ControlEvent<ShoppingListTableViewCellViewModel>
        let collectionViewModelSelected: ControlEvent<String>
        let addButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let shoppingItems: BehaviorRelay<[ShoppingListTableViewCellViewModel]>
        let tableViewModelSelected: ControlEvent<ShoppingListTableViewCellViewModel>
        let searchItems: BehaviorRelay<[String]>
    }
    
    func transform(input: Input) -> Output {
        let shoppingItems = BehaviorRelay<[ShoppingListTableViewCellViewModel]>(value: [])
        
        input.viewDidAppear
            .bind(with: self){ owner, _ in
                let viewModels = ShoppingLists.lists.map { ShoppingListTableViewCellViewModel($0) }
                shoppingItems.accept(viewModels)
            }
            .disposed(by: disposeBag)
        
        
        //filtering
        input.searchText
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                if !text.isEmpty {
                    let filteredList = ShoppingLists.lists.filter { $0.title.contains(text) }
                    let viewModels = filteredList.map { ShoppingListTableViewCellViewModel($0) }
                    shoppingItems.accept(viewModels)
                } else {
                    let viewModels = ShoppingLists.lists.map { ShoppingListTableViewCellViewModel($0) }
                    
                    shoppingItems.accept(viewModels)
                }
            }
            .disposed(by: disposeBag)
        
        input.addButtonTap
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .debug()
            .bind(with: self){ owner, text in
                let filteredList = ShoppingLists.lists.filter { $0.title == text }
                if !text.isEmpty && filteredList.count == 0 {
                    ShoppingLists.lists.append(ShoppingItem(isCheck: false, title: text, isLike: false))
                    
                    let viewModels = ShoppingLists.lists.map { ShoppingListTableViewCellViewModel($0) }
                                    shoppingItems.accept(viewModels)
                }
            }
            .disposed(by: disposeBag)
        
        input.collectionViewModelSelected
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                if ShoppingLists.lists.filter({ $0.title == text }).count == 0 {
                    ShoppingLists.lists.append(ShoppingItem(isCheck: false, title: text, isLike: false))
                    
                    let viewModels = ShoppingLists.lists.map { ShoppingListTableViewCellViewModel($0) }
                                    shoppingItems.accept(viewModels)
                }
            }
            .disposed(by: disposeBag)
        
            
        
        return Output(shoppingItems: shoppingItems, tableViewModelSelected: input.tableViewModelSelected, searchItems: searchItems)
    }
}
