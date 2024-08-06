//
//  SearchView.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/5/24.
//

import UIKit
import SnapKit

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
