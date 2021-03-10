import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var imageFetcher: ImageFetcherType = ImageFetcher()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    var detailItem: Photo? {
        didSet {
            configureView()
        }
    }

    func configureView() {
        if let photo = detailItem,
           let label = detailDescriptionLabel {
            label.text = photo.title
            guard let url = URL(string: photo.fullSizeUrl) else {
                return
            }

            imageFetcher.downloadImage(from: url) { [weak imageView] (response) in
                guard case .Success(let image) = response else { return }
                imageView?.image = image
            }
        }
    }

}

