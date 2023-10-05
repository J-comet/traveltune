//
//  SearchResultTabTravelSpotView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit
import SnapKit

final class SearchResultTabTravelSpotView: BaseView {
    
    var spotItems: [TravelSpotItem] = []
    
    enum Section {
        case main
    }

    lazy var dataSource: UICollectionViewDiffableDataSource<Section, TravelSpotItem>! = nil
    
    let emptyLabel = UILabel().setup { view in
        view.textColor = .txtDisabled
        view.font = .monospacedSystemFont(ofSize: 16, weight: .medium)
        view.text = Strings.Common.searchNoData
        view.textAlignment = .center
        view.isHidden = true
    }
    
    // 데이터 있을 때
    let containerView = UIView().setup { view in
        view.isHidden = true
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    
    override func configureHierarchy() {
        addSubview(containerView)
        containerView.addSubview(collectionView)
        addSubview(emptyLabel)
        configureDataSource()
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyLabel.isHidden = true
        emptyLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
}

extension SearchResultTabTravelSpotView {
    
    func applySnapShot(items: [TravelSpotItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TravelSpotItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createCellRegistration() -> UICollectionView.CellRegistration<SearchResultSpotCell, TravelSpotItem> {
        return UICollectionView.CellRegistration<SearchResultSpotCell, TravelSpotItem> { (cell, indexPath, identifier) in
            cell.contentView.backgroundColor = .link
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

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        let spacing: CGFloat = 10
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: 0, trailing: spacing)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}