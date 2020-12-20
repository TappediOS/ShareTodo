//
//  OnBoardingViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/12/15.
//  Copyright © 2020 jun. All rights reserved.
//

protocol OnBoardingModelProtocol {
    var presenter: OnBoardingModelOutput! { get set }
}

protocol OnBoardingModelOutput: class {
    
}

final class OnBoardingModel: OnBoardingModelProtocol {
    weak var presenter: OnBoardingModelOutput!
}
