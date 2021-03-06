//
//  UserDetailViewController.swift
//  ShareTodo
//
//  Created by jun on 2020/09/23.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit
import Nuke
import FSCalendar
import SCLAlertView

final class UserDetailViewController: UIViewController {
    private var presenter: UserDetailViewPresenterProtocol!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupTaskLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var introductionButton: UIButton!
    @IBOutlet weak var introductionView: UIView!
    
    
    internal let profileImageView = UIImageView()
    var activityIndicator = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupProfileImageView()
        self.setupNavigationBar()
        self.setupCalenderView()
        self.setupGroupImageView()
        self.setupGroupNameLabel()
        self.setupGroupTaskLabel()
        self.setupIntroductionLabel()
        self.setupIntroductionButton()
        self.setupActivityIndicator()
        
        self.presenter.didViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter.didViewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationImage(false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showNavigationImage(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.profileImageView.removeFromSuperview()
    }
    
    func setupView() {
        self.scrollView.delegate = self
    }
    
    func setupProfileImageView() {
        self.profileImageView.layer.borderWidth = 0.25
        self.profileImageView.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = self.presenter.user.name
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.tintColor = .systemGreen
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(profileImageView)
        profileImageView.layer.cornerRadius = NavigationImageConst.ImageSizeForLargeState / 2
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -NavigationImageConst.ImageRightMargin),
            profileImageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -NavigationImageConst.ImageBottomMarginForLargeState),
            profileImageView.heightAnchor.constraint(equalToConstant: NavigationImageConst.ImageSizeForLargeState),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ])
    }
    
    func setupCalenderView() {
        self.calenderView.delegate = self
        self.calenderView.dataSource = self
    }
    
    func setupGroupImageView() {
        self.groupImageView.layer.borderWidth = 0.25
        self.groupImageView.layer.borderColor = UIColor.systemGray4.cgColor
        self.groupImageView.layer.cornerRadius = self.groupImageView.frame.width / 2
        self.groupImageView.layer.masksToBounds = true
    }
    
    func setupGroupNameLabel() {
        self.groupNameLabel.adjustsFontSizeToFitWidth = true
        self.groupNameLabel.minimumScaleFactor = 0.4
    }
    
    func setupGroupTaskLabel() {
        self.groupTaskLabel.adjustsFontSizeToFitWidth = true
        self.groupTaskLabel.minimumScaleFactor = 0.4
    }
    
    func setupIntroductionLabel() {
        self.introductionLabel.text = R.string.localizable.introductionDescription()
        self.introductionLabel.adjustsFontSizeToFitWidth = true
        self.introductionLabel.minimumScaleFactor = 0.4
    }
    
    func setupIntroductionButton() {
        self.introductionButton.setTitle(R.string.localizable.introduction(), for: .normal)
        self.introductionButton.backgroundColor = .systemGreen
        self.introductionButton.tintColor = .white
        self.introductionButton.layer.cornerRadius = 8
        self.introductionButton.layer.masksToBounds = true
        self.introductionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.introductionButton.titleLabel?.minimumScaleFactor = 0.4
    }
    
    func setupActivityIndicator() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.style = .large
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
    }
    
    private func showNavigationImage(_ show: Bool) {
        UIView.animate(withDuration: show ? 0.18 : 0.15) {
            self.profileImageView.alpha = show ? 1.0 : 0.0
        }
    }
    
    @IBAction func tapIntroductionButton(_ sender: Any) {
        self.presenter.didTapIntroductionButton()
    }
    
    
    func inject(with presenter: UserDetailViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
}

extension UserDetailViewController: UserDetailViewPresenterOutput {
    func setUserName() {
        DispatchQueue.main.async { self.navigationItem.title = self.presenter.user.name }
    }
    
    func setGroupName() {
        DispatchQueue.main.async { self.groupNameLabel.text = self.presenter.group.name }
    }
    
    func setGroupTask() {
        DispatchQueue.main.async { self.groupTaskLabel.text = self.presenter.group.task }
    }
    
