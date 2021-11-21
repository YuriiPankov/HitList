import UIKit

class MainCoordinator {
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension MainCoordinator: Coordinator {
    func start() {
        let mainVC = MainViewController()
        navigationController.pushViewController(mainVC, animated: false)
    }
}
