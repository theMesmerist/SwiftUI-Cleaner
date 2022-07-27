//
//  PasswordView.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 9.06.2022.
//

import SwiftUI

struct PasswordView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = ViewModel()
    @State var isFocused = false

    @State var isOtpFull = false

    let textBoxWidth = UIScreen.main.bounds.width / 8
    let textBoxHeight = UIScreen.main.bounds.width / 8
    let spaceBetweenBoxes: CGFloat = 10
    let paddingOfBox: CGFloat = 1
    var textFieldOriginalWidth: CGFloat {
        (textBoxWidth * 6) + (spaceBetweenBoxes * 3) + ((paddingOfBox * 2) * 3)
    }

    var body: some View {
        GeometryReader { _ in
            VStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                            Image("btn_back")
                        })
                }
                    .frame(width: screenWidth * 0.9, height: screenHeight * 0.1, alignment: .leading)
                    .padding(.top, 22)

                Spacer().frame(width: screenWidth, height: 0.1 * screenHeight, alignment: .center)


                VStack {
                    Text("Enter Your Password")
                        .font(.custom("Poppins-Light", size: 32))
                        .padding(.bottom, 10)
                }.padding(.bottom, 40)


                ZStack {
                    HStack (spacing: spaceBetweenBoxes) {
                        otpText(text: viewModel.otp1)
                        otpText(text: viewModel.otp2)
                        otpText(text: viewModel.otp3)
                        otpText(text: viewModel.otp4)
                    }
                    TextField("", text: $viewModel.otpField)
                        .frame(width: isFocused ? 0 : textFieldOriginalWidth, height: textBoxHeight)
                        .disabled(viewModel.isTextFieldDisabled)
                        .textContentType(.oneTimeCode)
                        .foregroundColor(.clear)
                        .accentColor(.clear)
                        .background(Color.clear)
                        .keyboardType(.numberPad)
                        .onChange(of: viewModel.otp4, perform: { newValue in

                        let password = UserDefaults.standard.object(forKey: "Password")
                        if password as! String == viewModel.otpField {
                            isOtpFull.toggle()
                        } else {
                            viewModel.otpField = ""
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                }
                Spacer()
                    .frame(width: screenWidth, height: 0.4 * screenHeight, alignment: .center)
            }
        }.navigationBarHidden(true)
            .ignoresSafeArea(.keyboard, edges: .all)
            .background(Color(bgColor))
            .fullScreenCover(isPresented: $isOtpFull, content: {
            StorageListView()
        })

    }

    private func otpText(text: String) -> some View {
        return
        ZStack {
            Text(text)
                .font(.title)
                .frame(width: textBoxWidth, height: textBoxHeight)
                .background(VStack {
                Spacer()
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Color(UIColor.systemGray3))
            })
                .padding(paddingOfBox)
        }
    }
}


struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView()
    }
}
