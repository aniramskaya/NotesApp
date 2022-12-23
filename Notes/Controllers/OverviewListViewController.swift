import UIKit

final class OverviewListViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var listOfNotesTableView: UITableView!

    //MARK: - life cycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    //MARK: - flow funcs
    private func configure() {
        listOfNotesTableView.delegate = self
        listOfNotesTableView.dataSource = self
        let nib = UINib(nibName: "NoteTableViewCell", bundle: nil)
        listOfNotesTableView.register(nib, forCellReuseIdentifier: "NoteTableViewCell")
    }
    
}

//MARK: - extension Delegate, DataSource
extension OverviewListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell else {return UITableViewCell()}

        cell.configure(with: "dsadas")
        return cell
    }
}
