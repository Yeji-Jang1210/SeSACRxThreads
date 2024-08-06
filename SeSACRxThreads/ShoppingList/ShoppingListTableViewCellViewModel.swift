//
//  ShoppingListTableViewCellViewModel.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingListTableViewCellViewModel {
    

    var item: ShoppingItem
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let likeButtonTap: ControlEvent<Void>
        let checkButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let title: BehaviorRelay<String>
        let isLiked: BehaviorRelay<Bool>
        let isChecked: BehaviorRelay<Bool>
    }
    
    init(_ item: ShoppingItem){
        self.item = item
    }
    
    func transform(input: Input) -> Output {
        let title = BehaviorRelay<String>(value: item.title)
        let isLiked = BehaviorRelay<Bool>(value: item.isLike)
        let isChecked = BehaviorRelay<Bool>(value: item.isCheck)
        
        input.likeButtonTap
            .bind(with: self) { owner, _ in
                owner.item.isLike.toggle()
                isLiked.accept(owner.item.isLike)
            }
            .disposed(by: disposeBag)
        
        input.checkButtonTap
            .bind(with: self) { owner, _ in
                owner.item.isCheck.toggle()
                isChecked.accept(owner.item.isCheck)
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(title: title, isLiked: isLiked, isChecked: isChecked)
    }
    
}
