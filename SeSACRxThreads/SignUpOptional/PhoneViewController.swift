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
    
    let phoneNumber = BehaviorRelay(value: "010")
    let validText = BehaviorRelay(value: "")
    let isValidation = BehaviorRelay(value: false)
    
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
        phoneNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty
            .bind(with: self) { owner, text in
                let phoneNumber = text.replacingOccurrences(of: "-", with: "")
                print(phoneNumber)
                if Int(phoneNumber) == nil {
                    owner.validText.accept("숫자만 입력해주세요.")
                    owner.isValidation.accept(false)
                    return
                } else {
                    owner.phoneNumber.accept(owner.format(phoneNumber: phoneNumber))
                }
                
                if text.count < 10 {
                    owner.validText.accept("10자리 이상 입력해주세요.")
                    owner.isValidation.accept(false)
                    return
                }
                
                return owner.isValidation.accept(true)
            }
            .disposed(by: disposeBag)
        
        isValidation
            .bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        isValidation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
        }
        .disposed(by: disposeBag)
        
    }
    
    private func format(phoneNumber: String) -> String {
        var formatted = ""
        let length = phoneNumber.count
        
        if length > 0 {
            formatted += String(phoneNumber.prefix(3))
        }
        if length > 3 {
            let start = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
            let end = phoneNumber.index(phoneNumber.startIndex, offsetBy: min(7, length))
            formatted += "-" + phoneNumber[start..<end]
        }
        if length > 7 {
            let start = phoneNumber.index(phoneNumber.startIndex, offsetBy: 7)
            formatted += "-" + phoneNumber[start...]
        }
        
        return formatted
    }
    
}
