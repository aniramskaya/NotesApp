import UIKit

final class NoteTableViewCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    //MARK: - flow funcs
    func configure(with item: String){
    }

    func configureIcon(with name: String) {
    }

    func configureTitileLabel(with text: String) {
    }

    func configureContentLabel(with text: String) {
    }

    func configureDateLabel(with price: Int) {
    }
}
