//
//  BoxOfficeViewController.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum LottoError: Error {
    case isNumberGreaterThan45
    
    var message: String {
        switch self {
        case .isNumberGreaterThan45:
            return "45를 초과하는 숫자가 나왔습니다."
        }
    }
}

class BoxOfficeViewController: UIViewController {
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 80
        view.separatorStyle = .none
       return view
     }()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: BoxOfficeViewController.layout())
    let searchBar = UISearchBar()
    
    let viewModel = BoxOfficeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    func createObservable(){
        let random = Observable<Int>.create { value in
            let result = Int.random(in: 1...100)
            
            if result > 45 {
                value.onError(LottoError.isNumberGreaterThan45)
            } else {
                value.onNext(result)
            }
            
            return Disposables.create()
        }
        
        random.subscribe(with: self) { owner, value in
            print(value)
        } onError: { owner, error in
            if let error = error as? LottoError {
                print(error.message)
            }
        } onCompleted: { owner in
            print("Completed")
        } onDisposed: { owner in
            print("Disposed")
        }
        .dispose()
    }
    
    func bind(){
        let recentText = PublishSubject<String>()
        
        let input = BoxOfficeViewModel.Input(searchButtonTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty, recentText: recentText)
        
        let output = viewModel.transform(input: input)
        
        output.movieList
            .bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)){ row, element, cell in
                cell.appNameLabel.text = element.movieNm
            }
            .disposed(by: disposeBag)
        
        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)){ row, element, cell in
                cell.label.text = element
            }
            .disposed(by: disposeBag)
                
        //기능을 합쳐서 쓰고싶은 경우
        Observable.zip(tableView.rx.modelSelected(DailyBoxOfficeList.self), tableView.rx.itemSelected)
            .debug()
            .map{ $0.0.movieNm }
            .subscribe(with: self){ owner, value in
                recentText.onNext(value)
            }
            .disposed(by: disposeBag)
    }
    
    func configure(){
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(collectionView)
        navigationItem.titleView = searchBar
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.backgroundColor = .systemGray6
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}
