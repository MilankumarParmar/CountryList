import UIKit

class ViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var headerViewContainer: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    var data = [Country]()
    var filteredData = [Country]()

    var activityIndicator = UIActivityIndicatorView(style: .large)
    var dataRepository = DataRepository(networkService: NetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredData = data
        setupTableView()
        getCountryList()
        dateLbl.text = getFormattedDate()
        setupTimer()
        activityIndicator.color = UIColor.blue
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        searchBar.delegate = self
    }
    
    func setupTimer() -> Timer {
        return Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.dateLbl.text = getFormattedDate()
            }
        }
    }
    
    @IBAction func openMenu(sender: UIButton) {
      let thresholds = [1000000, 5000000, 10000000]
      let titles = ["< 1 M", "< 5 M", "< 10 M"]

      let items = titles.enumerated().map { index, title in
        PopoverItem(title: title) { [weak self] _ in
          guard let self = self else { return }
          self.filteredData = self.data.filter { $0.population ?? 0 < thresholds[index] }
          self.tableView.reloadData()
        }
      }

      let controller = PopoverController(items: items, fromView: sender, direction: .down, style: .normal)
      popover(controller)
    }
}

// MARK: UITableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CountryTableViewCell
        cell?.setupCell(country: filteredData[indexPath.row])
        return cell ?? UITableViewCell()
    }
}

// MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == "" {
            filteredData = data
        } else {
            for country in data {
                if country.name?.uppercased().contains(searchText.uppercased()) ?? false {
                    filteredData.append(country)
                }
            }
        }
        self.tableView.reloadData()
    }
}

// MARK: API Call
extension ViewController {
    func getCountryList() {
        activityIndicator.startAnimating()

        dataRepository.fetchData(from: APIs.country) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let countries):
                self.data = countries
                self.filteredData = countries
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                UIAlertControllerClass.showAlert(title: "Something went wrong!", message: error.localizedDescription, inViewController: self)
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
}
