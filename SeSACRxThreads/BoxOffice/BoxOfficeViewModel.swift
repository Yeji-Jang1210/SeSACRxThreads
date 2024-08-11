//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
    let disposeBag = DisposeBag()

    private var recentList = ["테스트1", "테스트2", "테스트3", "테스트4"]
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let recentText: PublishSubject<String>
    }
    
    struct Output {
        let movieList: PublishSubject<[DailyBoxOfficeList]>
        let recentList: BehaviorSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let recentList = BehaviorSubject(value: recentList)
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        input.recentText
            .subscribe(with: self){ owner, text in
                owner.recentList.append(text)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map {
                guard let intText = Int($0) else {
                    return 20240806
                }
                return intText
            }
            .map { return "\($0)" }
            .flatMap {
                NetworkManager.shared.networking(date: $0)
            }
            .subscribe(onNext: { movie in
                boxOfficeList.onNext(movie.boxOfficeResult.dailyBoxOfficeList)
            }, onError: { error in
                print(error)
            }, onCompleted: {
                print("completed")
            })
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self){ owner, value in
                print("뷰모델 글자 인식 \(value)")
            }
            .disposed(by: disposeBag)
        
        return Output(movieList: boxOfficeList, recentList: recentList)
    }
}

