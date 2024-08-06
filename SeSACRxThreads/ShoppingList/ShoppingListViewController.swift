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
        view.addSubview(tableView)
        view.addSubview(searchView)
    }
    
    private func configureLayout(){
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(80)
        }
    }
    
    private func bind(){
        let input = ShoppingListViewModel.Input(viewDidAppear: viewDidAppearTrigger, searchText: searchView.searchTextField.rx.text.orEmpty)
        
        let output = viewModel.transform(input: input)
        
//        output.shoppingLists
//            .bind(to: tableView.rx.items){ tableView, row, item in
//                let indexPath = IndexPath(row: row, section: 0)
//                let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingListTableViewCell.identifier, for: indexPath) as! ShoppingListTableViewCell
//                cell.checkButton.isSelected = item.isCheck
//                cell.likeButton.isSelected = item.isLike
//                cell.titleLabel.text = item.title
//                
//                cell.checkButton.rx.tap
//                    .bind {
//                        cell.checkButton.isSelected = !cell.checkButton.isSelected
//                    }
//                    .disposed(by: cell.disposeBag)
//                
//                cell.likeButton.rx.tap
//                    .bind {
//                        cell.likeButton.isSelected = !cell.likeButton.isSelected
//                    }
//                    .disposed(by: cell.disposeBag)
//                
//                return cell
//            }
//            .disposed(by: disposeBag)
        
//        output.tableViewSelected
//            .bind(with: self) { owner, item in
//                let vc = ShoppingItemDetailViewController(title: item.title)
//                owner.navigationController?.pushViewController(vc, animated: true)
//            }
//            .disposed(by: disposeBag)
        
        //item type: viewModel?
        output.items
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.identifier, cellType: ShoppingListTableViewCell.self)) { indexPath, viewModel, cell in
                cell.bind(to: viewModel)
            }
            .disposed(by: disposeBag)
        
    }
}
