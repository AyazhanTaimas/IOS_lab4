import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel: FavoritesViewModel

    init(service: HeroService) {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(service: service))
    }

    var body: some View {
        List {
            ForEach(viewModel.favoriteHeroes, id: \.id) { hero in
                NavigationLink(destination: HeroDetailView(viewModel: HeroDetailViewModel(heroId: hero.id, service: viewModel.service))) {
                    HStack {
                        AsyncImage(url: hero.heroImageUrl) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().frame(width: 50, height: 50).clipShape(Circle())
                            default:
                                Color.gray.frame(width: 50, height: 50).clipShape(Circle())
                            }
                        }
                        Text(hero.name)
                    }
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { viewModel.removeFavorite(viewModel.favoriteHeroes[$0]) }
            }
        }
        .onAppear {
            viewModel.loadFavorites()
        }
    }
}
