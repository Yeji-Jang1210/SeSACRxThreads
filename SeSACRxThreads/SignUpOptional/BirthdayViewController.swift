//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let viewModel = BirthdayViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func bind(){
        
        let input = BirthdayViewModel.Input(nextButtonTap: nextButton.rx.tap, birthday: birthDayPicker.rx.date)
        
        let output = viewModel.transform(input: input)
        
        output.nextButtonTap
            .bind(with: self){ owner, _ in
                owner.navigationController?.pushViewController(SearchViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.yearText
            .map{ "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.monthText
            .map{ "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.dayText
            .map{ "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        output.isValid
            .asDriver()
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isValid
            .asDriver()
            .map{ $0 ? "가입가능한 나이입니다." : "만 17세 이상만 가입이 가능합니다." }
            .drive(infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isValid
            .asDriver()
            .drive(with: self){ owner, isValid in
                owner.nextButton.backgroundColor = isValid ? .blue : .lightGray
                owner.infoLabel.textColor = isValid ? .blue : .red
            }
            .disposed(by: disposeBag)
    }

}
