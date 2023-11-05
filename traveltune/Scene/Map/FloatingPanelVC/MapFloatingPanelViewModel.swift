//
//  MapFloatingPanelViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/11.
//

import Foundation

import RxSwift
import RxCocoa

final class MapFloatingPanelViewModel: BaseViewModel {
    
    enum MapFloatingPaneUIState<T> {
        case initValue
        case loading
        case success(data: T)
        case error(msg: String)
    }
    
    private var travelSpotRepository: TravelSpotRepository
    private var storyRepository: StoryRepository
    var regionType: RegionType
    
    init(
        regionType: RegionType,
        travelSpotRepository: TravelSpotRepository,
        storyRepository: StoryRepository
    ) {
        self.regionType = regionType
        self.travelSpotRepository = travelSpotRepository
        self.storyRepository = storyRepository
    }
    
//    var state: Observable<MapFloatingPaneUIState<[MapSpotItem]>> = Observable(.initValue)
    
    // 1. 관광지 지역별로 검색
    // 2. 해당 관광지 id 로 이야기 리스트 조회
    private var travelSpots: [TravelSpotItem] = []
    
    private var saveMapSpotDatas: [MapSpotItem] = []
    
    var state: BehaviorSubject<MapFloatingPaneUIState<[MapSpotItem]>> = BehaviorSubject(value: .initValue)
    
    var disposeBag = DisposeBag()
    
    func fetchMapSpotItems() {
        travelSpotRepository.requestTravelSpotsByLocation(
            page: 1,
            numOfRows: Network.numOfRowsByAllData / 2,
            mapX: String(regionType.longitude),
            mapY: String(regionType.latitude),
            radius: "15000"
        ) { [weak self] response in
            switch response {
            case .success(let success):
                let travelSpots = success.response.body.items.item.sorted(by: { $0.imageURL > $1.imageURL })
                
                let dispatchGroup = DispatchGroup()
                travelSpots.enumerated().forEach { idx, spotItem in
                    dispatchGroup.enter()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self?.basedStory(dispatchGroup: dispatchGroup, item: spotItem)
                    }
                }
                
                dispatchGroup.notify(queue: .main) { [weak self] in
                    guard let self else { return }
                    self.state.onNext(.success(data: self.saveMapSpotDatas.sorted(by: {$0.travelSpot.imageURL > $1.travelSpot.imageURL})))
//                    self.state.value = .success(data: self.saveMapSpotItems.sorted(by: {$0.travelSpot.imageURL > $1.travelSpot.imageURL}))
                }
                
            case .failure(let failure):
                self?.state.onNext(.error(msg: failure.localizedDescription))
//                self?.state.value = .error(msg: failure.localizedDescription)
            }
        }
    }
    
    private func basedStory(dispatchGroup: DispatchGroup, item: TravelSpotItem) {
        storyRepository.requestBasedStory(item: item) { [weak self] response in
            switch response {
            case .success(let success):
                let stories = success.response.body.items.item
                if !stories.isEmpty {
                    self?.saveMapSpotDatas.append(MapSpotItem(travelSpot: item, stories: stories))
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                print("값 추가 오류일 때 값 추가 패스")
            }
            dispatchGroup.leave()
        }
    }
}
