//
//  PlaylistView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit
import SnapKit

final class SettingView: BaseView {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout()).setup { view in
        view.delegate = self
        view.dataSource = self
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.register(SettingCell.self, forCellWithReuseIdentifier: SettingCell.identifier)
        view.register(
            TitleSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleSupplementaryView.identifier
        )
    }
    
    weak var settingVCProtocol: SettingVCProtocol?
    
    override func configureHierarchy() {
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension SettingView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 헤더뷰 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SettingsType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingsType.allCases[section].contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.identifier, for: indexPath) as? SettingCell else {
            return UICollectionViewCell()
        }
        let item = SettingItem(
            title: SettingsType.allCases[indexPath.section].contents[indexPath.item],
            rightTitle: SettingsType.allCases[indexPath.section].detailContents[indexPath.item]
        )
        
        cell.configCell(row: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = SettingItem(
            title: SettingsType.allCases[indexPath.section].contents[indexPath.item],
            rightTitle: SettingsType.allCases[indexPath.section].detailContents[indexPath.item]
        )
        settingVCProtocol?.didSelectItemAt(item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.identifier, for: indexPath) as? TitleSupplementaryView else { return UICollectionReusableView() }
            
            view.titleLabel.text = String(describing: SettingsType.allCases[indexPath.section])
            return view
        } else {
            return UICollectionReusableView()
        }
    }
}

extension SettingView {
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let width: CGFloat = UIScreen.main.bounds.width
        return UICollectionViewFlowLayout().collectionViewLayout(
            scrollDirection: .vertical,
            headerSize: CGSize(width: width, height: 30),
            itemSize: CGSize(width: width, height: 44),
            sectionInset: .init(top: 0, left: 16, bottom: 16, right: 0),
            minimumLineSpacing: 0,
            minimumInteritemSpacing: 0)
    }
}
