//
//  ShoppingListViewController.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/5/24.
//

import UIKit
import SnapKit

import RxSwift
import RxDataSources
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
        let object = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout())
        object.register(SearchItemCollectionViewCell.self, forCellWithReuseIdentifier: SearchItemCollectionViewCell.identifier)
        return object
    }()
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SearchResultSectionModel>(
        configureCell: { dataSource, tableView, indexPath, item in
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.identifier, for: indexPath) as! SearchItemCollectionViewCell
            cell.titleLabel.text = item
            return cell
        })
    
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
            .asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    private func compositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(40))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}


