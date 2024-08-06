//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let nextButtonTap: ControlEvent<Void>
        let birthday: ControlProperty<Date>
    }
    
    struct Output {
        let nextButtonTap: ControlEvent<Void>
        let yearText: PublishRelay<Int>
        let monthText: PublishRelay<Int>
        let dayText: PublishRelay<Int>
        let isValid: BehaviorRelay<Bool>
    }
    
    public func transform(input: Input) -> Output {
        let year = PublishRelay<Int>()
        let month = PublishRelay<Int>()
        let day = PublishRelay<Int>()
        let isValid = BehaviorRelay(value: false)
        
        input.birthday
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.day, .month, .year], from: date)
                
                print(component)
                
                if let age = Calendar.current.dateComponents([.year], from: date, to: Date.now).year {
                    isValid.accept(age >= 17 ? true : false)
                }
                
                year.accept(component.year!)
                month.accept(component.month!)
                day.accept(component.day!)
            }
            .disposed(by: disposeBag)
        
        return Output(nextButtonTap: input.nextButtonTap, yearText: year, monthText: month, dayText: day, isValid: isValid)
        
    }
}
