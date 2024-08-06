//
//  PasswordViewModel.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let password: ControlProperty<String>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let validText: BehaviorRelay<String>
        let isValid: BehaviorRelay<Bool>
        let nextButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let validText = BehaviorRelay(value: "8자리 이상 입력해 주세요")
        let isValid = BehaviorRelay(value: false)
        
        input.password
            .bind {
                isValid.accept($0.count >= 8)
            }
            .disposed(by: disposeBag)
        
        return Output(validText: validText, isValid: isValid, nextButtonTap: input.nextButtonTap)
    }
}
