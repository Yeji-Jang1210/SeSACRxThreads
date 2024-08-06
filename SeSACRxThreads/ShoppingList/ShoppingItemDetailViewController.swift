//
//  ShoppingItemDetailViewController.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingItemDetailViewController: UIViewController {
    
    init(title: String){
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}
