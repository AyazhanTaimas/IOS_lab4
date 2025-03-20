import SwiftUI

class HeroDetailViewModel: ObservableObject {
    @Published var hero: HeroEntity
    @Published var isFavorite: Bool = false

    private let service: HeroService

    init(heroId: Int, service: HeroService) {
        self.service = service
        self.hero = HeroEntity(id: heroId, name: "", appearance: HeroEntity.Appearance(race: nil, eyeColor: nil, height: nil, weight: nil, hairColor: nil), images: HeroEntity.HeroImage(sm: "", md: "")) // Заглушка
        Task {
            await loadHeroDetails()
        }
        checkIfFavorite()
    }

    func loadHeroDetails() async {
        do {
            let fetchedHero = try await service.fetchHeroById(id: hero.id)
            DispatchQueue.main.async {
                self.hero = fetchedHero
                self.checkIfFavorite() // Проверяем избранное после загрузки героя
            }
        } catch {
            print("Failed to load hero details: \(error)")
        }
    }

    func toggleFavorite() {
        var favorites = getFavorites()
        if isFavorite {
            favorites.removeAll { $0.id == hero.id }
        } else {
            favorites.append(hero)
        }
        saveFavorites(favorites)
        isFavorite.toggle()
    }

    func checkIfFavorite() {
        let favorites = getFavorites()
        isFavorite = favorites.contains { $0.id == hero.id }
    }

    private func getFavorites() -> [HeroEntity] {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let savedFavorites = try? JSONDecoder().decode([HeroEntity].self, from: data) {
            return savedFavorites
        }
        return []
    }

    private func saveFavorites(_ favorites: [HeroEntity]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: "favorites")
        }
    }
}
