import SwiftUI

struct HeroEntity: Codable {
    let id: Int
    let name: String
    let appearance: Appearance
    let images: HeroImage
    
    var heroImageUrl: URL? {
        URL(string: images.sm)
    }

    struct Appearance: Codable {
        let race: String?
        let eyeColor: String? // 👈 Делаем height опциональным
        let height: [String]? // Изменено: теперь массив строк
                
                /// Возвращает рост только в сантиметрах (или "Unknown")
                var formattedHeight: String {
                    guard let height = height, !height.isEmpty else { return "Unknown" }
                    return height.last ?? "Unknown" // Берем последний элемент (например, "203 cm")
                }
        let weight: [String]? // Изменено: теперь массив строк
                
                /// Возвращает рост только в сантиметрах (или "Unknown")
                var formattedWeight: String {
                    guard let weight = weight, !weight.isEmpty else { return "Unknown" }
                    return weight.last ?? "Unknown" // Берем последний элемент (например, "203 cm")
                }
        
        let hairColor: String?
    }

    struct HeroImage: Codable {
        let sm: String
        let md: String
    }
}
