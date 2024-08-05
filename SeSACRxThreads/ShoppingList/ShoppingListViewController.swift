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

struct ShoppingItem {
    let isCheck: Bool
    let title: String
    let isLike: Bool
}

let shoppingLists = [
    ShoppingItem(isCheck: false, title: "탕후루사기", isLike: false),
    ShoppingItem(isCheck: true, title: "화장품 사기", isLike: true),
    ShoppingItem(isCheck: false, title: "아이스 아메리카노 사기", isLike: true),
    ShoppingItem(isCheck: false, title: "키보드 구입", isLike: false),
    ShoppingItem(isCheck: true, title: "마우스 구입", isLike: false)
]

class SearchView: UIView {
    
    let searchTextField = {
        let object = UITextField()
        object.placeholder = "무엇을 구매하실건가요?"
        object.backgroundColor = .clear
        return object
    }()
    
    let searchButton = {
        let object = UIButton()
        object.setTitle("추가", for: .normal)
        object.setTitleColor(.black, for: .normal)
        object.backgroundColor = .systemGray4
        object.layer.cornerRadius = 8
        object.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        clipsToBounds = true
        layer.cornerRadius = 12
        
        addSubview(searchTextField)
        addSubview(searchButton)
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-20)
        }
        
        searchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(36)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ShoppingListViewController: UIViewController, UITableViewDelegate {
    let tableView = UITableView()
    let searchView = SearchView()
    
    let list = Observable.just(shoppingLists)
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        configureLayout()
        
        bind()
    }
    
    private func configureHierarchy(){
        view.addSubview(tableView)
        view.addSubview(searchView)
    }
    
    private func configureLayout(){
        tableView.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.identifier)
        tableView.rowHeight = 48
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
        list
        .bind(to: tableView.rx.items){ tableView, row, item in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingListTableViewCell.identifier, for: indexPath) as! ShoppingListTableViewCell
            
            cell.checkButton.isSelected = item.isCheck
            cell.likeButton.isSelected = item.isLike
            cell.titleLabel.text = item.title
            
            return cell
            
        }
        .disposed(by: disposeBag)
    }
}
