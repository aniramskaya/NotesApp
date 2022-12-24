import UIKit

final class EditingViewController: UIViewController {
    //MARK: - let/var
    //    private var dataStoreManager = DataStoreManager()
    var titleNote: String = ""
    var contentNote: String = ""
    var dateNote: Date = Date()
    var indexPath: IndexPath?
    var isOldNote = false
    var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.rounded()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    var textFormattingButtons = TextFormattingButtons()

    //Для определения сдвига popUpView
    var keyboardFrameSize: CGRect?

    //Для корректной работы textViewDidChange. Чтобы не сбрасывались пользовательские атрибуты
    var isAnyButtonPressed = false

    //Нужен для передачи данных между контроллерами
    var noteData: ((_ contentNote: NSMutableAttributedString,_ dateCreateNote: Date, IndexPath?) -> Void)?

    //MARK: - IBOutlet
    @IBOutlet weak var textNoteTextView: UITextView!

    //MARK: - life cycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenterForKeyboard()
//        dataStoreManager.configureFetchResultController()
        getTextForNote()
        textNoteTextView.delegate = self

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configure()
    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let dateCreate = Date()
        noteData?(NSMutableAttributedString.init(attributedString: textNoteTextView.attributedText), dateCreate, indexPath)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func configure() {

        textFormattingButtons = TextFormattingButtons(frame: .zero)

        view.addSubview(textFormattingButtons)
        textFormattingButtons.setupConstraintsPopUpView()

        textFormattingButtons.boldButton.addTarget(self, action: #selector(makesTheFontBold), for: .touchUpInside)
        textFormattingButtons.underlineButton.addTarget(self, action: #selector(makesTheFontUnderlined), for: .touchUpInside)
        textFormattingButtons.strikethroughButton.addTarget(self, action: #selector(makesTheFontStrikethrough), for: .touchUpInside)
        textFormattingButtons.italicButton.addTarget(self, action: #selector(makesTheFontItalic), for: .touchUpInside)
        textFormattingButtons.largerFontSizeButton.addTarget(self, action: #selector(increaseTheFontSize), for: .touchUpInside)
        textFormattingButtons.smallerFontSizeButton.addTarget(self, action: #selector(reducineTheFontSize), for: .touchUpInside)
        textFormattingButtons.addPhoto.addTarget(self, action: #selector(addPhotoTapDetected), for: .touchUpInside)
    }

    func setupNotificationCenterForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    @objc func keyboardWillShow(_ notification: Notification) {

        let userInfo = notification.userInfo
        keyboardFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

        let contentShiftUp = (view.frame.height - (textFormattingButtons.frame.height * 2) - (keyboardFrameSize?.height ?? 0))
        textNoteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: contentShiftUp, right: 0)

        popUpViewFollowTheKeyboardWhenShow()

    }

    func popUpViewFollowTheKeyboardWhenShow() {
        let bottomEdge = view.frame.height - textFormattingButtons.frame.height
        let heightKeyboardAndPopUpView = (keyboardFrameSize?.minY ?? bottomEdge) - textFormattingButtons.frame.height
        textFormattingButtons.frame.origin.y = heightKeyboardAndPopUpView
    }

    @objc func keyboardWillHide() {
        textFormattingButtons.frame.origin.y = view.frame.height - textFormattingButtons.frame.height
    }

    func getTextForNote() {
        if isOldNote, indexPath != nil {
//            let note = dataStoreManager.fetchResultController.object(at: indexPath!)
//            textNoteTextView.attributedText = note.content
        } else {
            textNoteTextView.text = ""
            addAttributesInTextView()
        }
    }

//    Нужен для выделения заголовка - им является первый параграф заметки
    private func getNoteTitle(text: String) -> String {
        var firstParagraph: String
        if let endIndexOfFirstParagraph = text.firstIndex(of: "\n") {
            firstParagraph = String(text[..<endIndexOfFirstParagraph])
        } else {
            firstParagraph = text
        }
        return firstParagraph
    }

//    Нужен для выделения содержания - им является текст после первого параграфа заметки
    private func getNoteContent(text: String) -> String {
        var contentNote: String
        if let endIndexOfFirstParagraph = text.firstIndex(of: "\n") {
            let firstIndexOfContent = text.index(endIndexOfFirstParagraph, offsetBy: 1)
            contentNote = String(text[firstIndexOfContent...])
        } else {
            contentNote = ""
        }
        return contentNote
    }

    func addAttributesInTextView() {

        let textStorage = textNoteTextView.textStorage

        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        let boldFontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold)

        let boldFont = UIFont(descriptor: boldFontDescriptor!, size: 24)
        let normalFont = UIFont(descriptor: fontDescriptor, size: 20)

        //Нужно для определения длинны первого параграфа и остальных параграфов
        let firstParagraph = textStorage.mutableString.paragraphRange(for: NSRange(location: 0, length: 0))
        let otherParagraphs = NSString(string: getNoteContent(text: textNoteTextView.text))

        let titleNoteParagraphStyle = NSMutableParagraphStyle()
        let contentNoteParagraphsStyle = NSMutableParagraphStyle()

        //Атрибуты заголовка заметки (Первый абзац)
        textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: titleNoteParagraphStyle, range: firstParagraph)
        textStorage.addAttribute(NSAttributedString.Key.font, value: boldFont, range: firstParagraph)

        //Атрибуты содержания заметки (Текст начиная со второго абзаца)
        if textNoteTextView.text.contains("\n") {
            textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: contentNoteParagraphsStyle, range: NSRange(location: firstParagraph.length - 1, length: otherParagraphs.length + 1))
            textStorage.addAttribute(NSAttributedString.Key.font, value: normalFont, range: NSRange(location: firstParagraph.length - 1, length: otherParagraphs.length + 1))
        }
    }

    @objc func increaseTheFontSize() {

        if textNoteTextView != nil {

            isAnyButtonPressed = true

            let selectedRange = textNoteTextView.selectedRange
            guard NSLocationInRange(selectedRange.location, selectedRange) else { return }

            //Определение аттрибутов выделенного текста
            let attributesOfSelectedRange = textNoteTextView.textStorage.attributes(at: selectedRange.location, longestEffectiveRange: nil, in: selectedRange)
            guard let fontOfSelectedRange = attributesOfSelectedRange[NSAttributedString.Key.font] as? UIFont else { return }

            let plusOne = fontOfSelectedRange.pointSize + 1
            let increaseFontSize = fontOfSelectedRange.withSize(plusOne)

            textNoteTextView.textStorage.addAttribute(NSAttributedString.Key.font, value: increaseFontSize, range: NSRange(location: selectedRange.location, length: selectedRange.length))
        }
    }

    @objc func reducineTheFontSize() {

        if textNoteTextView != nil {

            isAnyButtonPressed = true

            let selectedRange = textNoteTextView.selectedRange
            guard NSLocationInRange(selectedRange.location, selectedRange) else { return }

            //Определение аттрибутов выделенного текста
            let attributesOfSelectedRange = textNoteTextView.textStorage.attributes(at: selectedRange.location, longestEffectiveRange: nil, in: selectedRange)
            guard let fontOfSelectedRange = attributesOfSelectedRange[NSAttributedString.Key.font] as? UIFont else { return }

            let minusOne = fontOfSelectedRange.pointSize - 1
            let increaseFontSize = fontOfSelectedRange.withSize(minusOne)

            textNoteTextView.textStorage.addAttribute(NSAttributedString.Key.font, value: increaseFontSize, range: NSRange(location: selectedRange.location, length: selectedRange.length))
        }
    }

    @objc func makesTheFontBold() {

        if textNoteTextView != nil {

            isAnyButtonPressed = true

            let selectedRange = textNoteTextView.selectedRange
            let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            let boldFontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold)!
            let italicFontDescriptor = fontDescriptor.withSymbolicTraits(.traitItalic)!
            let italicBoldFontDescriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(arrayLiteral: .traitBold, .traitItalic))

            guard NSLocationInRange(selectedRange.location, selectedRange) else { return }

            //Определение аттрибутов выделенного текста
            let attributesOfSelectedRange = textNoteTextView.textStorage.attributes(at: selectedRange.location, longestEffectiveRange: nil, in: selectedRange)
            guard let fontOfSelectedRange = attributesOfSelectedRange[NSAttributedString.Key.font] as? UIFont else { return }
            let pointOfSizeSelectedFont = fontOfSelectedRange.pointSize
            let symbolicTraitsOfSelectedFont = fontOfSelectedRange.fontDescriptor.symbolicTraits

            let normalFont = UIFont(descriptor: fontDescriptor, size: pointOfSizeSelectedFont)
            let boldFont = UIFont(descriptor: boldFontDescriptor, size: pointOfSizeSelectedFont)
            let italicFont = UIFont(descriptor: italicFontDescriptor, size: pointOfSizeSelectedFont)
            let italicBoldFont = UIFont(descriptor: italicBoldFontDescriptor!, size: pointOfSizeSelectedFont)

            textNoteTextView.textStorage.addAttribute(NSAttributedString.Key.font, value: boldFont, range: NSRange(location: selectedRange.location, length: selectedRange.length))

            if symbolicTraitsOfSelectedFont == UIFontDescriptor.SymbolicTraits(arrayLiteral: .traitBold, .traitItalic) {
                textNoteTextView.textStorage.addAttribute(NSAttributedString.Key.font, value: italicFont, range: NSRange(location: selectedRange.location, length: selectedRange.length))
                textFormattingButtons.italicButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
                textFormattingButtons.boldButton.backgroundColor = .white

            } else if symbolicTraitsOfSelectedFont == .traitItalic {
                textNoteTextView.textStorage.addAttribute(NSAttributedString.Key.font, value: italicBoldFont, range: NSRange(location: selectedRange.location, length: selectedRange.length))
                textFormattingButtons.boldButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
                textFormattingButtons.italicButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)

            } else if symbolicTraitsOfSelectedFont == .traitBold {
                textNoteTextView.textStorage.addAttribute(NSAttributedString.Key.font, value: normalFont, range: NSRange(location: selectedRange.location, length: selectedRange.length))
                textFormattingButtons.boldButton.backgroundColor = .white

            } else {
                textNoteTextView.textStorage.addAttribute(NSAttributedString.Key.font, value: boldFont, range: NSRange(location: selectedRange.location, length: selectedRange.length))
                textFormattingButtons.boldButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
            }
        }
    }

