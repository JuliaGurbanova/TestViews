import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {

    private let label = UILabel()
    private let button = UIButton(type: .system)
    private let imageView = UIImageView()
    private let textField = UITextField()
    private let textView = UITextView()
    private let switchControl = UISwitch()
    private let slider = UISlider()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let segmentedControl = UISegmentedControl(items: ["First", "Second"])
    private let tableView = UITableView()
    private var collectionView: UICollectionView!

    private var items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]

    private var progressTimer: Timer?
    private var currentProgress: Float = 0.0

    private var tapCount: Int = 0

    init() {
        super.init(nibName: nil, bundle: nil)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        setupLabel()
        setupButton()
        setupImageView()
        setupTextField()
        setupTextView()
        setupSwitch()
        setupSlider()
        setupProgressView()
        setupSegmentedControl()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)

        startProgressSimulation()

        segmentedControlChanged()
    }

    // MARK: - ACTIONS

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @objc func segmentedControlChanged() {
        for subview in self.view.subviews {
            if subview is UITableView || subview is UICollectionView {
                subview.removeFromSuperview()
            }
        }

        if segmentedControl.selectedSegmentIndex == 0 {
            setupTableView()
        } else {
            setupCollectionView()
        }
    }

    @objc func buttonTapped() {
        tapCount += 1
        textView.text = "Tapped \(tapCount) times"
    }

    @objc private func highlightButton() {
        UIView.animate(withDuration: 0.2) {
            self.button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        }
    }

    @objc private func unhighlightButton() {
        UIView.animate(withDuration: 0.2) {
            self.button.backgroundColor = .systemBlue
        }
    }

    @objc private func switchToggled() {
        if switchControl.isOn {
            imageView.tintColor = .systemGreen
        } else {
            imageView.tintColor = .magenta
        }
    }

    // MARK: - UI setup

    private func setupLabel() {
        label.text = "This is a UILabel"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .systemMint
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }

    private func setupButton() {
        button.setTitle("Tap Me", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(highlightButton), for: [.touchDown, .touchDragEnter])
        button.addTarget(self, action: #selector(unhighlightButton), for: [.touchUpInside, .touchCancel, .touchDragExit])

        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func setupImageView() {
        imageView.image = UIImage(systemName: "fish.fill")
        imageView.tintColor = .magenta
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setupTextField() {
        textField.placeholder = "Enter text"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupTextView() {
        textView.text = "This is a UITextView"
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            textView.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupSwitch() {
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        self.view.addSubview(switchControl)

        NSLayoutConstraint.activate([
            switchControl.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            switchControl.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20)
        ])
    }

    private func setupSlider() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(slider)

        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            slider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }

    private func setupProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .orange
        self.view.addSubview(progressView)

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }

    private func setupSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        self.view.addSubview(segmentedControl)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
        ])
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        self.view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
        ])
    }


    // MARK: - Delegate functions

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .systemGreen
        let label = UILabel()
        label.text = items[indexPath.row]
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        return cell
    }

    func startProgressSimulation() {
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            self?.currentProgress += 0.01
            if self?.currentProgress ?? 0 >= 1 {
                self?.progressTimer?.invalidate()
            }
            self?.progressView.setProgress(self?.currentProgress ?? 0, animated: true)
        }
    }
}
