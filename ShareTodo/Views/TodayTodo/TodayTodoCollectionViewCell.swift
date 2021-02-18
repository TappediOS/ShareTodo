//
//  TodayTodoCollectionViewCell.swift
//  ShareTodo
//
//  Created by jun on 2020/07/24.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import Nuke
import Lottie
import Sica

class TodayTodoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var writeMessageButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    var radioButtonAction: (() -> Void)?
    var writeMessageButtonAction: (() -> Void)?
    
    private var isFinishedTodo = false
    private var isSubscribed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false  // animationが見切れないため
        
        self.setupGroupImageView()
        self.setupTaskLabel()
        self.setupRadioButton()
        self.setupWriteMessageButton()
    }
    
    func setupGroupImageView() {
        self.groupImageView.layer.borderWidth = 0.25
        self.groupImageView.layer.borderColor = UIColor.systemGray4.cgColor
        self.groupImageView.layer.cornerRadius = self.groupImageView.frame.width / 2
        self.groupImageView.layer.masksToBounds = true
    }
    
    func setupTaskLabel() {
        self.taskLabel.adjustsFontSizeToFitWidth = true
        self.taskLabel.minimumScaleFactor = 0.4
    }
    
    func setupRadioButton() {
        self.radioButton.layer.cornerRadius = self.groupImageView.frame.width / 2
        self.radioButton.layer.masksToBounds = false
        self.radioButton.tintColor = .systemGreen
    }
    
    func setupWriteMessageButton() {
        self.writeMessageButton.layer.masksToBounds = true
        self.writeMessageButton.tintColor = .systemGreen
        self.writeMessageButton.isHidden = true
    }
    
    func configure(with group: Group, isFinished: Bool, isWrittenMessage: Bool, isSubscribed: Bool) {
        self.isFinishedTodo = isFinished
        self.isSubscribed = isSubscribed
        
        let radioButtonImage = isFinished ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
        let writeMessageButtonImage = isWrittenMessage ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "pencil.circle")
        
        self.taskLabel.text = group.task
        self.groupNameLabel.text = R.string.localizable.group_Colon() + group.name
        self.radioButton.setImage(radioButtonImage, for: .normal)
        
        self.writeMessageButton.isHidden = !isFinished
        self.writeMessageButton.setImage(writeMessageButtonImage, for: .normal)
        
        
        // MARK: - サブスクが`false`なら，isHiddenを`true`にして表示させなくする
        if isSubscribed == false {
            self.writeMessageButton.isHidden = true
        }
        
        guard let url = URL(string: group.profileImageURL ?? "") else { return }
        DispatchQueue.main.async {
            let options = ImageLoadingOptions(placeholder: R.image.placeholderImage(), transition: .fadeIn(duration: 0.25), failureImage: R.image.groupDefaultImage())
            loadImage(with: url, options: options, into: self.groupImageView, progress: nil, completion: nil)
        }
    }
    
    private func changeRadioButtonImage() {
        let radioButtonImage = self.isFinishedTodo ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
        self.radioButton.setImage(radioButtonImage, for: .normal)
        self.writeMessageButton.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
    }
    
    @IBAction func tapRadioButton(_ sender: Any) {
        self.radioButtonAction?()
        
        self.isFinishedTodo.toggle()
        self.changeRadioButtonImage()
        if self.isSubscribed { self.writeMessageButton.isHidden = !self.isFinishedTodo }
        // toggleの後がfalseの時，つまり，finishをunFinishにする際はanimationはしないのでreturnする
        guard self.isFinishedTodo == true else { return }
        
        self.playRadioButtonSpringAnimation() //ボタンが跳ねるアニメーション
        
        
        print(ShareTodoRemoteConfig.finishTodoAnimationValue ?? "nil")
        switch ShareTodoRemoteConfig.finishTodoAnimationValue {
        case R.string.sharedString.remoteConfig_star(): playStarAnimation()
        case R.string.sharedString.remoteConfig_mudRaibow(): playMudRainbowAnimation()
        case R.string.sharedString.remoteConfig_fireworks(): playFireworksAnimation()
        case R.string.sharedString.remoteConfig_cracker(): playCrackerAnimation()
        case R.string.sharedString.remoteConfig_spark(): playSparkAnimation()
        case R.string.sharedString.remoteConfig_randomAnimation(): playRandomAnimation()
        default: playStarAnimation() // nilの場合とdefaultの時はここ
        }
    }
    
    @IBAction func tapWriteMessageButton(_ sender: Any) {
        self.writeMessageButtonAction?()
    }
    
    
    private func playRadioButtonSpringAnimation() {
        guard let imageView = self.radioButton.imageView else { return }
        let sprintAnimation = Animator(view: self.radioButton.imageView!)
        sprintAnimation.addSpringAnimation(keyPath: .boundsSize, from: CGSize(width: 0, height: 0), to: imageView.frame.size, damping: 10, mass: 1, stiffness: 200, initialVelocity: 0, duration: 1, delay: 0).run(type: .sequence)
    }
    
    // MARK: - アニメーション関数
    
    private func playStarAnimation() {
        guard let imageFrame = self.radioButton.imageView?.frame else { return }
        let starAnimationView = AnimationView().getStarAnimationView(stackViewFrame: buttonStackView.frame, targetViewFrame: imageFrame)
        self.addSubview(starAnimationView)
        starAnimationView.play { finished in
            if finished { starAnimationView.removeFromSuperview() }
        }
    }
    
    private func playCrackerAnimation() {
        guard let imageFrame = self.radioButton.imageView?.frame else { return }
        let starAnimationView = AnimationView().getCrackerAnimationView(stackViewFrame: buttonStackView.frame, targetViewFrame: imageFrame)
        self.addSubview(starAnimationView)
        starAnimationView.play { finished in
            if finished { starAnimationView.removeFromSuperview() }
        }
    }
    
    private func playFireworksAnimation() {
        guard let imageFrame = self.radioButton.imageView?.frame else { return }
        let starAnimationView = AnimationView().getFireworksAnimationView(stackViewFrame: buttonStackView.frame, targetViewFrame: imageFrame)
        self.addSubview(starAnimationView)
        starAnimationView.play { finished in
            if finished { starAnimationView.removeFromSuperview() }
        }
    }
    
    private func playMudRainbowAnimation() {
        guard let imageFrame = self.radioButton.imageView?.frame else { return }
        let starAnimationView = AnimationView().getMudRainbowAnimationView(stackViewFrame: buttonStackView.frame, targetViewFrame: imageFrame)
        self.addSubview(starAnimationView)
        starAnimationView.play { finished in
            if finished { starAnimationView.removeFromSuperview() }
        }
    }
    
    private func playSparkAnimation() {
        guard let imageFrame = self.radioButton.imageView?.frame else { return }
        let starAnimationView = AnimationView().getSparkAnimationView(stackViewFrame: buttonStackView.frame, targetViewFrame: imageFrame)
        self.addSubview(starAnimationView)
        starAnimationView.play { finished in
            if finished { starAnimationView.removeFromSuperview() }
        }
    }
    
    private func playRandomAnimation() {
        switch Int.random(in: 1...5) {
        case 1: playStarAnimation()
        case 2: playCrackerAnimation()
        case 3: playFireworksAnimation()
        case 4: playMudRainbowAnimation()
        case 5: playSparkAnimation()
        default: playStarAnimation()
        }
    }
}