    @objc func makesTheFontStrikethrough() {

        if textNoteTextView != nil {

            isAnyButtonPressed = true

            let selectedRange = textNoteTextView.selectedRange
            let strikethroughAttributes = NSAttributedString.Key.strikethroughStyle

            guard NSLocationInRange(selectedRange.location, selectedRange) else { return }
            let attributesOfSelectedRange = textNoteTextView.textStorage.attributes(at: selectedRange.location, longestEffectiveRange: nil, in: selectedRange)

            let valueSymbolicTraitsOfSelectedRange = attributesOfSelectedRange[NSAttributedString.Key.strikethroughStyle] as? Int ?? 0

            if valueSymbolicTraitsOfSelectedRange == 1 {
                textNoteTextView.textStorage.addAttribute(strikethroughAttributes, value: 0, range: NSRange(location: selectedRange.location, length: selectedRange.length))
                textFormattingButtons.strikethroughButton.backgroundColor = .white
            } else {
                textNoteTextView.textStorage.addAttribute(strikethroughAttributes, value: 1, range: NSRange(location: selectedRange.location, length: selectedRange.length))
                textFormattingButtons.strikethroughButton.backgroundColor =  #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
            }
        }
    }


    @objc func makesTheFontItalic() {

        if textNoteTextView != nil {

            isAnyButtonPressed = true

            let selectedRange = textNoteTextView.selectedRange
            let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            let boldFontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold)!
            let italicFontDescriptor = fontDescriptor.withSymbolicTraits(.traitItalic)!
            let italicBoldFontDescriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(arrayLiteral: .traitBold, .traitItalic))

