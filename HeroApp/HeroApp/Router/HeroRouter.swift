import SwiftUI
import UIKit

final class HeroRouter {
    var rootViewController: UINavigationController?

    func showDetails(for id: Int, service: HeroService) {
        let detailViewModel = HeroDetailViewModel(heroId: id, service: service)
        let detailVC = UIHostingController(rootView: HeroDetailView(viewModel: detailViewModel))
        rootViewController?.pushViewController(detailVC, animated: true)
    }
}
