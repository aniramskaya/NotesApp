import UIKit
/*
final class TextFormattingButtons: UIView {

    //MARK: - var\let
    lazy var sizeViewCategory = CGSize(width: 88, height: 32)

    lazy var lineSpacing:CGFloat = 8

    lazy var categoriesArray = [
        "textformat.size.larger",
        "textformat.size.smaller",
        "bold",
        "italic",
        "underline",
        "strikethrough",
        "camera"
    ]

    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    //MARK: - life cycle funcs
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size = CGSize(width: bounds.width, height: sizeViewCategory.height * 1.5)
        collection.frame = .init(x: 0, y: 0, width: size.width, height: size.height)
    }

    //MARK: - flow funcs
    private func setup() {
        collection.delegate = self
        collection.dataSource = self
        collection.register(CategoriesViewCell.self, forCellWithReuseIdentifier: "CategoriesViewCell")
        addSubview(collection)
        collection.backgroundColor = .lightGray
    }

    func setupConstraints() {
//        setupConstraintsButtonsInStackViewFormattingText()
        setupConstraintsForStackViewFormatingText()
    }

//    func setupConstraintsButtonsInStackViewFormattingText() {
//        for button in stackViewForFormattingText.arrangedSubviews {
//            button.widthAnchor.constraint(equalTo: boldButton.widthAnchor).isActive = true
//            button.heightAnchor.constraint(equalToConstant: 35).isActive = true
//        }
//    }


    func setupConstraintsForStackViewFormatingText() {
        collection.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        collection.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        collection.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        collection.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
    }

    func setupConstraintsPopUpView() {

        guard let superview = superview else { return }

        self.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
}

//MARK: - extension
extension TextFormattingButtons: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: lineSpacing * 2, bottom: 0, right: lineSpacing * 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeViewCategory
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoriesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesViewCell", for: indexPath) as? CategoriesViewCell else {return UICollectionViewCell()}
        cell.configure(with: categoriesArray[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let cell = collectionView.cellForItem(at: indexPath) as? CategoriesViewCell {
            cell.didSelectItem()
        }

        let message = ["indexPath" : indexPath]
        NotificationCenter.default.post(name: NSNotification.Name("didSelectCategory"), object: nil, userInfo: message)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoriesViewCell {
            cell.didDeselectItem()
        }
    }
}

*/



















 import UIKit

 final class TextFormattingButtons: UIView {

     //MARK: - var\let
     let largerFontSizeButton = UIButton(type: .system)
     let smallerFontSizeButton = UIButton(type: .system)
     let boldButton = UIButton(type: .system)
     let italicButton = UIButton(type: .system)
     let underlineButton = UIButton(type: .system)
     let strikethroughButton = UIButton(type: .system)
     let addPhoto = UIButton(type: .system)

     lazy var stackViewForFormattingText: UIStackView = {

         let stackView = UIStackView(arrangedSubviews: [boldButton, italicButton, underlineButton, strikethroughButton, largerFontSizeButton, smallerFontSizeButton, addPhoto])
         stackView.translatesAutoresizingMaskIntoConstraints = false
         stackView.axis = .horizontal
         stackView.spacing = 10
         stackView.distribution = .fill
         stackView.alignment = .fill

         return stackView
     }()

     let flexibleSpaceBar: UIBarButtonItem = {
         let flexibleSpaceBar = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         return flexibleSpaceBar
     }()

     //MARK: - life cycle funcs
     override init(frame: CGRect) {
         super.init(frame: frame)

         self.translatesAutoresizingMaskIntoConstraints = false
         self.backgroundColor = UIColor(red: 209/255, green: 212/255, blue: 214/255, alpha: 1)
         configure()
         setupViews()
         setupConstraints()
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     //MARK: - flow funcs
     func configure() {
         largerFontSizeButton.setup(with: "textformat.size.larger")
         smallerFontSizeButton.setup(with: "textformat.size.smaller")
         boldButton.setup(with: "bold")
         italicButton.setup(with: "italic")
         underlineButton.setup(with: "underline")
         strikethroughButton.setup(with: "strikethrough")
         addPhoto.setup(with: "camera")
     }

     func setupViews() {
         self.addSubview(stackViewForFormattingText)
     }

     func setupConstraints() {
         setupConstraintsButtonsInStackViewFormattingText()
         setupConstraintsForStackViewFormatingText()
     }

     func setupConstraintsButtonsInStackViewFormattingText() {
         for button in stackViewForFormattingText.arrangedSubviews {
             button.widthAnchor.constraint(equalTo: boldButton.widthAnchor).isActive = true
             button.heightAnchor.constraint(equalToConstant: 35).isActive = true
         }
     }


     func setupConstraintsForStackViewFormatingText() {
         stackViewForFormattingText.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
         stackViewForFormattingText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
         stackViewForFormattingText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
         stackViewForFormattingText.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
     }

     func setupConstraintsPopUpView() {

         guard let superview = superview else { return }

         self.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
         self.leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor).isActive = true
         self.rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor).isActive = true
         self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
     }
 }

 
