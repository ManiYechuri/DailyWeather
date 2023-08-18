enum Event {
    case loading
    case dataLoaded
    case stopLoading
    case error(Error?)
}

enum WeatherCondition : String{
    case Clouds = "Clouds"
    case Clear = "Clear"
    case Rain = "Rain"
}

enum DataError : Error {
    case invalidResponse
    case invalidURL
    case invalidDecoding
    case invalidData
    case network(Error?)
}
