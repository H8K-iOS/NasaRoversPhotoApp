import RealmSwift
protocol DBManager {
    func saveFilter(filter: FilterModel)
    func fetchFilters() -> [FilterModel]
    func removeObject(filter: FilterModel, completion: @escaping (Error?) -> Void)
}

final class DBManagerImpl: DBManager {
    fileprivate lazy var mainRealm: Realm? = {
            var config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 1) {
                        migration.enumerateObjects(ofType: FilterModel.className()) { oldObject, newObject in
                            newObject!["date"] = nil
                        }
                    }
                })
            
            Realm.Configuration.defaultConfiguration = config
            
            do {
                let realm = try Realm()
                return realm
            } catch {
                print("Failed to open Realm with error: \(error)")
                return nil
            }
        }()

    func saveFilter(filter: FilterModel) {
        guard let realm = mainRealm else { return }
        
        do {
            try realm.write {
                realm.add(filter)
            }
        } catch {
            print("failed to save")
        }
    }
    
    func removeObject(filter: FilterModel, completion: @escaping (Error?) -> Void) {
            guard let realm = mainRealm else {
                completion(NSError(domain: "Realm", code: 0, userInfo: [NSLocalizedDescriptionKey: "Real fail"]))
                return
            }
            do {
                try realm.write {
                    realm.delete(filter)
                }
                completion(nil)
            } catch {
                completion(error)
            }
        }

    
    func fetchFilters() -> [FilterModel] {
        guard let realm = mainRealm else {
            print("fail")
            return []
        }
        let models = realm.objects(FilterModel.self)
        return Array(models)
    }
}
