//
//  SearchResultTabTravelSpotViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/05.
//

import Foundation

final class SearchResultTabTravelSpotViewModel: BaseViewModel {
    
    enum SearchResultTabSpotUIState<T> {
        case initValue
        case loading
        case success(data: T)
        case error(msg: String)
    }
    
    private var travelSportRepository: TravelSpotRepository?
    
    convenience init(travelSportRepository: TravelSpotRepository) {
        self.init()
        self.travelSportRepository = travelSportRepository
    }
    
    var state: Observable<SearchResultTabSpotUIState<[TravelSpotItem]>> = Observable(.initValue)
    
    func searchSpots(
        searchKeyword: String,
        page: Int
    ){
        guard let travelSportRepository else { return }
        state.value = .loading
        travelSportRepository.requestSearchTravelSpots(page: page, searchKeyword: searchKeyword) { response in
            switch response {
            case .success(let success):
                let result = success.response.body.items.item
                self.state.value = .success(data: result)
            case .failure(let failure):
                self.state.value = .error(msg: failure.localizedDescription)
            }
        }
    }
}