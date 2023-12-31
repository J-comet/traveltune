//
//  DetailMapSpotHeaderView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/11.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class DetailMapSpotHeaderView: UICollectionReusableView, BaseCellProtocol {
    
    typealias T = MapSpotItem
    
    private let containerView = UIView().setup { view in
        view.backgroundColor = .background
    }
    
    private let imageContainerView = UIView()
    
    private let topView = UIView()
    
    private let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let vibrancyEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .regular)))
    
    lazy var backButton = UIButton().setup { view in
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        view.setImage(.xmark.withConfiguration(configuration).withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        view.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    private let backBlurImageView = UIImageView().setup { view in
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
    }
    
    private let circleImageView = CircleImageView(frame: .zero).setup { view in
        view.contentMode = .scaleAspectFill
    }
    
    private let labelStackView = UIStackView().setup { view in
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.axis = .vertical
        view.spacing = 4
    }
    
    private let titleLabel = UILabel().setup { view in
        view.textColor = .txtPrimary
        view.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
    }
    
    private let infoLabel = UILabel().setup { view in
        view.textColor = .txtSecondary
        view.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
    }
    
    private let guideLabel = UILabel().setup { view in
        view.textColor = .txtPrimary
        view.font = .monospacedSystemFont(ofSize: 16, weight: .regular)
        view.text = Strings.Common.storyList
    }
    
    private lazy var moveMapView = CircleImageButtonView().setup { view in
        view.setView(backgroundColor: .backgroundButton, image: .enterMap)
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveMapImageViewClicked))
        view.addGestureRecognizer(tap)
        
        // 추후 업데이트 때 다시 버튼 보여주기
        view.isHidden = true
    }
    
    var backClicked: (() -> Void)?
    
    var moveMapClicked: (() -> Void)?
    
    @objc private func backButtonClicked() {
        backClicked?()
    }
    
    @objc private func moveMapImageViewClicked() {
        moveMapClicked?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        addSubview(containerView)
        addSubview(imageContainerView)
        imageContainerView.addSubview(backBlurImageView)
        imageContainerView.addSubview(circleImageView)
        
        backBlurImageView.addSubview(blurredEffectView)
        imageContainerView.addSubview(vibrancyEffectView)
        vibrancyEffectView.contentView.addSubview(topView)
        topView.addSubview(backButton)
        
        containerView.addSubview(guideLabel)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(infoLabel)
        containerView.addSubview(labelStackView)
        containerView.addSubview(moveMapView)
    }
    
    func configureLayout() {
        
        imageContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.snp.height).multipliedBy(0.76)
        }
    
        backBlurImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        circleImageView.snp.makeConstraints { make in
            make.size.equalTo(self.snp.height).multipliedBy(0.5)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(16)
        }
        
        blurredEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        vibrancyEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        guideLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        moveMapView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(38)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func configCell(row item: MapSpotItem) {
        titleLabel.text = item.travelSpot.title
        if item.travelSpot.themeCategory.isEmpty {
            infoLabel.text = "\(item.travelSpot.fullAddr)"
        } else {
            infoLabel.text = "\(item.travelSpot.fullAddr) / #\(item.travelSpot.themeCategory)"
        }
        
        if item.travelSpot.imageURL.isEmpty {
            circleImageView.image = .defaultImg
            backBlurImageView.image = .defaultImg
        } else {
            if let url = URL(string: item.travelSpot.imageURL) {
                circleImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "default_img"),
                    options: [
                        .processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))),
                        .scaleFactor(UIScreen.main.scale),
                        .cacheOriginalImage
                    ]
                )
                
                backBlurImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "default_img"),
                    options: [
                        .processor(DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))),
                        .scaleFactor(UIScreen.main.scale),
                        .cacheOriginalImage
                    ]
                )
            }
        }
    }
}