            guard NSLocationInRange(selectedRange.location, selectedRange) else { return }
            let attributesOfSelectedRange = textNoteTextView.textStorage.attributes(at: selectedRange.location, longestEffectiveRange: nil, in: selectedRange)
            guard let fontOfSelectedRange = attributesOfSelectedRange[NSAttributedString.Key.font] as? UIFont else { return }
            let pointOfSizeSelectedFont = fontOfSelectedRange.pointSize
            let symbolicTraitsOfSelectedFont = fontOfSelectedRange.fontDescriptor.symbolicTraits

            let normalFont = UIFont(descriptor: fontDescriptor, size: pointOfSizeSelectedFont)
            let boldFont = UIFont(descriptor: boldFontDescriptor, size: pointOfSizeSelectedFont)
            let italicFont = UIFont(descriptor: italicFontDescriptor, size: pointOfSizeSelectedFont)
            let italicBoldFont = UIFont(descriptor: italicBoldFontDescriptor!, size: pointOfSizeSelectedFont)

            if symbolicTraitsOfSelectedFont == UIFontDescriptor.SymbolicTraits(arrayLiteral: .traitBold, .traitItalic) {
                textNoteTextView.textStorage.addAttribute(NSAttributedString.Key.font, value: boldFont, range: NSRange(location: selectedRange.location, length: selectedRange.length))
                textFormattingButtons.boldButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
                textFormattingButtons.italicButton.backgroundColor = .white

            } else if symbolicTraitsOfSelectedFont == .traitItalic {
                textNoteTextView.textStorage.addAttribute(NSAttributedString.Key.font, value: normalFont, range: NSRange(location: selectedRange.location, length: selectedRange.length))
                textFormattingButtons.italicButton.backgroundColor = .white

            } else if symbolicTraitsOfSelectedFont == .traitBold {
                textNoteTextView.textStorage.addAttribute(NSAttributedString.Key.font, value: italicBoldFont, range: NSRange(location: selectedRange.location, length: selectedRange.length))
                textFormattingButtons.boldButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
                textFormattingButtons.italicButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)

            } else {
                textNoteTextView.textStorage.addAttribute(NSAttributedString.Key.font, value: italicFont, range: NSRange(location: selectedRange.location, length: selectedRange.length))
                textFormattingButtons.italicButton.backgroundColor =  #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
            }
        }
    }

    @objc func makesTheFontUnderlined() {

        if textNoteTextView != nil {

            isAnyButtonPressed = true

            let selectedRange = textNoteTextView.selectedRange
            let underlineAttributes = NSAttributedString.Key.underlineStyle

            guard NSLocationInRange(selectedRange.location, selectedRange) else { return }
            let attributesOfSelectedRange = textNoteTextView.textStorage.attributes(at: selectedRange.location, longestEffectiveRange: nil, in: selectedRange)

            let valueSymbolicTraitsOfSelectedRange = attributesOfSelectedRange[NSAttributedString.Key.underlineStyle] as? Int ?? 0

            if valueSymbolicTraitsOfSelectedRange == 1 {
                textNoteTextView.textStorage.addAttribute(underlineAttributes, value: 0, range: NSRange(location: selectedRange.location, length: selectedRange.length))
                textFormattingButtons.underlineButton.backgroundColor = .white

            } else {
                textNoteTextView.textStorage.addAttribute(underlineAttributes, value: 1, range: NSRange(location: selectedRange.location, length: selectedRange.length))
                textFormattingButtons.underlineButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
            }
        }
    }

    @objc func addPhotoTapDetected() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

}
//MARK: - UITextViewDelegate
extension EditingViewController: UITextViewDelegate{

