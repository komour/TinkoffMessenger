class Company {
    var ceo: CEO
    
    init(CEO: CEO) {
        self.ceo = CEO
    }
    
    deinit {
        print("The company has been destroyed")
    }
}

class CEO {
    var productManager: ProductManager?
    
    let receiveMessage = { (fromId: Int, message: String) -> () in
        print("CEO recieved \"\(message)\" from developer:\(fromId)", terminator: "\n\n")
    }
    
    lazy var printCompany = { [weak self] in
        print("CEO asks PDM to print the company..")
        if let productManager = self?.productManager {
            productManager.printCompany()
        } else {
            print("nil PDM")
        }
    }
    
    lazy var printManager = { [weak self] in
        if let productManager = self?.productManager {
            print("CEO prints PDM")
        } else {
            print("nil PDM")
        }
    }
    
    lazy var printDevelopers = { [weak self] in
        print("CEO asks PDM to print developers...")
        if let productManager = self?.productManager {
            productManager.printDevelopers()
        } else {
            print("nil PDM")
        }
    }
    
    deinit {
        print("CEO has been destroyed")
    }
}

class ProductManager {
    
    weak var ceo: CEO?
    
    var developer1: Developer?
    var developer2: Developer?
    
    func receiveMessage(fromId: Int, message: String) {
        print("PDM received \"\(message)\" from developer:\(fromId)", terminator: "\n\n")
    }
    
    func printCompany() {
        print("PDM prints the company..")
        if let ceo = self.ceo {
            print("CEO: \(ceo)", terminator: ", ")
        } else {
            print("CEO: nil", terminator: ", ")
        }
        print("PDM: \(self)")
        printDevelopers
    }
    
    func printDevelopers() {
        print("PDM prints developers..")
        
        print("First developer: ", terminator: "")
        if let developer1 = developer1 {
            print(developer1.id)
        } else {
            print("nil")
        }
        
        print("Second developer: ", terminator: "")
        if let developer2 = developer2 {
            print(developer2.id)
        } else {
            print("nil")
        }
    }
    
    func connectDevelopers(fromId: Int, toId: Int, message: String) {
        print("PDM tries to connect two developers..")
        guard let developer1 = developer1 else {
            print("one of the developers is nil", terminator: "\n\n")
            return
        }
        guard let developer2 = developer2 else {
            print("one of the developers is nil", terminator: "\n\n")
            return
        }
        if developer1.id == toId {
            developer1.recieveMessage(fromId: developer2.id, message: message)
        } else if developer2.id == toId {
            developer2.recieveMessage(fromId: developer1.id, message: message)
        } else {
            print("PDM can't find developer with id = \(toId)", terminator: "\n\n")
        }
    }
    
    func connectWithCEO(developerId: Int, message: String) {
        print("PDM tries to connect developer with CEO..")
        if let ceo = ceo {
            ceo.receiveMessage(developerId, message)
        } else {
            print("CEO is nil")
        }
    }
    
    deinit {
        print("PDM has been destroyed")
    }
}

class Developer {
    let id: Int
    weak var productManager: ProductManager?
    
    init(id: Int) {
        self.id = id
    }
    
    func recieveMessage(fromId: Int, message: String) {
        print("developer:\(id) received \"\(message)\" from developer:\(fromId)", terminator: "\n\n")
    }
    
    func askCEO(message: String) {
        print("developer:\(id) tries to ask CEO..")
        if let productManager = productManager {
            productManager.connectWithCEO(developerId: id, message: message)
        } else {
            print("nil PDM")
        }
    }
    
    func askProductManager(message: String) {
        print("developer:\(id) asks PDM..")
        if let productManager = productManager {
            productManager.receiveMessage(fromId: id, message: message)
        } else {
            print("nil PDM")
        }
    }
    
    func sendMessageToDeveloper(receiverId: Int, message: String) {
        print("developer:\(id) tries to send message to the developer:\(receiverId)..")
        if let productManager = productManager {
            productManager.connectDevelopers(fromId: id, toId: receiverId, message: message)
        } else {
            print("nil PDM")
        }
    }
    
    deinit {
        print("developer:\(id) has been destroyed")
    }
}

func printCompany(company: Company?) {
    print("Printing company..")
    guard let company = company else {
        print("nil company")
        return
    }
    let ceo = company.ceo
    print("CEO: \(ceo)")
    guard let productManager = ceo.productManager else {
        print("PDM: nil")
        return
    }
    print("CEO \(ceo) controlls PDM \(productManager)")
    if let firstDeveloper = productManager.developer1 {
        print("PDM controlls developer:\(firstDeveloper.id)")
    }
    if let secondDeveloper = productManager.developer2 {
        print("PDM controlls developer:\(secondDeveloper.id)")
    }
}

func companyLifecycle() {
    // create company with all relations
    let ceo = CEO()
    let company: Company? = Company(CEO: ceo)
    let productManager: ProductManager? = ProductManager()

    productManager?.ceo = ceo
    ceo.productManager = productManager

    let firstDeveloper = Developer(id: 42)
    firstDeveloper.productManager = productManager
    productManager?.developer1 = firstDeveloper

    let secondDeveloper = Developer(id: 47)
    secondDeveloper.productManager = productManager
    productManager?.developer2 = secondDeveloper

    // print company
    printCompany(company: company)
    print()

    // imitate communication in company
    firstDeveloper.sendMessageToDeveloper(receiverId: 47, message: "what's up?")
    secondDeveloper.sendMessageToDeveloper(receiverId: 69, message: "such a nice weather today!")
    secondDeveloper.sendMessageToDeveloper(receiverId: firstDeveloper.id, message: "hello, my g")
    secondDeveloper.askCEO(message: "raise my salary!")
    firstDeveloper.askProductManager(message: "want more tasks!")
} // destroy all objects

companyLifecycle()
