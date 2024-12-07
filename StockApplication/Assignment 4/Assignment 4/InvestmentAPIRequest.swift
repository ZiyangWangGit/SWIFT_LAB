import Foundation

// Define the StockQuote model according to the JSON structure

struct ApiResponse: Codable {
    let meta: MetaData
    let body: [StockSymbol]
}

struct MetaData: Codable {
    let version: String
    let status: Int
}

struct StockSymbol: Codable {
    let symbol: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case symbol
        case name
    }
}


struct StockPriceResponse: Codable {
    let body: StockPriceBody
}


struct StockPriceBody: Codable {
    let currentPrice: PriceDetails
    let currentRatio: CurrentRatio

    enum CodingKeys: String, CodingKey {
        case currentPrice
        case currentRatio
    }
}
struct PriceDetails: Codable {
    let raw: Double
}

struct CurrentRatio: Codable {
    let raw: Double
}
