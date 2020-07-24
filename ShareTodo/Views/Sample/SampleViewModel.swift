//
//  SampleViewModel.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

protocol SampleModelProtocol {
    var presenter: SampleModelOutput! { get set }
}

protocol SampleModelOutput: class {
    
}

final class SampleModel: SampleModelProtocol {
    weak var presenter: SampleModelOutput!
}
