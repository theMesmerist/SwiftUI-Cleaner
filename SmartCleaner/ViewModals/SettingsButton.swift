//
//  SettingsButton.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 2.06.2022.
//

import SwiftUI
import AppTrackingTransparency
import MessageUI

struct SettingsButton: View {

    @State var btnText = ""


    var body: some View {
        Button(action: {
            switch btnText {
            case "Photo Access":
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            case "Share with your friends":
                guard let data = URL(string: "https://www.neonapps.co") else { return }
                let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)

            case "Help & Support":
                EmailPresenter.shared.present()

            case "Terms of Use":
                if let url = URL(string: "https://www.neonapps.co") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }

            case "Privacy Policy":
                if let url = URL(string: "https://www.neonapps.co") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }

            default:
                print("zırla")
            }
        }, label: {

                HStack {
                    Text(btnText)
                        .foregroundColor(.black)

                    Spacer()

                    Image("btn_arrow")
                        .resizable()
                        .frame(width: 0.1 * screenWidth, height: 0.05 * screenHeight, alignment: .center)
                }
                    .padding(.horizontal)

            })
            .frame(width: 0.9 * screenWidth, height: 0.065 * screenHeight, alignment: .center)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 1)
            .padding(.bottom, 10)


    }
}

struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButton()
    }
}
class EmailPresenter: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailPresenter()
    private override init() { }
    
    func present() {
        if !MFMailComposeViewController.canSendMail() {
            let alert = UIAlertController(title: "Email Simulator", message: "Email is not supported on the simulator. This will work on a physical device only.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            RootViewController()?.present(alert, animated: true, completion: nil)
            return
        }
        let picker = MFMailComposeViewController()
        picker.setToRecipients(["support@neonapps.co"])
        picker.mailComposeDelegate = self
        RootViewController()?.present(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        RootViewController()?.dismiss(animated: true, completion: nil)
    }
}

func RootViewController() -> UIViewController? {
    rootController
}

var rootController: UIViewController? {
    var root = UIApplication.shared.windows.first?.rootViewController
    if let presenter = root?.presentedViewController { root = presenter }
    return root
}
