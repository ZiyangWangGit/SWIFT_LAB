/*:
## App Exercise - Type Properties and Methods

 >These exercises reinforce Swift concepts in the context of a fitness tracking app.

 In another exercise, you added a computed property representing the average mile time from a run. However, you may want to have a calculator of sorts that users can use before their run to find out what mile time they need to average in order to run a given distance in a given time. In this case it might be helpful to have a type method on `RunningWorkout` that can be accessed without having an instance of `RunningWorkout`.

 Add to `RunningWorkout` a type method `mileTimeFor(distance:time:)` where `distance` and `time` are both of type `Double`. This method should have a return value of type `Double`. The body of the method should calculate the average mile time needed to cover the passed in distance in the passed in time. Assume that distance is in meters and that one mile is 1600 meters.

 Call the method from outside of the struct and print the result to ensure that it works properly.
 */
struct RunningWorkout {
    var distance: Double
    var time: Double
    var elevation: Double
    
    static let metersInFeet = 3.28084
    static let mileInMeters = 1600.0
    
    static func mileTimeFor(distance: Double, time: Double) -> Double {
        let miles = distance / mileInMeters
        let timeForAverageMile = time / miles
        return timeForAverageMile
    }
}
RunningWorkout.mileTimeFor(distance: 5000, time: 800)


//:  It may be helpful to have a few type properties on `RunningWorkout` representing unit conversions (i.e. meters to mile, feet to meters, etc.). Go back and add a type property for `meterInFeet` and assign it 3.28084. Then add a type property for `mileInMeters` and assign it 1600.0. Print both of these values below.
print("Meters in foot: \(RunningWorkout.metersInFeet)")
print("Meters in mile: \(RunningWorkout.mileInMeters)")

/*:


 
[Previous](@previous)  |  page 10 of 10
 */
