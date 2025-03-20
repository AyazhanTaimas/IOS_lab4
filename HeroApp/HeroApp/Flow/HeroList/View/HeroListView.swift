import SwiftUI



struct HeroListView: View {
    @StateObject var viewModel = HeroListViewModel(service: HeroServiceImpl(), router: HeroRouter())

    var body: some View {
        VStack {
            HStack {
                Text("Hero List")
                    .font(.largeTitle)
                    .padding(.leading, 16) // 16 - это размер отступа, можно изменить
                
                Spacer()
                
                NavigationLink(destination: FavoritesView(service: HeroServiceImpl())) {
                    Text("⭐")
                        .font(.system(size: 15)) // уменьшаем размер звездочки
                        .padding(8) // уменьшаем отступы внутри фона
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8) // уменьшаем радиус
                        .padding(.trailing, 5)
                }
                .frame(width: 40, height: 40) // уменьшаем общий размер кнопки
            }

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
