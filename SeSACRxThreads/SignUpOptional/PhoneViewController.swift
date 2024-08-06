//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PhoneViewController: UIViewController {
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let viewModel = PhoneViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
    
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
        
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(phoneTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func bind(){
        
        let input = PhoneViewModel.Input(phoneNumber: phoneTextField.rx.text.orEmpty, nextButtonTap: nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.phoneNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
           
        output.isValid
            .asDriver()
            .drive(nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isValid
            .asDriver()
            .drive(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        output.validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
        }
        .disposed(by: disposeBag)
        
    }
}
