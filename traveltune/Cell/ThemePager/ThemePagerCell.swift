//
//  ThemePagerCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/26.
//

import UIKit
import FSPagerView
import Hero
import SnapKit


final class ThemePagerCell: FSPagerViewCell, BaseCellProtocol {
    
    typealias Model = ThemeStory
    
    let containerView = ThemePagerCellView()
    
    var moveThemeDetailClicked: ((ThemeStory) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.moveButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    func configureHierarchy() {
        contentView.addSubview(containerView)
    }
    
    func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configCell(row: ThemeStory) {
        containerView.heroID = nil
        containerView.opacityView.heroID = nil
        containerView.thumbImageView.image = row.thumbnail
        containerView.themeLabel.text = row.title
        containerView.themeImageView.image = row.miniThumbnail.withTintColor(.txtSecondary, renderingMode: .alwaysOriginal)
        containerView.contentLabel.text = row.content
        containerView.contentLabel.setLineSpacing(spacing: 8)
        containerView.contentLabel.lineBreakMode = .byTruncatingTail
        
        containerView.moveButton.addAction(.init(handler: { [weak self] _ in
            self?.moveThemeDetailClicked?(row)
        }), for: .touchUpInside)
    }
}
