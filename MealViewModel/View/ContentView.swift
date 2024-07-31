// ContentView.swift
// Fetch Meals
//
// Created by Rushikesh Dalvi on 07/30/24.

import SwiftUI
import Intents
import Speech
import AVFoundation

struct ContentView: View {
    @StateObject var viewModel = MealsViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.meals, id: \.id) { meal in
                NavigationLink(destination: MealDetailView(viewModel: viewModel, meal: meal)) {
                    HStack {
                        if let strMealThumb = meal.strMealThumb, let url = URL(string: strMealThumb) {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } else if phase.error != nil {
                                    Text("Image Load Error")
                                        .frame(width: 100, height: 100)
                                } else {
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                }
                            }
                        }

                        VStack(alignment: .leading) {
                            Text(meal.strMeal)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationBarTitle("Desserts")
        }
        .task {
            await viewModel.fetchDessertMeals() // Use async fetching
        }
    }
}

import SwiftUI
import AVFoundation

struct MealDetailView: View {
    @ObservedObject var viewModel: MealsViewModel
    var meal: Meal

    @State private var isLoading: Bool = true
    @State private var isImageTapped: Bool = false
    @State private var isPlaying: Bool = false
    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                // Name of the recipe
                Text(meal.strMeal)
                    .font(.largeTitle)
                    .bold()
                    .padding(.vertical, 10)
                    .foregroundColor(.primary)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)

                // Meal Image
                if let strMealThumb = meal.strMealThumb, let url = URL(string: strMealThumb) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4)) // Add a white border
                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                                .onTapGesture {
                                    isImageTapped.toggle()
                                }
                        } else if phase.error != nil {
                            Text("Image Load Error")
                                .foregroundColor(.red)
                        } else {
                            ProgressView()
                        }
                    }
                    .padding(.vertical, 10)
                    .sheet(isPresented: $isImageTapped) {
                        // Full-screen version of the image in a modal view
                        if let strMealThumb = meal.strMealThumb, let url = URL(string: strMealThumb) {
                            VStack {
                                Text("\(meal.strMeal)")
                                    .font(.headline)
                                    .bold()
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } else if phase.error != nil {
                                        Text("Image Load Error")
                                            .foregroundColor(.red)
                                    } else {
                                        ProgressView()
                                    }
                                }
                                Text("It looks Great!")
                                    .fontWeight(.medium)
                                    .padding()
                                    .onTapGesture {
                                        isImageTapped.toggle() // dismiss the modal view
                                    }
                            }
                        }
                    }
                }

                // Play/Stop button for speech synthesis
                Button(action: {
                    if isPlaying {
                        synthesizer.stopSpeaking(at: .immediate)
                    } else {
                        startSpeechSynthesis(instructions: viewModel.mealDetail?.strInstructions ?? "No instructions available")
                    }
                    isPlaying.toggle()
                }) {
                    Text(isPlaying ? "Stop" : "Read") // Change the button label dynamically
                        .font(.title3)
                        .frame(width: 100, height: 40)
                        .background(isPlaying ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)

                // Displaying meal details and ingredients
                if isLoading {
                    ProgressView()
                } else {
                    if let mealDetail = viewModel.mealDetail {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Instructions:")
                                .font(.title2)
                                .padding(.top, 10)
                                .foregroundColor(.primary)
                                .bold()

                            // Splitting the instructions into steps after a full stop
                            let instructionsSteps = mealDetail.strInstructions
                                .components(separatedBy: ". ")
                                .map { $0.trimmingCharacters(in: .whitespaces) }
                                .filter { !$0.isEmpty } // Remove any empty strings

                            ForEach(instructionsSteps.indices, id: \.self) { index in
                                HStack {
                                    Text("Step \(index + 1): \(instructionsSteps[index])")
                                        .padding(10)
                                        .background(Color(UIColor.systemGray6)) // Light gray background
                                        .cornerRadius(8)
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                        .frame(maxWidth: .infinity) // Take full width
                                }
                                .padding(.horizontal, 10)
                            }

                            Divider() // Add a divider line

                            Text("Ingredients:")
                                .font(.title2)
                                .padding(.top, 10)
                                .foregroundColor(.primary)
                                .bold()

                            ForEach(1...20, id: \.self) { index in
                                if let ingredient = mealDetail.ingredient(at: index), !ingredient.isEmpty {
                                    Text("• \(ingredient)")
                                        .frame(maxWidth: .infinity, alignment: .leading) // Make text take full width
                                        .multilineTextAlignment(.leading) // Align text to the left
                                        .padding(.horizontal, 10)
                                        .padding(.bottom, 2)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    } else {
                        Text("Meal detail not found")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal, 20)
            .multilineTextAlignment(.center)
        }
        .onAppear {
            Task {
                await viewModel.fetchMealDetails(for: meal.id) // Use async fetching
            }
        }
        .onReceive(viewModel.$mealDetail) { mealDetail in
            isLoading = mealDetail == nil
        }
        .onDisappear {
            // Stops the speech when the view disappears
            if isPlaying {
                synthesizer.stopSpeaking(at: .immediate)
                isPlaying = false
            }
        }
    }

    func startSpeechSynthesis(instructions: String) {
        let speechUtterance = AVSpeechUtterance(string: instructions)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechUtterance.rate = 0.4
        synthesizer.speak(speechUtterance)
    }
}

