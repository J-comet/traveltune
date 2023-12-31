//
//  SearchResultTabStoryVCProtocol.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/06.
//

import Foundation

protocol SearchResultTabStoryVCProtocol: AnyObject {
    func didSelectItemAt(item: StoryItem)
    func willDisplay(page: Int)
    func scrollBeginDragging()
}
