//
//  ListOfMealsModel.swift
//  Fetch Meals
//
//  Created by Rushikesh Dalvi on 07/30/24.

import Foundation
import SwiftUI


// Represents a meal item.
struct Meal: Identifiable, Codable {
    // The unique identifier for the meal.
    var idMeal: String
    
    // The name of the meal.
    let strMeal: String
    
    // The URL of the thumbnail image for the meal.
    let strMealThumb: String?
    
    // The computed property representing the identifier.
    var id: String {
        return idMeal
    }
}

// Represents detailed information about a meal.
struct MealDetail: Decodable {
    // Instructions for preparing the meal.
    let strInstructions: String
    
    // Ingredients for the meal.
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
}

// Represents the response containing an array of `MealDetail` objects.
struct MealDetailResponse: Decodable {
    // An array of `MealDetail` objects.
    let meals: [MealDetail]
}

// Represents the response containing an array of `Meal` objects.
struct MealsResponse: Decodable {
    // An array of `Meal` objects.
    let meals: [Meal]
}
