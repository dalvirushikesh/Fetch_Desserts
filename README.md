# Fetch Desserts App

## Overview

The Meal Detail Viewer App is a SwiftUI-based iOS application that allows users to explore detailed information about various meals. It fetches meal data from a remote source and presents a rich, interactive interface for viewing meal details, including images, instructions, and ingredients.

## Features

- Display meal name and high-quality image
- Zoomable full-screen image view
- Text-to-speech functionality for reading cooking instructions aloud
- Detailed step-by-step cooking instructions
- Comprehensive list of ingredients for each meal

## Technologies Used

- SwiftUI for UI development
- Combine for reactive programming
- AVFoundation for speech synthesis
- AsyncImage for efficient loading of remote images

## Installation

1. Clone the repository:
   ```bash
   git clone --  copy ssh url frol repo
   cd -- to your project path 

Open the project in Xcode:
bashCopyopen MealDetailViewer.xcodeproj

Build and run the app:

Select your target device or simulator
Click the "Run" button or press Cmd+R



Usage

Launch the app on your iOS device or simulator
Browse through the fetched meal details, including name, image, and cooking information
Tap on a meal image to view it in full-screen mode
Use the "Read" button to hear the cooking instructions read aloud (tap "Stop" to end playback)
Scroll through the detailed instructions and ingredients list

Code Structure

MealDetailView.swift: Main view for displaying meal details
MealsViewModel.swift: ViewModel handling data fetching and storage
Meal.swift: Data model representing a meal
ContentView.swift: App's entry point

Key Components
MealDetailView.swift
This file contains the primary SwiftUI view for presenting meal information.
Notable Elements:

ViewModel: @ObservedObject var viewModel: MealsViewModel
Meal Data: var meal: Meal
State Management:

@State private var isLoading: Bool = true
@State private var isImageTapped: Bool = false
@State private var isPlaying: Bool = false


Speech Synthesis: let synthesizer = AVSpeechSynthesizer()

View Structure:

ScrollView for vertical scrolling
VStack as the main content container
AsyncImage for efficient remote image loading
Interactive elements like a full-screen image view and text-to-speech button

Key Methods:

startSpeechSynthesis(instructions: String): Manages text-to-speech functionality

MealsViewModel.swift
This ViewModel is responsible for fetching and managing meal data from the remote source.
