# iOS_lab4
## Implementation Decisions

### HeroApp
HeroApp – iOS-приложение для просмотра супергероев с поиском, деталями и избранным.

 **Функции** 
 Список супергероев
 Поиск по имени
 Избранное
 Детальная информаци

### 2. Структура
HeroError.swift – обработка ошибок
```swift
enum HeroError: Error {
    case wrongUrl, somethingWentWrong
}```

**Router**
HeroRouter.swift – отвечает за навигацию
```swift
final class HeroRouter {
    var rootViewController: UINavigationController?

    func showDetails(for id: Int, service: HeroService) {
        let detailViewModel = HeroDetailViewModel(heroId: id, service: service)
        let detailVC = UIHostingController(rootView: HeroDetailView(viewModel: detailViewModel))
        rootViewController?.pushViewController(detailVC, animated: true)
    }
}```

**Service**
HeroService.swift – загрузка данных
```swift
protocol HeroService {
    func fetchHeroes() async throws -> [HeroEntity]
    func fetchHeroById(id: Int) async throws -> HeroEntity
}

struct HeroServiceImpl: HeroService {
    func fetchHeroes() async throws -> [HeroEntity] {
        guard let url = URL(string: Constants.baseUrl + "all.json") else { throw HeroError.wrongUrl }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([HeroEntity].self, from: data)
    }

    func fetchHeroById(id: Int) async throws -> HeroEntity {
        guard let url = URL(string: Constants.baseUrl + "id/\(id).json") else { throw HeroError.wrongUrl }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(HeroEntity.self, from: data)
    }
}```

**Utils**
Constants.swift – базовый URL API
```swift
enum Constants {
    static let baseUrl = "https://akabab.github.io/superhero-api/api/"
}```


