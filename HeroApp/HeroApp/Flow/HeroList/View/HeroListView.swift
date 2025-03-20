import SwiftUI

struct HeroListView: View {
    @StateObject var viewModel = HeroListViewModel(service: HeroServiceImpl(), router: HeroRouter())

    var body: some View {
        VStack {
            HStack {
                Text("Hero List")
                    .font(.largeTitle)
                    .bold()
                    .padding(.leading, 16)

                Spacer()

                NavigationLink(destination: FavoritesView(service: HeroServiceImpl())) {
                    Text("⭐")
                        .font(.system(size: 18))
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.trailing, 10)
                }
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
                    image.resizable()
                        .frame(width: 100, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.trailing, 12)
                default:
                    Color.gray
                        .frame(width: 100, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.trailing, 12)
                }
            }

            Text(model.title)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.routeToDetail(by: model.id)
        }
    }
}
