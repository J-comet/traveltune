//
//  DetailTravelSpotView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/08.
//

import UIKit
import SnapKit
import Kingfisher
import MapKit

final class DetailTravelSpotView: BaseView {
    
    weak var detailTravelSpotProtocol: DetailTravelSpotProtocol?
    
    private lazy var scrollView = UIScrollView().setup { view in
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
    }
    
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
    }
    
    private let circleImageView = CircleImageView(frame: .zero).setup { view in
        view.contentMode = .scaleAspectFill
    }
    
    private let topRoundView = UIView().setup { view in
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .background
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
        view.numberOfLines = 0
    }
    
    private let addrLabel = UILabel().setup { view in
        view.textColor = .txtSecondary
        view.font = .monospacedSystemFont(ofSize: 15, weight: .regular)
    }
    
    private let categoryLabel = UILabel().setup { view in
        view.textColor = .txtSecondary
        view.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
    }
    
    private var customAnnotaionImageUrl = ""
    
    let mapView = ExcludeMapView().setup { view in
        view.isZoomEnabled = false           // 줌
        view.isScrollEnabled = false         // 이동
        view.showsUserLocation = false       // 유저 위치
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }
    
    private let mapNodataLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 16, weight: .light)
        view.textColor = .white
        view.backgroundColor = .backgroundDim
        view.text = Strings.Common.locationNoData
        view.textAlignment = .center
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }
    
    let findDirectionButton = UIButton().setup { view in
        view.clipsToBounds = true
        view.layer.cornerRadius = 0
        var attString = AttributedString(Strings.Common.getDirection)
        attString.font = .systemFont(ofSize: 16, weight: .bold)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.contentInsets = .init(top: 0, leading: 0, bottom: 24, trailing: 0)
        config.image = .locationArrow
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.baseBackgroundColor = .backgroundButton
        config.baseForegroundColor = .white
        view.configuration = config
    }
    
    private let emptyDirectionButtonView = UIView().setup { view in
        view.backgroundColor = .backgroundButton
    }
    
    private let nearbyTravelSpotLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 16, weight: .regular)
        view.textColor = .txtPrimary
        view.text = Strings.Common.nearbyAttractions
        view.isHidden = true
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).setup { view in
        view.delegate = self
        view.alwaysBounceVertical = false
        view.showsVerticalScrollIndicator = false
        view.isHidden = true
    }
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, TravelSpotItem>! = nil
    
    @objc func backButtonClicked() {
        detailTravelSpotProtocol?.backButtonClicked()
    }
    
    func fetchData(item: TravelSpotItem) {
        
        customAnnotaionImageUrl = item.imageURL
        titleLabel.text = item.title
        addrLabel.text = item.fullAddr
        categoryLabel.isHidden = item.themeCategory.isEmpty
        categoryLabel.text = "#\(item.themeCategory)"
        
        let defulatCenter = CLLocationCoordinate2D(latitude: RegionType.seoul.latitude, longitude: RegionType.seoul.longitude)
        let region = MKCoordinateRegion(
            center: defulatCenter,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        mapView.setRegion(region, animated: true)
        
        if let x = Double(item.mapX), let y = Double(item.mapY) {
            mapNodataLabel.isHidden = true
            nearbyTravelSpotLabel.isHidden = false
            collectionView.isHidden = false
            let center = CLLocationCoordinate2D(latitude: y, longitude: x)
            setRegionAndAnnotation(center: center, item: item)
            mapView.isZoomEnabled = true           // 줌
            mapView.isScrollEnabled = true         // 이동
        }
        
        if item.imageURL.isEmpty {
            circleImageView.image = .defaultImg
            backBlurImageView.image = .defaultImg
        } else {
            if let url = URL(string: item.imageURL) {
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
    
    func hideNearbyCollectionView() {
        nearbyTravelSpotLabel.backgroundColor = .lightGray
        nearbyTravelSpotLabel.isHidden = true
        collectionView.isHidden = true
    }
    
    private func setRegionAndAnnotation(center: CLLocationCoordinate2D, item: TravelSpotItem) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: false)
        
        // 지도에 어노테이션 추가
        let annotation = MKPointAnnotation()
        annotation.title = item.title
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
    }
    
    override func configureHierarchy() {
        addSubview(scrollView)
        addSubview(findDirectionButton)
        addSubview(emptyDirectionButtonView)
        scrollView.addSubview(imageContainerView)
        scrollView.addSubview(backBlurImageView)
        scrollView.addSubview(topRoundView)
        
        backBlurImageView.addSubview(blurredEffectView)
        addSubview(vibrancyEffectView)
        vibrancyEffectView.contentView.addSubview(topView)
        topView.addSubview(backButton)
        scrollView.addSubview(circleImageView)
        
        scrollView.addSubview(containerView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(addrLabel)
        labelStackView.addArrangedSubview(categoryLabel)
        containerView.addSubview(labelStackView)

        containerView.addSubview(mapView)
        containerView.addSubview(mapNodataLabel)
        containerView.addSubview(nearbyTravelSpotLabel)
        containerView.addSubview(collectionView)
        
        configureDataSource()
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(findDirectionButton.snp.top)
        }
        
        findDirectionButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(90)
            make.horizontalEdges.equalToSuperview()
        }
        
        emptyDirectionButtonView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(10)
            make.top.equalTo(findDirectionButton)
        }
        
        imageContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self) // superview로 할 경우 horizontal scroll 영역 존재
            make.top.equalToSuperview()
            //            make.height.equalTo(imageContainerView.snp.width).multipliedBy(0.7)
            make.height.equalTo(300)
        }
        
        backBlurImageView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(imageContainerView)
            make.top.equalTo(self).priority(999)
            make.height.greaterThanOrEqualTo(imageContainerView.snp.height)
        }
        
        topRoundView.snp.makeConstraints { make in
            make.bottom.equalTo(backBlurImageView.snp.bottom)
            make.horizontalEdges.equalTo(self)
            make.height.equalTo(20)
        }
        
        circleImageView.snp.makeConstraints { make in
            make.size.equalTo(160)
            make.bottom.equalTo(blurredEffectView).inset(54)
            make.centerX.equalToSuperview()
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
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom)
            make.horizontalEdges.equalTo(self)
            make.bottom.equalToSuperview()
            make.height.equalTo(600)
        }
       
        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        mapView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(20)
            make.top.equalTo(labelStackView.snp.bottom).offset(8)
            make.height.equalTo(self.snp.width).multipliedBy(0.5)
        }
        
        mapNodataLabel.snp.makeConstraints { make in
            make.edges.equalTo(mapView)
        }
        
        nearbyTravelSpotLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.equalTo(labelStackView)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(nearbyTravelSpotLabel.snp.bottom)
            make.horizontalEdges.equalTo(self)
            make.height.equalTo(150)
        }
    }

}

extension DetailTravelSpotView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        detailTravelSpotProtocol?.didSelectItemAt(item: item)
    }
}

extension DetailTravelSpotView {
    
    func applySnapShot(items: [TravelSpotItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TravelSpotItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createCellRegistration() -> UICollectionView.CellRegistration<SearchResultSpotCell, TravelSpotItem> {
        return UICollectionView.CellRegistration<SearchResultSpotCell, TravelSpotItem> { (cell, indexPath, identifier) in
            cell.configCell(row: identifier)
        }
    }
    
    private func configureDataSource() {
        let spotRegistration = createCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, TravelSpotItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: TravelSpotItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: spotRegistration, for: indexPath, item: identifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, TravelSpotItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalWidth(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = configuration
        return layout
    }
}

