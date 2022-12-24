 import UIKit

 final class OverviewListViewController: UIViewController {

     //MARK: - let/var
     private enum Constants {
         static let offsetForButton: CGFloat = 100
         static let heightForRow: CGFloat = 80
         static var xBeforeAnimation: CGFloat = 0
         static var xAfterAnimation: CGFloat = 0
         static var isButtonShow = false
     }

     private var array = [1]

     private let createNoteButton: UIButton = {
         let button: UIButton = .init()
         button.setImage(UIImage(named: "pencil"), for: .normal)
         button.backgroundColor = .none
         button.bounds.size = .init(width: 50, height: 50)
         button.addTarget(self, action: #selector(createNoteButtonPressed), for: .touchUpInside)
         return button
     }()

     //MARK: - IBOutlet
     @IBOutlet private weak var listOfNotesTableView: UITableView!

     //MARK: - life cycle funcs
     override func viewDidLoad() {
         super.viewDidLoad()
         configure()
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         listOfNotesTableView.reloadData()
     }

     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         Constants.isButtonShow ? setXForButton(x: Constants.xAfterAnimation) : setXForButton(x: Constants.xBeforeAnimation)
     }

     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         startButtonAnimation ()

     }

     override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         setXForButton(x: Constants.xBeforeAnimation)
     }

     //MARK: - flow funcs
     private func configure() {
         view.addSubview(createNoteButton)

         createNoteButton.frame.origin.y = view.bounds.height - Constants.offsetForButton
         Constants.xBeforeAnimation = view.bounds.width
         Constants.xAfterAnimation = view.bounds.width - Constants.offsetForButton

         listOfNotesTableView.separatorColor = .black
         listOfNotesTableView.delegate = self
         listOfNotesTableView.dataSource = self
         let nib = UINib(nibName: "NoteTableViewCell", bundle: nil)
         listOfNotesTableView.register(nib, forCellReuseIdentifier: "NoteTableViewCell")
     }

     private func setXForButton (x: CGFloat) {
         createNoteButton.frame.origin.x = x
     }

     private func startButtonAnimation () {
         UIView.animate(withDuration: 0.4, delay: 0.3) { [self] in
             setXForButton(x: Constants.xAfterAnimation)
         } completion: { _ in
             Constants.isButtonShow = true
         }
     }

     @objc private func createNoteButtonPressed() {
         array.append(Int.random(in: 11...222))
         Constants.isButtonShow = false
         guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "EditingViewController") as? EditingViewController else { return }
         self.navigationController?.pushViewController(controller, animated: true)
     }

 }

 //MARK: - extension Delegate, DataSource
 extension OverviewListViewController: UITableViewDelegate, UITableViewDataSource {

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)

         guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "EditingViewController") as? EditingViewController else { return }
         self.navigationController?.pushViewController(controller, animated: true)
     }

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             array.remove(at: indexPath.row)
             listOfNotesTableView.deleteRows(at: [indexPath], with: .automatic)
         }
     }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         Constants.heightForRow
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         array.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell else {return UITableViewCell()}
         let text = "\(array[indexPath.row])"
         cell.configure(with: text)
         return cell
     }
 }
