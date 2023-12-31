//
//  SearchVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/02.
//

import UIKit
import SnapKit

final class SearchVC: BaseViewController<SearchView, SearchViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
        viewModel?.fetchWords()
    }
    
    func configureVC() {
        mainView.viewModel = viewModel
        mainView.searchVCProtocol = self
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronBackward,
            style: .plain,
            target: self,
            action: #selector(backButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .txtPrimary
        navigationItem.titleView = mainView.naviBarSearchTextField
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    func bindViewModel() {
        viewModel?.state.bind { [weak self] state in
            switch state {
            case .initValue: Void()
            case .loading:
                LoadingIndicator.show()
            case .success(let data):
                self?.mainView.applySnapShot(
                    recommendItems: data.recommendWords,
                    recentItems: data.recentSearchKeywords
                )
                LoadingIndicator.hide()
            case .emptySearchText:
                self?.showToast(msg: Strings.Common.searchPlaceHolder, position: .center)
            case .existSearchText(let searchText):
                self?.viewModel?.saveSearchKeyword(text: searchText)
                self?.successSearch(text: searchText)
            case .error(let msg):
                LoadingIndicator.hide()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.naviBarSearchTextField.resignFirstResponder()
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    private func successSearch(text: String) {
        mainView.naviBarSearchTextField.text = text
        let vc = SearchResultVC()
        vc.searchKeyword = text
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchVC: SearchVCProtocol {
    func textfieldDoneClicked(searchText: String) {
        viewModel?.checkSearchText(searchText: searchText)
    }
    
    func recommendWordClicked(searchText: String) {
        successSearch(text: searchText)
    }
    
    func recentWordClicked(searchText: String) {
        successSearch(text: searchText)
    }
    
    func deleteRecentWordClicked(item: SearchController.RecentSearchItem) {
        viewModel?.deleteSearchKeyword(id: item.id)
    }
}

extension SearchVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

