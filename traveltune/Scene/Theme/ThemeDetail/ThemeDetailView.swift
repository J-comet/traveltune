//
//  ThemeDetailView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import UIKit
import Hero
import SnapKit

final class ThemeDetailView: BaseView {
    
    weak var viewModel: ThemeDetailViewModel?
    weak var themeDetailVCProtocol: ThemeDetailVCProtocol?
    
    var themeStoryItems: [StoryItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let vibrancyEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .regular)))
    
    let backgroundImageView = UIImageView().setup { view in
        view.contentMode = .scaleAspectFill
        view.hero.id = Constant.HeroID.themeThumnail
    }
    
    private let opacityView = UIView().setup { view in
        view.hero.id = Constant.HeroID.themeOpacity
        view.backgroundColor = .translucent
    }
    
    let topView = UIView()
    private let emptyTopView = UIView()
    
    lazy var topTitleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 16, weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
    }
    
    lazy var backButton = UIButton().setup { view in
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        view.setImage(.xmark.withConfiguration(configuration).withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        view.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    lazy var infoButton = UIButton().setup { view in
        view.setImage(.infoCircle.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        view.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.createLayout()
    ).setup { view in
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.register(StoryCell.self, forCellWithReuseIdentifier: StoryCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.isHidden = true
    }
    
//    var dataSource: UICollectionViewDiffableDataSource<Int, StoryItem>! = nil
    
    let playerBottomView = PlayerBottomView().setup { view in
        view.isHidden = true
    }
    
    lazy var scriptView = StoryScriptView().setup { view in
        view.closeClicked = {
            self.hideScriptView()
        }
    }
    
    @objc private func buttonClicked(_ sender: UIButton) {
        switch sender {
        case backButton:
            themeDetailVCProtocol?.backButtonClicked()
        case infoButton:
            themeDetailVCProtocol?.infoButtonClicked()
        default: print(#function)
        }
    }
    
    private let topViewHeight = 50
    
    
    
    override func configureHierarchy() {
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(blurredEffectView)
        addSubview(emptyTopView)
        addSubview(vibrancyEffectView)
        vibrancyEffectView.contentView.addSubview(topView)
        topView.addSubview(topTitleLabel)
        topView.addSubview(backButton)
        topView.addSubview(infoButton)
        
        addSubview(collectionView)
        addSubview(playerBottomView)
        addSubview(scriptView)
        
        //        vibrancyEffectView.contentView.addSubview(collectionView)
//        configureDataSource()
    }
    
    override func configureLayout() {
        
        blurredEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        vibrancyEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(topViewHeight)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        topTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(backButton.snp.trailing).offset(8)
            make.trailing.equalTo(infoButton.snp.leading).offset(-8)
        }
        
        infoButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        emptyTopView.snp.makeConstraints { make in
            make.height.equalTo(topViewHeight)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        collectionView.setContentHuggingPriority(.required, for: .vertical)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(emptyTopView.snp.bottom)
            make.bottom.equalTo(playerBottomView.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        
        playerBottomView.setContentHuggingPriority(.defaultLow, for: .vertical)
        playerBottomView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(self.snp.height).multipliedBy(0.13)
        }
        
        scriptView.snp.makeConstraints { make in
            make.top.equalTo(playerBottomView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            //            make.top.equalTo(emptyTopView.snp.bottom)
            //            make.bottom.equalTo(playerBottomView.snp.top)
            //            make.horizontalEdges.equalToSuperview()
        }
    }
    
    func showScriptView() {
        playerBottomView.thumbImageView.isUserInteractionEnabled = false
        scriptView.isHidden = false
        scriptView.isUserInteractionEnabled = false
        scriptView.snp.remakeConstraints { make in
            make.top.equalTo(emptyTopView.snp.bottom)
            make.bottom.equalTo(playerBottomView.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        scriptView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0, options:.curveEaseOut) {
            self.scriptView.alpha = 1
            self.layoutIfNeeded()
        } completion: { _ in
            self.scriptView.isUserInteractionEnabled = true
        }

    }
    
    func hideScriptView() {
        scriptView.isUserInteractionEnabled = false
        scriptView.snp.remakeConstraints { make in
            make.top.equalTo(playerBottomView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        scriptView.alpha = 1
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.layoutIfNeeded()
            self.scriptView.alpha = 0
        } completion: { _ in
            self.scriptView.isHidden = true
            self.playerBottomView.thumbImageView.isUserInteractionEnabled = true
        }
    }
    
}

extension ThemeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeStoryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCell.identifier, for: indexPath) as? StoryCell else {
            return UICollectionViewCell()
        }
        
        let item = themeStoryItems[indexPath.item]
        cell.configCell(row: item)
        cell.heartButtonClicked = { [weak self] in
            self?.themeDetailVCProtocol?.cellHeartButtonClicked(item: item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        themeDetailVCProtocol?.didSelectItemAt(item: themeStoryItems[indexPath.item])
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
//        collectionView.deselectItem(at: indexPath, animated: true)
//        themeDetailVCProtocol?.didSelectItemAt(item: item)
//    }
    
}

extension ThemeDetailView {
    
    private func createLayout() -> UICollectionViewLayout {
        let width: CGFloat = UIScreen.main.bounds.width
        let spacing: CGFloat = 8
        return UICollectionViewFlowLayout().collectionViewLayout(
            headerSize: .zero,
            itemSize: CGSize(width: width, height: 60),
            sectionInset: UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing),
            minimumLineSpacing: 2,
            minimumInteritemSpacing: 0)
    }
    
//    private func configureDataSource() {
//        let cellRegistraion = UICollectionView.CellRegistration<StoryCell, StoryItem> { cell, indexPath, itemIdentifier in
//            cell.configCell(row: itemIdentifier)
//            cell.heartButtonClicked = { [weak self] in
//                self?.themeDetailVCProtocol?.cellHeartButtonClicked(item: itemIdentifier)
//            }
//        }
//        
//        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            return collectionView.dequeueConfiguredReusableCell(using: cellRegistraion, for: indexPath, item: itemIdentifier)
//        })
//        
//        var snapshot = NSDiffableDataSourceSnapshot<Int, StoryItem>()
//        snapshot.appendSections([0])
//        snapshot.appendItems([], toSection: 0)
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
//    
//    func applySnapshot(items: [StoryItem]) {
//        var snapshot = NSDiffableDataSourceSnapshot<Int, StoryItem>()
//        snapshot.appendSections([0])
//        snapshot.appendItems(items, toSection: 0)
//        dataSource.applySnapshotUsingReloadData(snapshot)
//    }
}
