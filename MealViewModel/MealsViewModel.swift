import Foundation

// A view model for managing meal-related data.
class MealsViewModel: ObservableObject {
    // An array of meals retrieved from the API.
    @Published var meals: [Meal] = []

    // The selected meal for detailed view.
    @Published var selectedMeal: MealDetail?

    // The detailed information for a specific meal.
    @Published var mealDetail: MealDetail?

    // Fetches dessert meals from the API and updates the `meals` property.
    //
    // This function uses async/await for asynchronous operations.
    func fetchDessertMeals() async {
        let dessertURL = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert")!

        do {
            let (data, _) = try await URLSession.shared.data(from: dessertURL)
            let decodedData = try JSONDecoder().decode(MealsResponse.self, from: data)
            // Filter out any meals with empty names or nil thumbnails
            self.meals = decodedData.meals.filter { !$0.strMeal.isEmpty && $0.strMealThumb != nil }
        } catch {
            print("Error fetching dessert meals: \(error)")
        }
    }

    // Fetches detailed information for a specific meal identified by `mealID`.
    //
    // - Parameters:
    //   - mealID: The unique identifier of the meal.
    func fetchMealDetails(for mealID: String) async {
        let mealURLString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
        guard let mealURL = URL(string: mealURLString) else {
            print("Invalid URL: \(mealURLString)")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: mealURL)
            let mealDetailResponse = try JSONDecoder().decode(MealDetailResponse.self, from: data)

            if let mealDetail = mealDetailResponse.meals.first {
                self.mealDetail = mealDetail
            } else {
                print("Meal detail not found in the response")
            }
        } catch {
            print("Error fetching meal details: \(error)")
        }
    }
}
