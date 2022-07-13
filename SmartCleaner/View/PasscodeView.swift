//
//  PasscodeViewController.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 8.06.2022.
//


import SwiftUI


struct PasscodeView: View {
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
                    Text("Create Pin Code")
                        .font(.custom("Poppins-Light", size: 32))
                        .padding(.bottom, 10)

                    Text("Set a strong password in order to protect your medias.").multilineTextAlignment(.center)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(UIColor(red: 0.68, green: 0.71, blue: 0.74, alpha: 1.00)))
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
                        UserDefaults.standard.set(viewModel.otpField, forKey: "Password")
                        UserDefaults.standard.set(true, forKey: "passwordExist")
                        isOtpFull.toggle()
                    })
                }
                Spacer()
                    .frame(width: screenWidth, height: 0.4 * screenHeight, alignment: .center)
            }
        } .ignoresSafeArea(.keyboard, edges: .all)
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

struct PasscodeView_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeView()
    }
}

