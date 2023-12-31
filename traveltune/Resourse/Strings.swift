//
//  Strings.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import Foundation

struct Strings {
    
    struct Push {
        static let localPushMain = "local_push_main".localized
    }
    
    struct Common {
        static let logoTitle = "home_nav_title".localized
        static let play = "common_play".localized
        static let ok = "common_ok".localized
        static let cancel = "common_cancel".localized
        static let move = "common_move".localized
        static let selectPlayStory = "select_play_story".localized
        static let searchButton = "search_button".localized
        static let searchPlaceHolder = "search_place_holder".localized
        static let recommendKeyword = "recommend_keyword".localized
        static let recentSearchKeyword = "recent_search_keyword".localized
        static let searchNoData = "search_no_data".localized
        static let locationNoData = "location_no_data".localized
        static let getDirection = "get_direction".localized
        static let nearbyAttractions = "nearby_attractions".localized
        static let storyItemsCount = "story_items_count".localized
        static let touristDestination = "tourist_destination".localized
        static let storyList = "story_list".localized
        static let locationServices = "location_services".localized
        static let locationServicesGuide = "location_services_guide".localized
        static let currentLocation = "current_location".localized
        static let notificationServices = "notification_services".localized
        static let notificationServicesGuide = "notification_services_guide".localized
        static let scriptInfoNoData = "script_info_no_data".localized
        static let story = "story".localized
        static let favoriteStoryNoData = "favorite_story_no_data".localized
        static let alertMsgDeleteStoryItem = "alert_msg_delete_story_item".localized
        static let continuousPlay = "continuous_play".localized
        static let enterInquiryDetails = "enter_inquiry_details".localized
        static let inquiry = "inquiry".localized
        static let successSendEmail = "success_send_email".localized
        static let retry = "retry".localized
        static let openNewStoreVersion = "open_new_store_version".localized
        static let currentTheLatestVersion = "current_the_latest_version".localized
    }
    
    struct ErrorMsg {
        static let errorNetwork = "error_network".localized
        static let errorLocation = "error_location".localized
        static let errorRestartApp = "error_restart_app".localized
        static let errorLoadingData = "error_loading_data".localized
        static let errorFirstStory = "error_first_story".localized
        static let errorLastStory = "error_last_story".localized
        static let errorNoFile = "error_no_file".localized
        static let errorFailSendEmail = "error_fail_send_email".localized
        static let errorFailNoEmail = "error_fail_no_email".localized
        static let errorEmptyResultStoryByLocation = "error_empty_result_story_by_location".localized
    }
    
    struct TabMap {
        static let title = "tab_map_title".localized
        static let detailTitle = "tab_detail_map_title".localized        
    }
    
    struct ThemeStory {
        static let hangang = "theme_hangang".localized
        static let market = "theme_market".localized
        static let history = "theme_history".localized
        static let museum = "theme_museum".localized
        static let temple = "theme_temple".localized
        static let bukchon = "theme_bukchon".localized
        
        static let hangangSearchKeyword = "theme_hangang_search_keyword".localized
        static let marketSearchKeyword = "theme_market_search_keyword".localized
        static let historySearchKeyword = "theme_history_search_keyword".localized
        static let museumSearchKeyword = "theme_museum_search_keyword".localized
        static let templeSearchKeyword = "theme_temple_search_keyword".localized
        static let bukchonSearchKeyword = "theme_bukchon_search_keyword".localized
        
        static let hangangContent = "theme_hangang_content".localized
        static let marketContent = "theme_market_content".localized
        static let historyContent = "theme_history_content".localized
        static let museumContent = "theme_museum_content".localized
        static let templeContent = "theme_temple_content".localized  
        static let bukchonContent = "theme_bukchon_content".localized
    }
    
    struct SearchRecommend {
        static let Seokguram = "search_recommend_seokguram".localized
        static let TouristTaxi = "search_recommend_tourist_taxi".localized
        static let Bridge = "search_recommend_bridge".localized
        static let Beach = "search_recommend_beach".localized
        static let CheongWaDae = "search_recommend_cheong_wa_dae".localized
        static let Island = "search_recommend_island".localized
        static let History = "search_recommend_history".localized
        static let Cultural = "search_recommend_cultural".localized
        static let Street = "search_recommend_street".localized
        static let Trail = "search_recommend_trail".localized
        static let Observatory = "search_recommend_observatory".localized
    }
    
    struct SearchTabTitle {
        static let TravelSpot = "search_tab_travel_spot".localized
        static let Story = "search_tab_story".localized
    }
    
    struct Region {
        static var seoul = "seoul".localized
        static var gyeonggi = "gyeonggi".localized
        static var incheon = "incheon".localized
        static var gangwon = "gangwon".localized
        static var chungbuk = "chungbuk".localized
        static var chungnam = "chungnam".localized
        static var sejong = "sejong".localized
        static var daejeon = "daejeon".localized
        static var gyeongbuk = "gyeongbuk".localized
        static var gyeongnam = "gyeongnam".localized
        static var daegu = "daegu".localized
        static var ulsan = "ulsan".localized
        static var busan = "busan".localized
        static var jeonbuk = "jeonbuk".localized
        static var jeonnam = "jeonnam".localized
        static var gwangju = "gwangju".localized
        static var jeju = "jeju".localized
    }
    
    struct SchemeMapType {
        static var mapKakao = "map_kakao".localized
        static var mapNaver = "map_naver".localized
        static var mapTmap = "map_tmap".localized
        static var mapApple = "map_apple".localized
    }
    
    struct Setting {
        static var title = "tab_setting_title".localized
        static var settingHeaderAudioGuide = "setting_audio_guide".localized
        static var settingHeaderNotification = "setting_notification".localized
        static var settingHeaderTerms = "setting_terms".localized
        static var settingHeaderEtc = "setting_etc".localized
        
        static var settingAudioGuideItem01 = "setting_audio_guide_item_01".localized
        static var settingNotificationItem01 = "setting_notification_item_01".localized
        static var settingTermsItem01 = "setting_terms_item_01".localized
        static var settingEtcItem01 = "setting_etc_item_01".localized
        static var settingEtcItem02 = "setting_etc_item_02".localized
        static var settingEtcItem03 = "setting_etc_item_03".localized
        
        static var settingNotificationServiceTitle = "setting_notification_service_title".localized
        static var settingNotificationSettingButton = "setting_notification_setting_button".localized
        static var settingNotificationGuideContent = "setting_notification_guide_content".localized
    }
    
    struct Chart {
        static var title = "chart_title".localized
        static var totalNumberOfTourists = "total_number_of_tourists".localized
        static var yearStandard = "chart_year_standard".localized
    }
    
}
