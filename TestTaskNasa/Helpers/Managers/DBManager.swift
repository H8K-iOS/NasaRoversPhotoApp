import RealmSwift
protocol DBManager {
    func saveFilter(filter: FilterModel)
    func fetchFilters() -> [FilterModel]
    func removeObject(filter: Object)
}

class DBManagerImpl: DBManager {
    fileprivate lazy var mainRealm = try! Realm(configuration: .defaultConfiguration)
    
    func saveFilter(filter: FilterModel) {
        
        try! mainRealm.write {
            mainRealm.add(filter)
        }
       
    }
    
    func removeObject(filter: Object) {
        try! mainRealm.write {
            mainRealm.delete(filter)
        }
    }

    
    func fetchFilters() -> [FilterModel] {
        let models = mainRealm.objects(FilterModel.self)
        return Array(models)
    }
}
