import Foundation

final class HistoryViewModel {
    private let dbManager = DBManagerImpl()
    private(set) var history: [FilterModel] = [] {
        didSet {
            onUpdate?()
        }
    }
    
    public var onUpdate: (() -> Void)?
    
    init() {
        fetchFiltersHistory()
    }
    
    public func historyCount() -> Int {
        return self.history.count
    }
    
    func fetchFiltersHistory() {
        DispatchQueue.main.async { [weak self] in
            self?.history = self?.dbManager.fetchFilters() ?? []
        }
    }
    
    func deleteFilter(filter: FilterModel, completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            
            if let index = self?.history.firstIndex(of: filter) {
                self?.history.remove(at: index)
                self?.dbManager.removeObject(filter: filter)
                completion()
            }
        }
    }
}
