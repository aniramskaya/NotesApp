import UIKit

final class CategoriesViewCell: UICollectionViewCell {

    //MARK: - var\let
    let view = UIView()
    let imageView = UIImageView()

    //MARK: - flow funcs
    func configure(with name: String) {

        view.addSubview(imageView)
        contentView.addSubview(view)

        imageView.image = UIImage(systemName: name)

        view.backgroundColor = .lightGray
        view.layer.borderColor = UIColor.lightPink.cgColor
        view.layer.borderWidth = 1
        view.rounded(radius: contentView.frame.height/2)

        setConstraint()
    }

    func setConstraint() {
        view.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    func didSelectItem() {
        view.backgroundColor = .lightPink
        imageView.tintColor = .darkPink
    }

    func didDeselectItem() {
        view.backgroundColor = .lightGray
        imageView.tintColor = .lightPink
    }
}
