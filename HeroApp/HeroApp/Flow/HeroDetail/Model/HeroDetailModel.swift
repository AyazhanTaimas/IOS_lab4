import Foundation

struct HeroDetailModel: Identifiable {
    let id: Int
    let name: String
    let race: String
    let imageUrl: URL?
    let eyeColor: String
    let height: String
    let weight: String
    let hairColor: String
}