    func textViewDidChange(_ textView: UITextView) {
        if !isAnyButtonPressed {
            addAttributesInTextView()
        }
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        let selectedRange = textNoteTextView.selectedRange
        var attributesOfSelectedRange = [NSAttributedString.Key : Any]()
        var fontOfSelectedRange = UIFont()

        let rangeText = NSRange(location: 0, length: textView.textStorage.length)
        guard NSLocationInRange(selectedRange.location - 1, rangeText) else { return }

        //Без этого условия не корректно отображает атрибуты при перемещении указателя / выделении участка текста
        if selectedRange.length == 0 {
            attributesOfSelectedRange = textNoteTextView.textStorage.attributes(at: selectedRange.location - 1, longestEffectiveRange: nil, in: selectedRange)
        } else {
            attributesOfSelectedRange = textNoteTextView.textStorage.attributes(at: selectedRange.location, longestEffectiveRange: nil, in: selectedRange)
        }

        let underlineStyle = attributesOfSelectedRange[NSAttributedString.Key.underlineStyle] as? Int ?? 0

        if underlineStyle == 1 {
            textFormattingButtons.underlineButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        } else {
            textFormattingButtons.underlineButton.backgroundColor = .white
        }


        let strikethroughStyle = attributesOfSelectedRange[NSAttributedString.Key.strikethroughStyle] as? Int ?? 0

        if strikethroughStyle == 1 {
            textFormattingButtons.strikethroughButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        } else {
            textFormattingButtons.strikethroughButton.backgroundColor = .white
        }

        fontOfSelectedRange = attributesOfSelectedRange[NSAttributedString.Key.font] as! UIFont
        let symbolicTraitsOfSelectedFont = fontOfSelectedRange.fontDescriptor.symbolicTraits

        if symbolicTraitsOfSelectedFont == UIFontDescriptor.SymbolicTraits(arrayLiteral: .traitBold, .traitItalic) {
            textFormattingButtons.boldButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
            textFormattingButtons.italicButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)

        } else if symbolicTraitsOfSelectedFont == .traitItalic {
            textFormattingButtons.italicButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
            textFormattingButtons.boldButton.backgroundColor = .white

        } else if symbolicTraitsOfSelectedFont == .traitBold {
            textFormattingButtons.boldButton.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
            textFormattingButtons.italicButton.backgroundColor = .white

        } else {
            textFormattingButtons.boldButton.backgroundColor = .white
            textFormattingButtons.italicButton.backgroundColor = .white
        }
    }

}

//MARK: - extension ImagePickerControllerDelegate
extension EditingViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            icon.image = image
            icon.frame.size.width = textNoteTextView.bounds.size.width
            icon.frame.size.height = 100
            self.textNoteTextView.addSubview(icon)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            icon.image = image
            icon.frame.size.width = textNoteTextView.bounds.size.width
            icon.frame.size.height = 100
            self.textNoteTextView.addSubview(icon)
        }
        picker.dismiss(animated: true)
    }

}

