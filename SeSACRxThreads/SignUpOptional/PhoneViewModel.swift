//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    let disposeBag = DisposeBag()
    
    let phoneNumber = BehaviorRelay(value: "010")
    let validText = BehaviorRelay(value: "")
    let isValidation = BehaviorRelay(value: false)
    
    struct Input {
        let phoneNumber: ControlProperty<String>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let phoneNumber: BehaviorRelay<String>
        let isValid: BehaviorRelay<Bool>
        let validText: PublishRelay<String>
        let nextButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let isValid = BehaviorRelay(value: false)
        let phoneNumber = BehaviorRelay(value: "010")
        let validText = PublishRelay<String>()
        
        input.phoneNumber
            .bind(with: self) { owner, text in
                let text = text.replacingOccurrences(of: "-", with: "")
                
                if Int(text) == nil {
                    validText.accept("숫자만 입력해주세요.")
                    isValid.accept(false)
                    return
                } else {
                    phoneNumber.accept(owner.format(phoneNumber: text))
                }
                
                if text.count < 10 {
                    validText.accept("10자리 이상 입력해주세요.")
                    isValid.accept(false)
                    return
                }
                
                return isValid.accept(true)
            }
            .disposed(by: disposeBag)
        
        return Output(phoneNumber: phoneNumber, isValid: isValid, validText: validText, nextButtonTap: input.nextButtonTap)
    }
    
    private func format(phoneNumber: String) -> String {
        var formatted = ""
        let length = phoneNumber.count
        
        if length > 0 {
            formatted += String(phoneNumber.prefix(3))
        }
        if length > 3 {
            let start = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
            let end = phoneNumber.index(phoneNumber.startIndex, offsetBy: min(7, length))
            formatted += "-" + phoneNumber[start..<end]
        }
        if length > 7 {
            let start = phoneNumber.index(phoneNumber.startIndex, offsetBy: 7)
            formatted += "-" + phoneNumber[start...]
        }
        
        return formatted
    }
}
