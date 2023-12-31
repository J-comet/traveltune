//
//  ThemeDetailVCProtocol.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/28.
//

import Foundation

protocol ThemeDetailVCProtocol: AnyObject {
    func backButtonClicked()
    func infoButtonClicked()
    func cellHeartButtonClicked(item: StoryItem)
    func didSelectItemAt(item: StoryItem)
}
