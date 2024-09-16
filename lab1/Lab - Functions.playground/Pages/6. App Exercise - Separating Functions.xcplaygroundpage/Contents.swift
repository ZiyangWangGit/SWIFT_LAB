/*:
## App Exercise - Separating Functions

 >These exercises reinforce Swift concepts in the context of a fitness tracking app.

 One principle that can help in debugging and maintaining code is abstraction. For example, in your fitness tracking app some of your existing functions have been written to both perform a calculation and print a message. But it's very possible that you'll decide to change either the calculation or the message in the future. It will be easier to go back and change this if you separate the calculation from the message.

 As an example, write a function that only does a portion of what your previous `pacing` function did. This function will be called `calculatePace`. It should take three `Double` arguments called `currentDistance`, `totalDistance`, and `currentTime`, and should return a `Double` that will represent the time at which the user will finish the run based on the user's current distance and time. call the function and print the return value.
 */
func calculatePace(currentDistance: Double,totalDistance: Double, currentTime: Double) -> Double{
    let currentPace = currentTime / currentDistance
    let estimatedTotalTime = currentPace * totalDistance
    return estimatedTotalTime
}
print("esitmatedTotal time is:" ,calculatePace(currentDistance:20,totalDistance:50,currentTime:20))

//:  Now write a function called `pacing` that takes four `Double` arguments called `currentDistance`, `totalDistance`, `currentTime`, and `goalTime`. The function should also return a `String`, which will be the message to show the user. The function should call `calculatePace`, passing in the appropriate values, and capture the return value. The function should then compare the returned value to `goalTime` and if the user is on pace return "Keep it up!", and return "You've got to push it just a bit harder!" otherwise. Call the function and print the return value.
func pacing(currentDistance: Double,totalDistance: Double, currentTime: Double, goalTime: Double)->String{
    let currentPace = currentTime / currentDistance
    let estimatedTotalTime = currentPace * totalDistance
    if (estimatedTotalTime < goalTime) {
        return "Keep it up!"
    } else {
        return "You've got to push it just a bit harder!"
    }
}

print("Your result is:",pacing(currentDistance: 12, totalDistance: 24, currentTime: 31, goalTime: 40))


/*:
 
[Previous](@previous)  |  page 6 of 6
 */
