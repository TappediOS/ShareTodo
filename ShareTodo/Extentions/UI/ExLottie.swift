//
//  ExLottie.swift
//  ShareTodo
//
//  Created by jun on 2021/01/17.
//  Copyright © 2021 jun. All rights reserved.
//

import Lottie
import UIKit

public extension AnimationView {
    func getStarAnimationView(stackViewFrame: CGRect, targetViewFrame: CGRect) -> AnimationView {
        let x = stackViewFrame.minX + targetViewFrame.minX
        let y = stackViewFrame.minY + targetViewFrame.minY
        let width = targetViewFrame.width
        let height = targetViewFrame.height
        
        let animationView = AnimationView(name: R.file.lottie_stardustJson.name)
        animationView.frame = CGRect(x: x, y: y, width: width, height: height)
        animationView.transform = CGAffineTransform(scaleX: 2.7, y: 2.7)
        
        animationView.loopMode = .playOnce
        animationView.backgroundBehavior = .pauseAndRestore //他VCに画面が切り替わった際にpouseされるから画面が戻ってきた際に再開させる
        
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        animationView.isUserInteractionEnabled = true
        
        return animationView
    }
}
