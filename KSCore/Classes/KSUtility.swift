class KSCoreViewModel: NSObject {
    
    var alertMessage: String? {
        didSet {
            self.onAlertMessageChanged?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.onIsLoadingChanged?()
        }
    }
    
    private var bannerType: KSAlertType = .info
    func getCurrentBannerType()->KSAlertType {return self.bannerType}
    
    var onAlertMessageChanged: (()->())?
    // used to setting in core loading status
    var onIsLoadingChanged: (()->())?

    func setBannerMessage(message: String, bannerType: KSAlertType = .info){
        self.alertMessage = message
        self.bannerType = bannerType
    }
    
    func setPageShouldLoading(bool: Bool) {
        self.isLoading = bool
    }
}



open class KSMainCoordinator: NSObject {
    var childCoordinators = [KSCoordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        
    }

    func end(){
    }
}



protocol KSCoordinator {
    var childCoordinators: [KSCoordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func end()
}


protocol KSCoreCustomInit {
    static func instantiateWithStb() -> Self
    static func instantiateWithStb(named: String) -> Self
    static func instantiateWithXib() -> Self
}

extension KSCoreCustomInit where Self: UIViewController {
    
    static func instantiateWithStb() -> Self {
        return self.instantiateWithStb(named: "Main")
    }
    
    static func instantiateWithStb(named: String) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: named, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
    
    static func instantiateWithXib() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        return Self(nibName: className, bundle: nil)
    }
    
}
