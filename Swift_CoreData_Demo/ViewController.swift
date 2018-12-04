

import UIKit
import CoreData

class ViewController: UIViewController {

    var cityArray: [CityLib] = []
    
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Swift_CoreData_Demo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved Error:\(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = {
       return persistentContainer.viewContext
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                if let error = error as NSError? {
                    fatalError("Unresolved Error:\(error.userInfo)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createData()
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.searchData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.deleteData()
        }
    }
    
    
    
    //MARK: CREATE

    private func createData() {
        
        let city1 = "Sunnyvale"
        let province1 = "California"
        let country1 = "USA"
        
        let record1 = NSEntityDescription.insertNewObject(forEntityName: "CityLib", into: context)
        record1.setValue(city1, forKey: "cityName")
        record1.setValue(province1, forKey: "provinceName")
        record1.setValue(country1, forKey: "countryName")
        
        let city2 = "Noida"
        let province2 = "Uttar Pradesh"
        let country2 = "India"
        
        let record2 = NSEntityDescription.insertNewObject(forEntityName: "CityLib", into: context)
        record2.setValue(city2, forKey: "cityName")
        record2.setValue(province2, forKey: "provinceName")
        record2.setValue(country2, forKey: "countryName")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    
    
    //MARK: FETCH

    func fetchData() {
        do {
            cityArray = try context.fetch(CityLib.fetchRequest())
        } catch {
            print(error)
        }
        
        for record in cityArray {
            print(record.cityName!)
        }
    }
    
    
    
    
    //MARK: SEARCH
    
    func searchData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CityLib")
        let searchString = "Noida"
        request.predicate = NSPredicate(format: "cityName CONTAINS[cd] %@", searchString) //cd for case sensative text
        var response = ""
        
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for record in result {
                    if let library = record as? CityLib,
                        let city = library.cityName,
                        let province = library.provinceName,
                        let country = library.countryName {
                        response = "city = " +  city + " province = " + province + " country =  " + country
                    }
                }
            } else {
                response = "No matching record found"
            }
        } catch {
            print(error)
        }
        print(response)
    }
    
    
    
    
    //MARK: DELETE

    func deleteData() {
        if let city = cityArray.first {
            context.delete(city)
          
            do {
                try context.save()
            } catch {
                print(error)
            }
            
            do {
                cityArray = try context.fetch(CityLib.fetchRequest())
            } catch {
                print(error)
            }
            
            print(cityArray)
        }
    }
}

