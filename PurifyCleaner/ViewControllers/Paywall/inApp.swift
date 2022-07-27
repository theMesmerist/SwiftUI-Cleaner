import UIKit

class inApp: UIViewController, UIGestureRecognizerDelegate {
    let monthlyBtn = UIView()
    let annunalBtn = UIView()
    var selectedPrice = "Annunal"
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultSize(view: view)
        addBg(view: view)
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(backBtnTapped), name: Notification.Name("present"), object: nil)
        
    }

    func setupUI() {
        let inAppImg = UIImageView()
        inAppImg.frame = CGRect(x: 0.2 * screenWidth, y: 0.1 * screenHeight, width: 0.6 * screenWidth, height: 0.6 * screenWidth)
        inAppImg.image = UIImage(named: "img_inapp")
        inAppImg.contentMode = .scaleAspectFit
        view.addSubview(inAppImg)

        let crossBtn = UIButton()
        crossBtn.frame = CGRect(x: 0.05 * screenWidth, y: 0.1 * screenHeight, width: 0.1 * screenWidth, height: 0.1 * screenWidth)
        crossBtn.setImage(UIImage(named: "btn_cross_close"), for: .normal)
        crossBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        view.addSubview(crossBtn)

        let titleLabel = UILabel()
        titleLabel.text = "Open\nunlimited access!"
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Poppins-Regular", size: 24 * stringMultiplier)
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 0.2 * screenWidth, y: 0.28 * screenHeight, width: 0.6 * screenWidth, height: 0.3 * screenWidth)
        view.addSubview(titleLabel)

        let topicLabel1 = UILabel()
        topicLabel1.text = "Detecting unlimited duplicated screenshots and photographs."
        topicLabel1.font = UIFont(name: "Poppins-Regular", size: 16)
        topicLabel1.numberOfLines = 0
        topicLabel1.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.00)
        topicLabel1.numberOfLines = 0
        topicLabel1.textAlignment = .left
        topicLabel1.frame = CGRect(x: 0.15 * screenWidth, y: 0.405 * screenHeight, width: 0.7 * screenWidth, height: 0.15 * screenWidth)
        view.addSubview(topicLabel1)

        let topicLabelDot1 = UILabel()
        topicLabelDot1.text = "\u{2022}"
        topicLabelDot1.font = UIFont(name: "Poppins-Regular", size: 32)
        topicLabelDot1.textColor = UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00)
        topicLabelDot1.numberOfLines = 0
        topicLabelDot1.textAlignment = .left
        topicLabelDot1.frame = CGRect(x: 0.1 * screenWidth, y: 0.415 * screenHeight, width: 0.6 * screenWidth, height: 0.05 * screenWidth)
        view.addSubview(topicLabelDot1)

        let topicLabel2 = UILabel()
        topicLabel2.text = "Much more storage area for you to put private photos and videos."
        topicLabel2.font = UIFont(name: "Poppins-Regular", size: 16)
        topicLabel2.numberOfLines = 0
        topicLabel2.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.00)
        topicLabel2.numberOfLines = 0
        topicLabel2.textAlignment = .left
        topicLabel2.frame = CGRect(x: 0.15 * screenWidth, y: 0.475 * screenHeight, width: 0.7 * screenWidth, height: 0.15 * screenWidth)
        view.addSubview(topicLabel2)

        let topicLabelDot2 = UILabel()
        topicLabelDot2.text = "\u{2022}"
        topicLabelDot2.font = UIFont(name: "Poppins-Regular", size: 32)
        topicLabelDot2.textColor = UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00)
        topicLabelDot2.numberOfLines = 0
        topicLabelDot2.textAlignment = .left
        topicLabelDot2.frame = CGRect(x: 0.1 * screenWidth, y: 0.485 * screenHeight, width: 0.6 * screenWidth, height: 0.05 * screenWidth)
        view.addSubview(topicLabelDot2)

        let topicLabel3 = UILabel()
        topicLabel3.text = "Gigabytes of space will be freed up on your memory card."
        topicLabel3.font = UIFont(name: "Poppins-Regular", size: 16)
        topicLabel3.numberOfLines = 0
        topicLabel3.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.00)
        topicLabel3.numberOfLines = 0
        topicLabel3.textAlignment = .left
        topicLabel3.frame = CGRect(x: 0.15 * screenWidth, y: 0.545 * screenHeight, width: 0.7 * screenWidth, height: 0.15 * screenWidth)
        view.addSubview(topicLabel3)

        let topicLabelDot3 = UILabel()
        topicLabelDot3.text = "\u{2022}"
        topicLabelDot3.font = UIFont(name: "Poppins-Regular", size: 32)
        topicLabelDot3.textColor = UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00)
        topicLabelDot3.numberOfLines = 0
        topicLabelDot3.textAlignment = .left
        topicLabelDot3.frame = CGRect(x: 0.1 * screenWidth, y: 0.555 * screenHeight, width: 0.6 * screenWidth, height: 0.05 * screenWidth)
        view.addSubview(topicLabelDot3)

        annunalBtn.frame = CGRect(x: 0.05 * screenWidth, y: 0.65 * screenHeight, width: 0.9 * screenWidth, height: 0.08 * screenHeight)
        annunalBtn.backgroundColor = .white
        annunalBtn.layer.borderWidth = 1
        annunalBtn.layer.borderColor = UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00).cgColor
        view.addSubview(annunalBtn)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(annunalBtnTapped))
        gesture.delegate = self
        annunalBtn.addGestureRecognizer(gesture)

        let annunalLbl = UILabel()
        annunalLbl.frame = CGRect(x: 0.36 * screenWidth, y: 0.01 * screenHeight, width: 0.2 * screenWidth, height: 0.08 * screenWidth)
        annunalLbl.text = "$59.99"
        annunalLbl.textAlignment = .center
        annunalLbl.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.00)
        annunalLbl.font = UIFont(name: "Poppins-Medium", size: 18)
        annunalBtn.addSubview(annunalLbl)

        let annunalLbl2 = UILabel()
        annunalLbl2.frame = CGRect(x: 0.2 * screenWidth, y: 0.03 * screenHeight, width: 0.5 * screenWidth, height: 0.08 * screenWidth)
        annunalLbl2.text = "12 Months Subscription"
        annunalLbl2.font = UIFont(name: "Poppins-Medium", size: 14)
        annunalLbl2.textAlignment = .center
        annunalLbl2.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.50)
        annunalBtn.addSubview(annunalLbl2)

        monthlyBtn.frame = CGRect(x: 0.05 * screenWidth, y: 0.75 * screenHeight, width: 0.9 * screenWidth, height: 0.08 * screenHeight)
        monthlyBtn.backgroundColor = .white
        monthlyBtn.layer.borderWidth = 0
        monthlyBtn.layer.borderColor = UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00).cgColor
        view.addSubview(monthlyBtn)

        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(monthlyGestureTapped))
        gesture2.delegate = self
        monthlyBtn.addGestureRecognizer(gesture2)

        let monthlyLbl = UILabel()
        monthlyLbl.frame = CGRect(x: 0.36 * screenWidth, y: 0.01 * screenHeight, width: 0.2 * screenWidth, height: 0.08 * screenWidth)
        monthlyLbl.text = "$6.99"
 /*       _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            monthlyLbl.text = priceMonthly
        }*/
        monthlyLbl.textAlignment = .center
        monthlyLbl.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.00)
        monthlyLbl.font = UIFont(name: "Poppins-Medium", size: 18)
        monthlyBtn.addSubview(monthlyLbl)

        let monthlyLbl2 = UILabel()
        monthlyLbl2.frame = CGRect(x: 0.2 * screenWidth, y: 0.03 * screenHeight, width: 0.5 * screenWidth, height: 0.08 * screenWidth)
        monthlyLbl2.text = "1 Month Subscription"
        monthlyLbl2.font = UIFont(name: "Poppins-Medium", size: 14)
        monthlyLbl2.textAlignment = .center
        monthlyLbl2.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.50)
        monthlyBtn.addSubview(monthlyLbl2)

        let nextBtn = UIButton()
        nextBtn.frame = CGRect(x: 0.05 * screenWidth, y: 0.85 * screenHeight, width: 0.9 * screenWidth, height: 0.15 * screenWidth)
        nextBtn.setTitle("Buy Now", for: .normal)
        nextBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 16)
        nextBtn.backgroundColor = UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00)
        nextBtn.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        view.addSubview(nextBtn)

        let termsBtn = UIButton()
        termsBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        termsBtn.contentVerticalAlignment.self = .center
        termsBtn.contentHorizontalAlignment.self = .center
        termsBtn.backgroundColor = .clear
        termsBtn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
        termsBtn.setTitle("Terms & Conditions", for: .normal)
        termsBtn.addTarget(self, action: #selector(termsBtnClicked), for: UIControl.Event.touchUpInside)
        termsBtn.frame = CGRect(x: 0.05 * screenWidth, y: 0.92 * screenHeight, width: 0.45 * screenWidth, height: 0.15 * screenWidth)
        view.addSubview(termsBtn)

        let restoreBtn = UIButton()
        restoreBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        restoreBtn.contentVerticalAlignment.self = .center
        restoreBtn.contentHorizontalAlignment.self = .center
        restoreBtn.backgroundColor = .clear
        restoreBtn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
        restoreBtn.setTitle("Restore", for: .normal)
        restoreBtn.addTarget(self, action: #selector(restoreBtnClicked), for: UIControl.Event.touchUpInside)
        restoreBtn.frame = CGRect(x: 0.65 * screenWidth, y: 0.92 * screenHeight, width: 0.35 * screenWidth, height: 0.15 * screenWidth)
        view.addSubview(restoreBtn)
    }
    

    @objc func annunalBtnTapped() {
        annunalBtn.layer.borderWidth = 1
        monthlyBtn.layer.borderWidth = 0
         selectedPrice = "Annunal"
    }

    @objc func monthlyGestureTapped() {
        annunalBtn.layer.borderWidth = 0
        monthlyBtn.layer.borderWidth = 1
         selectedPrice = "Monthly"
    }

    @objc func nextBtnTapped() {
        if selectedPrice == "Annunal" {
            StoreKitOperations().purchaseProduct(productID: "unlock.cleaner.annual", viewController: self)
        } else {
            StoreKitOperations().purchaseProduct(productID: "unlock.cleaner.monthly", viewController: self)
        }
    }

    @objc func backBtnTapped() {
        performSegue(withIdentifier: "inAppToMain", sender: nil)
    }

    @objc func termsBtnClicked() {
        if let url = URL(string: "https://sites.google.com/view/purify-smart-cleaner/terms-of-use") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }

    }

    @objc func restoreBtnClicked() {
        StoreKitOperations().restorePurchase(viewController: self)
    }
}
