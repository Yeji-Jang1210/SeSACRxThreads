//
//  ShoppingListViewController.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/5/24.
//

import UIKit
import SnapKit

import RxSwift
import RxCocoa

class ShoppingListViewController: UIViewController, UITableViewDelegate {
    
    private lazy var tableView = {
        let object = UITableView()
        object.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.identifier)
        object.rowHeight = 48
        return object
    }()
    
    let searchView = SearchView()
    
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.register(SearchItemCollectionViewCell.self, forCellWithReuseIdentifier: SearchItemCollectionViewCell.identifier)
        object.delegate = self
        return object
    }()
    
    let viewDidAppearTrigger = PublishSubject<Void>()
    let viewModel = ShoppingListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        configureLayout()
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewDidAppearTrigger.onNext(())
    }
    
    private func configureHierarchy(){
        view.addSubview(searchView)
        view.addSubview(collectionView)
        view.addSubview(tableView)
    }
    
    private func configureLayout(){
        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(80)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func bind(){
        let input = ShoppingListViewModel.Input(viewDidAppear: viewDidAppearTrigger,
                                                searchText: searchView.searchTextField.rx.text.orEmpty, tableViewModelSelected: tableView.rx.modelSelected(ShoppingListTableViewCellViewModel.self), collectionViewModelSelected: collectionView.rx.modelSelected(String.self),
                                                addButtonTap: searchView.searchButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.tableViewModelSelected
            .bind(with: self) { owner, viewModel in
                let vc = ShoppingItemDetailViewController(title: viewModel.item.title)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.shoppingItems
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.identifier, cellType: ShoppingListTableViewCell.self)) { indexPath, viewModel, cell in
                cell.bind(to: viewModel)
            }
            .disposed(by: disposeBag)
        
        output.searchItems
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: SearchItemCollectionViewCell.identifier, cellType: SearchItemCollectionViewCell.self)){ row, element, cell in
                cell.titleLabel.text = element
            }
            .disposed(by: disposeBag)
        
    }
}

extension ShoppingListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = viewModel.searchItems.value[indexPath.row].calculateTextWidth(size: 12) + 20
        return CGSize(width: width, height: 40)
    }
}

extension String {
    func calculateTextWidth(size: CGFloat) -> CGFloat {
        let itemSize = self.size(withAttributes: [
                    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: size)
                ])
        return itemSize.width
    }
}
