import Foundation

final class HistoryViewModel {
    private let dbManager = DBManagerImpl()
    var history: [FilterModel] = [] {
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
    
    func deleteFilter(at index: Int) {
        guard index < history.count else { return }
        
        let filterToDelete = history[index]
        dbManager.removeObject(filter: filterToDelete) { [weak self] error in
            if let error {
                print(error.localizedDescription)
            } else {
                self?.fetchFiltersHistory()
            }
        }
    }
}
