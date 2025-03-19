import Foundation

struct HeroEntity: Codable { // Было Decodable, теперь Codable (Encodable + Decodable)
    let id: Int
    let name: String
    let appearance: Appearance
    let images: HeroImage
    var heroImageUrl: URL? {
        URL(string: images.sm)
    }

    struct Appearance: Codable { // Было Decodable, теперь Codable
        let race: String?
    }

    struct HeroImage: Codable { // Было Decodable, теперь Codable
        let sm: String
        let md: String
    }
}
