import Foundation

protocol HeroService {
    func fetchHeroes() async throws -> [HeroEntity]
    func fetchHeroById(id: Int) async throws -> HeroEntity
}

struct HeroServiceImpl: HeroService {
    func fetchHeroes() async throws -> [HeroEntity] {
        let urlString = Constants.baseUrl + "all.json"
        guard let url = URL(string: urlString) else { throw HeroError.wrongUrl }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let heroes = try JSONDecoder().decode([HeroEntity].self, from: data)
            return heroes
        } catch {
            throw HeroError.somethingWentWrong
        }
    }

    func fetchHeroById(id: Int) async throws -> HeroEntity {
        let urlString = Constants.baseUrl + "id/\(id).json"
        guard let url = URL(string: urlString) else { throw HeroError.wrongUrl }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let hero = try JSONDecoder().decode(HeroEntity.self, from: data)
            return hero
        } catch {
            throw HeroError.somethingWentWrong
        }
    }
}
