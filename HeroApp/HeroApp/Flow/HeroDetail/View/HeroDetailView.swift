import SwiftUI

struct HeroDetailView: View {
    @StateObject var viewModel: HeroDetailViewModel
    
    var body: some View {
        VStack {
            AsyncImage(url: viewModel.hero.heroImageUrl) { phase in // Здесь исправлено
                switch phase {
                case .success(let image):
                    image.resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10)) // Добавлено: закругление углов
                default:
                    Color.gray.frame(width: 200, height: 200)
                }
            }
            
            Text(viewModel.hero.name)
                .font(.largeTitle)
                .padding()
            
            Text("Race: \(viewModel.hero.appearance.race ?? "Unknown")") // Исправлено: добавлен доступ к appearance.race
                .padding()
            
            Button(action: {
                viewModel.toggleFavorite()
            }) {
                Text(viewModel.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                    .padding()
                    .background(viewModel.isFavorite ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.loadHeroDetails()
            }
            viewModel.checkIfFavorite() // Проверяем, избранный ли герой
        }
    }
}
