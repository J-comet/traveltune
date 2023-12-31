//
//  ThemeDetailInfoVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/02.
//

import UIKit

final class ThemeDetailInfoVC: BaseViewController<ThemeDetailInfoView, BaseViewModel> {
    
    var themeStory: ThemeStory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.backgroundColor = .backgroundDim
    }
    
    func configureVC() {
        mainView.closeClicked = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        guard let themeStory else { return }
        mainView.mainThumbImageView.image = themeStory.thumbnail
        mainView.titleLabel.text = themeStory.title
        mainView.contentLabel.text = themeStory.content
        mainView.contentLabel.setLineSpacing(spacing: 8)
    }

    func bindViewModel() { }
}
