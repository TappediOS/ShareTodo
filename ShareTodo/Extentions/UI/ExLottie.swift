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
    
    // MARK:- Common logic
    
    func frameCalculation(_ stackViewFrame: CGRect, _ targetViewFrame: CGRect) -> CGRect {
        let x = stackViewFrame.minX + targetViewFrame.minX
        let y = stackViewFrame.minY + targetViewFrame.minY
        let width = targetViewFrame.width
        let height = targetViewFrame.height
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func setupAnimationOption(animationView: AnimationView) {
        animationView.loopMode = .playOnce
        //他VCに画面が切り替わった際にpouseされるから画面が戻ってきた際に再開させる
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.contentMode = .scaleAspectFit
        animationView.isUserInteractionEnabled = true
    }
    
    // MARK:- get Animation funciton
    
    func getStarAnimationView(stackViewFrame: CGRect, targetViewFrame: CGRect) -> AnimationView {
        let animationView = AnimationView(name: R.file.lottie_stardustJson.name)
        animationView.frame = frameCalculation(stackViewFrame, targetViewFrame)
        animationView.transform = CGAffineTransform(scaleX: 2.78, y: 2.78)
        animationView.animationSpeed = 0.92
        self.setupAnimationOption(animationView: animationView)
        return animationView
    }
    
    func getCrackerAnimationView(stackViewFrame: CGRect, targetViewFrame: CGRect) -> AnimationView {
        let animationView = AnimationView(name: R.file.lottie_crackerJson.name)
        animationView.frame = frameCalculation(stackViewFrame, targetViewFrame)
        
        var trans = CGAffineTransform.identity
        trans = trans.translatedBy(x: -16, y: 16) // 移動してから拡大すること
        trans = trans.scaledBy(x: 3.2, y: 3.2)
        animationView.transform = trans
        animationView.animationSpeed = 1.0
        self.setupAnimationOption(animationView: animationView)
        return animationView
    }
    
    func getFireworksAnimationView(stackViewFrame: CGRect, targetViewFrame: CGRect) -> AnimationView {
        let animationView = AnimationView(name: R.file.lottie_fireworksJson.name)
        animationView.frame = frameCalculation(stackViewFrame, targetViewFrame)
        animationView.transform = CGAffineTransform(scaleX: 4.4, y: 4.4)
        animationView.animationSpeed = 1.1
        self.setupAnimationOption(animationView: animationView)
        return animationView
    }
    
    func getMudRainbowAnimationView(stackViewFrame: CGRect, targetViewFrame: CGRect) -> AnimationView {
        let animationView = AnimationView(name: R.file.lottie_mud_rainbowJson.name)
        animationView.frame = frameCalculation(stackViewFrame, targetViewFrame)
        animationView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        animationView.animationSpeed = 1.75
        self.setupAnimationOption(animationView: animationView)
        return animationView
    }
    
    func getSparkAnimationView(stackViewFrame: CGRect, targetViewFrame: CGRect) -> AnimationView {
        let animationView = AnimationView(name: R.file.lottie_sparkJson.name)
        animationView.frame = frameCalculation(stackViewFrame, targetViewFrame)
        animationView.transform = CGAffineTransform(scaleX: 4.15, y: 4.15)
        animationView.animationSpeed = 0.5
        self.setupAnimationOption(animationView: animationView)
        return animationView
    }
}
