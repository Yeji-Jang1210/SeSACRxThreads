//
//  ShoppingListTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/5/24.
//

import UIKit
import SnapKit

final class ShoppingListTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: ShoppingListTableViewCell.self)
    
    let backView = {
        let object = UIView()
        object.backgroundColor = .systemGray6
        object.clipsToBounds = true
        object.layer.cornerRadius = 12
        return object
    }()
    
    let checkButton = {
        let object = UIButton()
        object.tintColor = .black
        object.setImage(UIImage(systemName: "star.fill"), for: .selected)
        object.setImage(UIImage(systemName: "star"), for: .normal)
        return object
    }()
    
    let titleLabel = UILabel()
    
    let likeButton = {
        let object = UIButton()
        object.tintColor = .black
        object.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        object.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy(){
        contentView.addSubview(backView)
        backView.addSubview(checkButton)
        backView.addSubview(titleLabel)
        backView.addSubview(likeButton)
    }
    
    private func configureLayout(){
        backView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(24)
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(likeButton.snp.leading).offset(-20)
        }
    }
}

