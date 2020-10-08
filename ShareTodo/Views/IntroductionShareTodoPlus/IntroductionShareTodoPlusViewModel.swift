//
//  IntroductionShareTodoPlusViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/09/26.
//  Copyright © 2020 jun. All rights reserved.
//

protocol IntroductionShareTodoPlusModelProtocol {
    var presenter: IntroductionShareTodoPlusModelOutput! { get set }
}

protocol IntroductionShareTodoPlusModelOutput: class {
    
}

final class IntroductionShareTodoPlusModel: IntroductionShareTodoPlusModelProtocol {
    weak var presenter: IntroductionShareTodoPlusModelOutput!
}

