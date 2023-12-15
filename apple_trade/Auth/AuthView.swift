//
//  ContentView.swift
//  apple_trade
//
// Created by Öykü Hazer Ekinci on 04.11.2023.

import SwiftUI
import FirebaseAuth
import Combine

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        VStack {
            Image("applemain")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            Text("Welcome back!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)

            Text("Please enter your details to log in or sign up")
                .foregroundColor(.gray)
                .padding(.bottom, 70)

            TextField("Email Address", text: $viewModel.user.email)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(viewModel.isValidEmail(viewModel.user.email) || viewModel.user.email.isEmpty ? Color.gray : Color.black, lineWidth: 1)
                )
                .padding(.horizontal)

            ZStack(alignment: .trailing) {
                if viewModel.isSecureTextEntry {
                    SecureField("Password", text: $viewModel.user.password)
                } else {
                    TextField("Password", text: $viewModel.user.password)
                }
                Button(action: {
                    viewModel.isSecureTextEntry.toggle()
                }) {
                    Image(systemName: viewModel.isSecureTextEntry ? "eye.slash" : "eye")
                        .foregroundColor(.secondary)
                }
                .padding(.trailing, 10)
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(viewModel.isValidPassword(viewModel.user.password) || viewModel.user.password.isEmpty ? Color.gray : Color.black, lineWidth: 1)
            )
            .padding(.horizontal)
            .padding(.top, 20)
            .textContentType(.password)

            Button(action: {
                if viewModel.isSignUp {
                    viewModel.signUp()
                } else {
                    viewModel.signIn()
                }
            }) {
                Text(viewModel.isSignUp ? "Sign Up" : "Log In")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.top, 40)

            HStack {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .padding(.horizontal)

                Text("or")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 40)

                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .padding(.horizontal)
            }
            .padding(.vertical, 20)

            Button(action: {
                viewModel.isSignUp.toggle()
            }) {
                Text(viewModel.isSignUp ? "Log In" : "Sign Up")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 3)
                            .background(Color.white)
                    )
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.top, 0)
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Message"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

