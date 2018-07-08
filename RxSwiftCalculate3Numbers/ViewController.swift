//
//  ViewController.swift
//  RxSwiftCalculate3Numbers
//
//  Created by killi8n on 2018. 7. 8..
//  Copyright © 2018년 killi8n. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var disposeBag: DisposeBag = DisposeBag()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Calc 3 Numbers reactively"
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        return label
    }()
    
    let inputA: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.keyboardType = UIKeyboardType.numberPad
        return tf
    }()
    
    let inputB: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.keyboardType = UIKeyboardType.numberPad
        return tf
    }()
    
    let inputC: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.keyboardType = UIKeyboardType.numberPad
        return tf
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.gray
        label.textAlignment = .center
        
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        calculate()
        
        
    }


}

extension ViewController {
    func setupViews() {
        self.view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(inputA)
        self.view.addSubview(inputB)
        self.view.addSubview(inputC)
        
        inputA.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputA.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20).isActive = true
        inputA.widthAnchor.constraint(equalToConstant: self.view.frame.size.width * 0.9).isActive = true
        inputB.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputB.topAnchor.constraint(equalTo: self.inputA.bottomAnchor, constant: 20).isActive = true
        inputB.widthAnchor.constraint(equalToConstant: self.view.frame.size.width * 0.9).isActive = true
        inputC.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputC.topAnchor.constraint(equalTo: self.inputB.bottomAnchor, constant: 20).isActive = true
        inputC.widthAnchor.constraint(equalToConstant: self.view.frame.size.width * 0.9).isActive = true

        self.view.addSubview(resultLabel)
        
        resultLabel.topAnchor.constraint(equalTo: self.inputC.bottomAnchor, constant: 20).isActive = true
        resultLabel.widthAnchor.constraint(equalTo: self.inputA.widthAnchor).isActive = true
        resultLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    func calculate() {
        let textToNumber: (String?) -> Observable<Int> = {
            (text) -> Observable<Int> in
            guard let text = text, let value = Int(text) else {
                return Observable<Int>.just(0)
            }
            return Observable<Int>.just(value)
        }
        
        let inputAObservable = self.inputA.rx.text.asObservable().flatMap(textToNumber)
        let inputBObservable = self.inputB.rx.text.asObservable().flatMap(textToNumber)
        let inputCObservable = self.inputC.rx.text.asObservable().flatMap(textToNumber)
        
        Observable.combineLatest([inputAObservable, inputBObservable, inputCObservable]) { (values) -> Int in
            return values.reduce(0, +)
            }.map {
                "\($0)"
            }.subscribe { [weak self] (event) in
                switch event {
                case .next(let value):
                    self?.resultLabel.text = value
                default:
                    break
                }
        }.disposed(by: disposeBag)
    }
}