    func setProfileImage(_ url: URL) {
        DispatchQueue.main.async {
            let options = ImageLoadingOptions(placeholder: R.image.placeholderImage(), transition: .fadeIn(duration: 0.25), failureImage: R.image.defaultProfileImage())
            loadImage(with: url, options: options, into: self.profileImageView, progress: nil, completion: nil)
        }
    }
    
    func setGroupImage(_ url: URL) {
        DispatchQueue.main.async {
            let options = ImageLoadingOptions(placeholder: R.image.placeholderImage(), transition: .fadeIn(duration: 0.25), failureImage: R.image.groupDefaultImage())
            loadImage(with: url, options: options, into: self.groupImageView, progress: nil, completion: nil)
        }
    }
    
    func reloadCalenderView() {
        DispatchQueue.main.async { self.calenderView.reloadData() }
    }
    
    func segueIntroductionShareTodoPlusVC() {
        let introductionShareTodoPlusVC = IntroductionShareTodoPlusViewBuilder.create()
        self.navigationController?.pushViewController(introductionShareTodoPlusVC, animated: true)
    }
    
    func moveAndResizeImage(scale: Double, xTranslation: Double, yTranslation: Double) {
        let scale = CGFloat(scale)
        let xTranslation = CGFloat(xTranslation)
        let yTranslation = CGFloat(yTranslation)
        DispatchQueue.main.async {
            self.profileImageView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale).translatedBy(x: xTranslation, y: yTranslation)
        }
    }
    
    func hideIntroductionVCView() {
        DispatchQueue.main.async {
            self.introductionView.isHidden = true
            self.introductionLabel.isHidden = true
            self.introductionButton.isHidden = true
        }
    }
    
    func showIntroductionVCView() {
        DispatchQueue.main.async {
            self.introductionView.isHidden = false
            self.introductionLabel.isHidden = false
            self.introductionButton.isHidden = false
        }
    }
    
    func showErrorAleartView(error: Error) {
        let errorAlertView = SCLAlertView().getCustomAlertView()
        let title = R.string.localizable.error()
        let subTitle = error.localizedDescription
        DispatchQueue.main.async {
            errorAlertView.showError(title, subTitle: subTitle, colorStyle: 0xFF2D55, colorTextButton: 0xFFFFFF)
        }
    }
    
    func impactFeedbackOccurred() {
        TapticFeedbacker.impact(style: .light)
    }
    
    func noticeFeedbackOccurredError() {
        TapticFeedbacker.notice(type: .error)
    }
    
    func noticeFeedbackOccurredSuccess() {
        TapticFeedbacker.notice(type: .success)
    }
}

extension UserDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        self.presenter.didScrollViewDidScroll(height: Double(height))
    }
}

extension UserDetailViewController: FSCalendarDelegate, FSCalendarDataSource {
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        self.presenter.getMinimumDate()
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        guard calenderView.maximumDate >= date else { return nil } //最小の日(今日)以降はnil
        guard calenderView.minimumDate <= date else { return nil } //最後の日よりも前はnil
        
        //今日から1週間までは記録をする
        if self.presenter.getTheDayIsAWeekAgo(date: date) {
            if self.presenter.getContaintFinishedDate(date: date) {
                return UIImage(systemName: "checkmark.seal.fill")?.withTintColor(.systemGreen).withRenderingMode(.alwaysOriginal)
            }
            return UIImage(systemName: "xmark.seal.fill")?.withTintColor(.systemRed).withRenderingMode(.alwaysOriginal)
        }
        
        // サブスクしてたら表示する
        if self.presenter.isUserSubscribed {
            if self.presenter.getContaintFinishedDate(date: date) {
                return UIImage(systemName: "checkmark.seal.fill")?.withTintColor(.systemGreen).withRenderingMode(.alwaysOriginal)
            }
            return UIImage(systemName: "xmark.seal.fill")?.withTintColor(.systemRed).withRenderingMode(.alwaysOriginal)
        }
        
        // Subscriptionしてない場合はロックする
        return UIImage(systemName: "lock.fill")?.withTintColor(.systemOrange).withRenderingMode(.alwaysOriginal)
    }
}
