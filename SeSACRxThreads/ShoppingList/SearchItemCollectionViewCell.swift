//
//  SearchItemCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/7/24.
//

import UIKit

import RxSwift
import RxCocoa

class SearchItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ShoppingListCollectionViewCell"
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
