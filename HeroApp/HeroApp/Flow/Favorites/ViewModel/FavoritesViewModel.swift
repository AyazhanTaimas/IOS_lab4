import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favoriteHeroes: [HeroEntity] = []
    let service: HeroService // Добавляем сервис

    init(service: HeroService) {
        self.service = service
        loadFavorites()
    }

    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let savedFavorites = try? JSONDecoder().decode([HeroEntity].self, from: data) {
            favoriteHeroes = savedFavorites
        }
    }

    func removeFavorite(_ hero: HeroEntity) {
        favoriteHeroes.removeAll { $0.id == hero.id }
        saveFavorites()
    }

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteHeroes) {
            UserDefaults.standard.set(data, forKey: "favorites")
        }
    }
}
