import SwiftUI

struct HeroDetailView: View {
    @StateObject var viewModel: HeroDetailViewModel
    
    var body: some View {
        VStack {
            AsyncImage(url: viewModel.hero.heroImageUrl) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                default:
                    Color.gray.frame(width: 200, height: 200)
                }
            }
            
            Text(viewModel.hero.name)
                .font(.largeTitle)
                .padding()
            
            Text("Race: \(viewModel.hero.appearance.race ?? "Unknown")")
                .padding()
            
            Text("Height: \(viewModel.hero.appearance.formattedHeight)")
                .padding()
            
            Text("Weight: \(viewModel.hero.appearance.formattedWeight)")
                .padding()
            
            Text("Eye Color: \(viewModel.hero.appearance.eyeColor ?? "Unknown")") // Добавлен height
                    .padding()
            Text("Hair Color: \(viewModel.hero.appearance.hairColor ?? "Unknown")") // Добавлен height
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
            viewModel.checkIfFavorite()
        }
    }
}
