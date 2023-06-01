import UIKit
import CoreLocation

class ViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var humidityLable: UILabel!
    
    // MARK: - Properties
    
    private let lastSearchedCityKey = "LastSearchedCity"    // Key for storing/retrieving the last searched city in UserDefaults
    private static var apiKey: String = Bundle.main.object(forInfoDictionaryKey: "APIKey") as! String
    
    private let weatherViewModel: WeatherViewModel = WeatherViewModel(weatherDataService: WeatherDataService(apiKey: apiKey),locationService: LocationService())    // Weather view model instance for fetching weather data
    private var activityIndicatorView: UIActivityIndicatorView!     // Activity indicator view for showing loading state
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.center = view.center
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
        setupUI()
        loadLastSearchedCity()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        temperatureLabel.text = ""
        weatherDescriptionLabel.text = ""
        feelsLikeLabel.text = ""
        highLabel.text = ""
        lowLabel.text = ""
        humidityLable.text = ""
        weatherImageView.image = nil
        searchTextField.delegate = self
    }
    
    // MARK: - Load Last Searched City
    
    private func loadLastSearchedCity() {
        if let lastSearchedCity = getLastSearchedCity() {
            searchTextField.text = lastSearchedCity
            fetchWeatherData(forCity: lastSearchedCity)
        } else {
            configureLocationService()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func getCurrentLocationPressed(_ sender: Any) {
        self.configureLocationService()
    }
    
    // MARK: - Location Service Configuration
    
    private func configureLocationService() {
        activityIndicatorView.startAnimating()
        weatherViewModel.fetchWeatherDataForCurrentLocation { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
            }
            switch result {
            case .success:
                self?.updateUI()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.displayErrorMessage(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Weather Data Fetching
    
    private func fetchWeatherData(forLocation location: CLLocation) {
        activityIndicatorView.startAnimating()
        weatherViewModel.fetchWeatherDataForCurrentLocation { [weak self]
            result in
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
            }
            switch result {
            case .success:
                self?.updateUI()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.displayErrorMessage(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchWeatherData(forCity city: String) {
        activityIndicatorView.startAnimating()
        weatherViewModel.fetchWeatherData(forCity: city) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
            }
            switch result {
            case .success:
                self?.saveLastSearchedCity(city)
                self?.updateUI()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.displayErrorMessage(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - UI Update
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.temperatureLabel.text = self.weatherViewModel.temperature
            self.weatherDescriptionLabel.text = self.weatherViewModel.weatherDescription
            self.searchTextField.text = self.weatherViewModel.cityName
            self.highLabel.text = self.weatherViewModel.high
            self.lowLabel.text = self.weatherViewModel.low
            self.humidityLable.text = self.weatherViewModel.humidity
            self.feelsLikeLabel.text = self.weatherViewModel.feelsLike
            
            let weatherIconName = self.weatherViewModel.weatherIconName
            if !weatherIconName.isEmpty {
                if let cachedImage = self.weatherViewModel.getCachedImage(for: weatherIconName) {
                    self.weatherImageView.image = cachedImage
                } else {
                    DispatchQueue.global().async { [weak self] in
                        if let url = URL(string: "http://openweathermap.org/img/w/\(weatherIconName).png"),
                           let data = try? Data(contentsOf: url),
                           let image = UIImage(data: data) {
                            self?.weatherViewModel.setCachedImage(image, for: weatherIconName)
                            DispatchQueue.main.async {
                                self?.weatherImageView.image = image
                            }
                        } else {
                            DispatchQueue.main.async {
                                // Set an error placeholder image
                                self?.weatherImageView.image = UIImage(named: "placeholderImage")
                            }
                        }
                    }
                }
            } else {
                // Set an error placeholder image
                self.weatherImageView.image = UIImage(named: "placeholderImage")
            }
        }
    }
    
    // MARK: - Error Handling
    
    private func displayErrorMessage(_ message: String) {
        self.setupUI()
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Last Searched City Handling
    
    private func getLastSearchedCity() -> String? {
        return UserDefaults.standard.string(forKey: lastSearchedCityKey)
    }
    
    private func saveLastSearchedCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: lastSearchedCityKey)
    }
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let city = textField.text, !city.isEmpty {
            fetchWeatherData(forCity: city)
        }
        return true
    }
}
