import UIKit

class MasterViewController: UITableViewController {

    private var detailViewController: DetailViewController? = nil
    private var photos = [Photo]()
    private let imageFetcher = ImageFetcher()
    private let recentsFetcher = RecentsFetcher()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        fetchRecents()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let photo = photos[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = photo
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }


    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableRowCell
        cell.thumbnail.image = nil

        let photo = photos[indexPath.row]
        cell.titleLabel?.text = photo.title

        if let url = URL(string: photo.thumbnailUrl) {
            imageFetcher.downloadImage(from: url) { [weak cell] (response) in
                guard case .Success(let image) = response else { return }
                cell?.thumbnail?.image = image
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }


    // MARK: - Fetch data

    func fetchRecents() {
        recentsFetcher.fetchRecents { (response) in
            DispatchQueue.main.async {
                guard case .Recents(let photos) = response else {
                    // Show error
                    return
                }
                self.photos = photos

                self.tableView.reloadData()

            }
        }
    }
}

