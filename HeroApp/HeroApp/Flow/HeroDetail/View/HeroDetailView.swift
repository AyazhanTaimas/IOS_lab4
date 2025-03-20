import SwiftUI

struct HeroDetailView: View {
    @StateObject var viewModel: HeroDetailViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            AsyncImage(url: viewModel.hero.heroImageUrl) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                default:
                    Color
                        .gray.frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 5))

                }
            }
            
            Text(viewModel.hero.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Race:")
                        .foregroundColor(.gray)
                    Text("\(viewModel.hero.appearance.race ?? "Unknown")")
                }
                HStack {
                    Text("Height:")
                        .foregroundColor(.gray)
                    Text("\(viewModel.hero.appearance.formattedHeight ?? "Unknown")")
                }
                HStack {
                    Text("Weight:")
                        .foregroundColor(.gray)
                    Text("\(viewModel.hero.appearance.formattedWeight ?? "Unknown")")
                }
                HStack {
                    Text("Eye Color:")
                        .foregroundColor(.gray)
                    Text("\(viewModel.hero.appearance.eyeColor ?? "Unknown")")
                }
                HStack {
                    Text("Hair Color:")
                        .foregroundColor(.gray)
                    Text("\(viewModel.hero.appearance.hairColor ?? "Unknown")")
                }
               // Spacer()
                   
                    
                    
                    
                
            }
            .font(.system(size: 18))
            .foregroundColor(.black)
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            Button(action: {
                viewModel.toggleFavorite()
            }) {
                Text(viewModel.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isFavorite ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
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
