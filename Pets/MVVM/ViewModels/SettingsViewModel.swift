//
//  SettingsViewModel.swift
//  Pets
//
//  Created by Cristian Serea on 21.02.2024.
//


import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class SettingsViewModel {
    var sections: BehaviorSubject<[SectionModel<SectionType, Option>]>
    
    init(sections: BehaviorSubject<[SectionModel<SectionType, Option>]>) {
        self.sections = sections
    }
    
    convenience init() {
        self.init(sections: BehaviorSubject(value: SettingsViewModel.getSections()))
    }
    
    convenience init(withValue value: [SectionModel<SectionType, Option>]) {
        self.init(sections: BehaviorSubject(value: value))
    }
    
    var value: [SectionModel<SectionType, Option>]? {
        return try? sections.value()
    }
    
    var canReset: Bool {
        guard let value = value else {
            return false
        }
        
        var canReset = false
        
        let sortSection = value.first(where: { $0.model == .Sort })
        sortSection?.items.forEach({ sortSectionItem in
            if sortSectionItem.sort?.sortType != .DateShuffled && sortSectionItem.sort?.isSelected ?? false {
                canReset = true
            }
        })
        
        let filterSection = value.first(where: { $0.model == .Filter })
        filterSection?.items.forEach({ filterSectionItem in
            if filterSectionItem.filter?.value != nil {
                canReset = true
            }
        })
        
        return canReset
    }
    
    var isLocationSelected: Bool {
        guard let value = value else {
            return false
        }
        
        let filterSection = value.first(where: { $0.model == .Filter })
        let filterSectionItem = filterSection?.items.first(where: { $0.filter?.filterType == .Location })
        
        return filterSectionItem?.filter?.value != nil
    }
    
    var query: String? {
        guard let value = value else {
            return nil
        }
        
        var query: String?
        
        let sortSection = value.first(where: { $0.model == .Sort })
        let sortSectionItem = sortSection?.items.first(where: { $0.sort?.sortType != .DateShuffled && $0.sort?.isSelected ?? false })
        if let value = sortSectionItem?.sort?.sortType.rawValue {
            query.appendQuery(string: ParameterConstants.sort + "=" + value)
        }
        
        let filterSection = value.first(where: { $0.model == .Filter })
        filterSection?.items.forEach({ filterSectionItem in
            if let filterType = filterSectionItem.filter?.filterType.localizable.lowercased(),
               let value = filterSectionItem.filter?.value {
                query.appendQuery(string: filterType + "=" + value)
            }
        })
        
        return query
    }
}

extension SettingsViewModel {
    private static func getSections() -> [SectionModel<SectionType, Option>] {
        let sortOptions = getSorts().map { Option(sort: $0, filter: nil) }
        let sortSection = SectionModel(model: SectionType.Sort, items: sortOptions)
        
        let filterOptions = getFilters().map { Option(sort: nil, filter: $0) }
        let filtertSection = SectionModel(model: SectionType.Filter, items: filterOptions)
        
        return [sortSection, filtertSection]
    }
    
    private static func getSorts() -> [Sort] {
        return SortType.allCases.map {
            Sort(sortType: $0, 
                 isSelected: $0 == .DateShuffled,
                 isEnabled: $0.isEnabled)
        }
    }
    
    private static func getFilters() -> [Filter] {
        return FilterType.allCases.map { filterType in
            switch filterType {
            case .PetType:
                return Filter(filterType: filterType, placeholder: PetType.AnySpecies.localizable)
            case .Gender:
                return Filter(filterType: filterType, placeholder: Gender.AnyGender.localizable)
            case .Location:
                return Filter(filterType: filterType, placeholder: Location.AnyLocation.localizable)
            case .Distance:
                return Filter(filterType: filterType, isEnabled: false)
            }
        }
    }
}

extension SettingsViewModel {
    func reset() {
        guard canReset else {
            return
        }
        
        sections.onNext(SettingsViewModel.getSections())
    }
    
    func selectSort(withIndexPath indexPath: IndexPath) {
        guard var value = value else {
            return
        }
        
        guard let sortSectionIndex = value.firstIndex(where: { $0.model == .Sort }) else {
            return
        }
        
        var sortSection = value[sortSectionIndex]
        var sortSectionItems = sortSection.items
        
        sortSectionItems.enumerated().forEach { index, _ in
            sortSectionItems[index].sort?.isSelected = index == indexPath.row
        }
        
        sortSection.items = sortSectionItems
        value[sortSectionIndex] = sortSection
        sections.onNext(value)
    }
    
    func selectFilter(withIndexPath indexPath: IndexPath,
                      withPlaceholder itemPlaceholder: String,
                      withValue itemValue: String?) {
        guard var value = value else {
            return
        }
        
        guard let filterSectionIndex = value.firstIndex(where: { $0.model == .Filter }) else {
            return
        }
        
        var filterSection = value[filterSectionIndex]
        var filterSectionItems = filterSection.items
        let oldItemValue = filterSectionItems[indexPath.row].filter?.value
        filterSectionItems[indexPath.row].filter?.placeholder = itemPlaceholder
        filterSectionItems[indexPath.row].filter?.value = itemValue
        
        if filterSectionItems[indexPath.row].filter?.filterType == .Location {
            let isEnabled = filterSectionItems[indexPath.row].filter?.value != nil
            let shouldStop = oldItemValue != nil && isEnabled
            
            if !shouldStop {
                if let index = filterSectionItems.firstIndex(where: { $0.filter?.filterType == .Distance }) {
                    filterSectionItems[index].filter?.value = nil
                    filterSectionItems[index].filter?.placeholder = isEnabled ? Distance.Miles100.localizable : nil
                    filterSectionItems[index].filter?.isEnabled = isEnabled
                }
                
                if let sortSectionIndex = value.firstIndex(where: { $0.model == .Sort }) {
                    var sortSection = value[sortSectionIndex]
                    var sortSectionItems = sortSection.items
                    
                    sortSectionItems.enumerated().forEach { index, _ in
                        if sortSectionItems[index].canBeDisabled {
                            sortSectionItems[index].sort?.isSelected = false
                            sortSectionItems[index].sort?.isEnabled = isEnabled
                        }
                    }
                    
                    if sortSectionItems.first(where: { $0.sort?.isSelected ?? false }) == nil {
                        sortSectionItems[.zero].sort?.isSelected = true
                    }
                    
                    sortSection.items = sortSectionItems
                    value[sortSectionIndex] = sortSection
                }
            }
        }
        
        filterSection.items = filterSectionItems
        value[filterSectionIndex] = filterSection
        sections.onNext(value)
    }
}
