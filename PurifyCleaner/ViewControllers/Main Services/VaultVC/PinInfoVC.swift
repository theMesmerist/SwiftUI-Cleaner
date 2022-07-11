import UIKit

class PinInfoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultSize(view: view)
        addBg(view: view)
        
        let nextBtn = UIButton()
        nextBtn.setTitle(NSLocalizedString("Create PIN-code", comment: ""), for: UIControl.State.normal)
        nextBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        nextBtn.backgroundColor = UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00)
        nextBtn.frame = CGRect(x: 0.15 * screenWidth, y: 0.44 * screenHeight, width: 0.7 * screenWidth, height: 0.056 * screenHeight)
        nextBtn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 20 * stringMultiplier)
        nextBtn.addTarget(self, action: #selector(createPinCLicked), for: UIControl.Event.touchUpInside)
        view.addSubview(nextBtn)
        
        let infoBtn = UIButton()
        infoBtn.setTitle(NSLocalizedString("Later", comment: ""), for: UIControl.State.normal)
        infoBtn.setTitleColor(UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.00), for: UIControl.State.normal)
        infoBtn.frame = CGRect(x: 0.15 * screenWidth, y: 0.52 * screenHeight, width: 0.7 * screenWidth, height: 0.056 * screenHeight)
        infoBtn.borderColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00)
        infoBtn.borderWidth = 1
        infoBtn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 20 * stringMultiplier)
        infoBtn.addTarget(self, action: #selector(maybeLaterClicked), for: UIControl.Event.touchUpInside)
        view.addSubview(infoBtn)
        
        let header = UILabel()
        header.text = "Welcome to Secret\nVault"
        header.textAlignment = .center
        header.numberOfLines = 0
        header.font = UIFont(name: "Poppins-Regular", size: 24 * stringMultiplier)
        header.frame = CGRect(x: 0.025 * screenWidth, y: 0.17 * screenHeight, width: 0.95 * screenWidth, height: 0.25 * screenHeight)
        header.textColor = UIColor(red: 0.13, green: 0.12, blue: 0.14, alpha: 1.00)
        view.addSubview(header)
        
        let description = UILabel()
        description.text = "Hide your private photos and videos by creating a strong PIN code."
        description.textAlignment = .center
        description.font = UIFont(name: "Poppins-Regular", size: 20 * stringMultiplier)
        description.frame = CGRect(x: 0.05 * screenWidth, y: 0.25 * screenHeight, width: 0.9 * screenWidth, height: 0.25 * screenHeight)
        description.numberOfLines = 2
        description.textColor = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.00)
        view.addSubview(description)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_storage" {}
    }
    
    @objc func createPinCLicked() {
        performSegue(withIdentifier: "to_storage", sender: nil)
    
    }
    
    @objc func maybeLaterClicked() {
        dismiss(animated: true, completion: nil)
    }
}








