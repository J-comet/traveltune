//
//  DetailMapByRegionViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/12.
//

import Foundation

final class DetailRegionMapViewModel: BaseViewModel {
    
    enum DetailRegionMapUIState<T> {
        case initValue
        case loading
        case success(data: T, lat: Double, lng: Double)
        case error(msg: String)
    }
    
    private var storyRepository: StoryRepository
    var regionType: RegionType
    
    init(
        regionType: RegionType,
        storyRepository: StoryRepository
    ) {
        self.regionType = regionType
        self.storyRepository = storyRepository
    }
    
    var state: MyObservable<DetailRegionMapUIState<[StoryItem]>> = MyObservable(.initValue)
    
    func fetchStoryByLocation(lat: Double, lng: Double) {
        print("위치변경에 따른 이야기 데이터 업데이트")   
        state.value = .loading
        storyRepository.requestStoryByLocation(
            page: 1, 
            numOfRows: 800,
            mapX: lng,
            mapY: lat,
            radius: Network.maxRadius) { [weak self] response in
                switch response {
                case .success(let success):
                    let stories = success.response.body.items.item
                    self?.state.value = .success(data: stories, lat: lat, lng: lng)
                case .failure(let failure):
                    self?.state.value = .error(msg: failure.localizedDescription)
                }
        }
    }
}
