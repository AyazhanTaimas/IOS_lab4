import SwiftUI



struct HeroListView: View {
    @StateObject var viewModel = HeroListViewModel(service: HeroServiceImpl(), router: HeroRouter())

    var body: some View {
        VStack {
            HStack {
                Text("Hero List")
                    .font(.largeTitle)
                
                Spacer()

                NavigationLink(destination: FavoritesView(service: HeroServiceImpl())) { 
                    Text("Favorites")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            TextField("Search Heroes", text: $viewModel.searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Divider().padding(.bottom, 16)

            listOfHeroes()
            Spacer()
        }
        .task {
            await viewModel.fetchHeroes()
        }
    }
}

extension HeroListView {
    @ViewBuilder
    private func listOfHeroes() -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.filteredHeroes) { model in
                    heroCard(model: model)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                }
            }
        }
    }

    @ViewBuilder
    private func heroCard(model: HeroListModel) -> some View {
        HStack {
            AsyncImage(url: model.heroImage) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().frame(width: 100, height: 100).padding(.trailing, 16)
                default:
                    Color.gray.frame(width: 100, height: 100).padding(.trailing, 16)
                }
            }

            VStack {
                Text(model.title)
                Text(model.description)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.routeToDetail(by: model.id)
        }
    }
}
