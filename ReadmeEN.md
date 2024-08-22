

# Moonshot: Introduction

In this project we’re going to build an app that lets users learn about the missions and astronauts that formed NASA’s Apollo space program. You’ll get more experience with `Codable`, but more importantly you’ll also work with scroll views, navigation, and much more interesting layouts.

Yes, you’ll get some practice time with `List`, `Text`, and more, but you’ll also start to solve important SwiftUI problems – how can you make an image fit its space correctly? How can we clean up code using computed properties? How can we compose smaller views into larger ones to help keep our project organized?

As always there’s lots to do, so let’s get started: create a new iOS app using the App template, naming it “Moonshot”. We’ll be using that for the project, but first lets take a closer look at the new techniques you’ll need to become familiar with…

# Resizing images to fit the available space

When we create an `Image` view in SwiftUI, it will automatically size itself according to the dimensions of its contents. So, if the picture is 1000x500, the `Image` view will also be 1000x500. This is sometimes what you want, but mostly you’ll want to show the image at a lower size, and I want to show you how that can be done, but also how we can make an image fit some amount of the user’s screen width using a relative frame.

First, add some sort of image to your project. It doesn’t matter what it is, as long as it’s wider than the screen. I called mine “Example”, but obviously you should substitute your image name in the code below.

Now let’s draw that image on the screen:

```swift
struct ContentView: View {
    var body: some View {
        Image("Example")
    }
}
```

**Tip:** When you're using fixed image names such as this one, Xcode generates constant names for them all that you can use in place of strings. In this case, that means writing `Image(.example)`, which is much safer than using a string!

Even in the preview you can see that’s way too big for the available space. Images have the same `frame()` modifier as other views, so you might try to scale it down like this:

```swift
Image(.example)
    .frame(width: 300, height: 300)
```

However, that won’t work – your image will still appear to be its full size. If you want to know *why*, change Xcode's preview mode from Live to Selectable – look for the three buttons at the bottom left of your Xcode preview, and click the one with a mouse cursor inside.

**Important:** This stops your preview from running live, so you won't be able to interact with your view until you select the Live option instead.

With Selectable mode enabled, take a close look at the preview window: you’ll see your image is full size, but there’s now a box that’s 300x300, sat in the middle. The *image view’s* frame has been set correctly, but the *content* of the image is still shown as its original size.

Try changing the image to this:

```swift
Image(.example)
    .frame(width: 300, height: 300)
    .clipped()
```

Now you’ll see things more clearly: our image view is indeed 300x300, but that’s not really what we wanted.

If you want the image *contents* to be resized too, we need to use the `resizable()` modifier like this:

```swift
Image(.example)
    .resizable()
    .frame(width: 300, height: 300)
```

That’s better, but only just. Yes, the image is now being resized correctly, but it’s probably looking squashed. My image was not square, so it looks distorted now that it’s been resized into a square shape.

To fix this we need to ask the image to resize itself proportionally, which can be done using the `scaledToFit()` and `scaledToFill()`modifiers. The first of these means the entire image will fit inside the container even if that means leaving some parts of the view empty, and the second means the view will have no empty parts even if that means some of our image lies outside the container.

Try them both to see the difference for yourself. Here is `.fit` mode applied:

```swift
Image(.example)
    .resizable()
    .scaledToFit()
    .frame(width: 300, height: 300)
```

And here is `scaledToFill()`:

```swift
Image(.example)
    .resizable()
    .scaledToFill()
    .frame(width: 300, height: 300)
```

All this works great if we want fixed-sized images, but very often you want images that automatically scale up to fill more of the screen in one or both dimensions. That is, rather than hard-coding a width of 300, what you *really* want to say is “make this image fill 80% of the width of the screen.”

Rather than forcing a specific frame, SwiftUI has a dedicated `containerRelativeFrame()` modifier that lets us get exactly the result we want. The "container" part might be the whole screen, but it might also just be the part of the screen that this view's immediate parent occupies – maybe our image is shown inside a `VStack` along with other views.

We’ll go into much more detail on container relative frames in project 18, but for now we’re going to use it for one job: to make sure our image fills 80% of the available width of our screen.

For example, we could make an image that’s 80% the width of the screen:

```swift
Image(.example)
    .resizable()
    .scaledToFit()
    .containerRelativeFrame(.horizontal) { size, axis in
        size * 0.8
    }
```

Let's break that code down:

1. We're saying we want to give this image a frame relative to the horizontal size of its parent. We aren't specifying a vertical size; more on that in a moment.
2. SwiftUI then runs a closure where we're given a size and an axis. For us the axis will be `.horizontal` because that's the one we're using, but this matters more when you create relative horizontal *and* vertical sizes. The `size` value will be the size of our container, which for this image is the full screen.
3. We need to return the size we want for this axis, so we're sending back 80% of the container's width.

Again, we don't need to specify a height here. This is because we’ve given SwiftUI enough information that it can automatically figure out the height: it knows the original width, it knows our target width, and it knows our content mode, so it understands how the target height of the image will be proportional to the target width.



You’ve seen how `List` and `Form` let us create scrolling tables of data, but for times when we want to scroll *arbitrary* data – i.e., just some views we’ve created by hand – we need to turn to SwiftUI’s `ScrollView`.

Scroll views can scroll horizontally, vertically, or in both directions, and you can also control whether the system should show scroll indicators next to them – those are the little scroll bars that appear to give users a sense of how big the content is. When we place views inside scroll views, they automatically figure out the size of that content so users can scroll from one edge to the other.

As an example, we could create a scrolling list of 100 text views like this:

```swift
ScrollView {
    VStack(spacing: 10) {
        ForEach(0..<100) {
            Text("Item \($0)")
                .font(.title)
        }
    }
}
```

If you run that back in the simulator you’ll see that you can drag the scroll view around freely, and if you scroll to the bottom you’ll also see that `ScrollView` treats the safe area just like `List` and `Form` – their content goes *under* the home indicator, but they add some extra padding so the final views are fully visible.

You might also notice that it’s a bit annoying having to tap directly in the center – it’s more common to have the whole area scrollable. To get *that* behavior, we should make the `VStack` take up more space while leaving the default centre alignment intact, like this:

```swift
ScrollView {
    VStack(spacing: 10) {
        ForEach(0..<100) {
            Text("Item \($0)")
                .font(.title)
        }
    }
    .frame(maxWidth: .infinity)
}
```

Now you can tap and drag anywhere on the screen, which is much more user-friendly.

This all seems really straightforward, however there’s an important catch that you need to be aware of: when we add views to a scroll view they get created immediately. To demonstrate this, we can create a simple wrapper around a regular text view, like this:

```swift
struct CustomText: View {
    let text: String

    var body: some View {
        Text(text)
    }

    init(_ text: String) {
        print("Creating a new CustomText")
        self.text = text
    }
}
```

Now we can use that inside our `ForEach`:

```swift
ForEach(0..<100) {
    CustomText("Item \($0)")
        .font(.title)
}
```

The result will look identical, but now when you run the app you’ll see “Creating a new CustomText” printed a hundred times in Xcode’s log – SwiftUI won’t wait until you scroll down to see them, it will just create them immediately.

If you want to avoid this happening, there’s an alternative for both `VStack` and `HStack` called `LazyVStack` and `LazyHStack` respectively. These can be used in exactly the same way as regular stacks but will load their content on-demand – they won’t create views until they are actually shown, and so minimize the amount of system resources being used.

So, in this situation we could swap our `VStack` for a `LazyVStack` like this:

```swift
LazyVStack(spacing: 10) {
    ForEach(0..<100) {
        CustomText("Item \($0)")
            .font(.title)
    }
}
.frame(maxWidth: .infinity)
```

Literally all it takes is to add “Lazy” before “VStack” to have our code run more efficiently – it will now only create the `CustomText` structs when they are actually needed.

Although the *code* to use regular and lazy stacks is the same, there is one important layout difference: lazy stacks always take up as much as room as is available in our layouts, whereas regular stacks take up only as much space as is needed. This is intentional, because it stops lazy stacks having to adjust their size if a new view is loaded that wants more space.

One last thing: you can make horizontal scrollviews by passing `.horizontal` as a parameter when you make your `ScrollView`. Once that’s done, make sure you create a *horizontal* stack or lazy stack, so your content is laid out as you expect:

```swift
ScrollView(.horizontal) {
    LazyHStack(spacing: 10) {
        ForEach(0..<100) {
            CustomText("Item \($0)")
                .font(.title)
        }
    }
}
```

# Pushing new views onto the stack using NavigationLink



SwiftUI’s `NavigationStack` shows a navigation bar at the top of our views, but also does something else: it lets us push views onto a view stack. In fact, this is really the most fundamental form of iOS navigation – you can see it in Settings when you tap Wi-Fi or General, or in Messages whenever you tap someone’s name.

This view stack system is very different from the sheets we’ve used previously. Yes, both show some sort of new view, but there’s a difference in the *way* they are presented that affects the way users think about them.

Let’s start by looking at some code so you can see for yourself – we could show a simple text view inside a navigation stack like this:

```swift
struct ContentView: View {
    var body: some View {
        NavigationStack {
            Text("Tap Me")
                .navigationTitle("SwiftUI")
        }
    }
}
```

That text view is just static text; it’s not a button with any sort of action attached to it, despite what its title says. We’re going to make it so that when the user taps on it we present them with a new view, and that’s done using `NavigationLink`: give this a destination and something that can be tapped, and it will take care of the rest.

One of the many things I love about SwiftUI is that we can use `NavigationLink` with any kind of destination view. Yes, we can design a custom view to push to, but we can also push straight to some text.

To try this out, change your view to this:

```swift
NavigationStack {
    NavigationLink("Tap Me") {
        Text("Detail View")
    }
    .navigationTitle("SwiftUI")
}
```

Now run the code and see what you think. You will see that “Tap Me” now looks like a button, and tapping it makes a new view slide in from the right saying “Detail View”. Even better, you’ll see that the “SwiftUI” title animates down to become a back button, and you can tap that or swipe from the left edge to go back.

If you want something other than a simple text view as your label, you can use two trailing closures with your `NavigationLink`. For example, we could make a label out of several text views and an image:

```swift
NavigationStack {
    NavigationLink {
        Text("Detail View")
    } label: {
        VStack {
            Text("This is the label")
            Text("So is this")
            Image(systemName: "face.smiling")
        }
        .font(.largeTitle)
    }
}
```

So, both `sheet()` and `NavigationLink` allow us to show a new view from the current one, but the *way* they do it is different and you should choose them carefully: 

- `NavigationLink` is for showing details about the user’s selection, like you’re digging deeper into a topic.
- `sheet()` is for showing unrelated content, such as settings or a compose window.

The most common place you see `NavigationLink` is with a list, and there SwiftUI does something quite marvelous.

Try modifying your code to this:

```swift
NavigationStack {
    List(0..<100) { row in
        NavigationLink("Row \(row)") {
            Text("Detail \(row)")
        }
    }
    .navigationTitle("SwiftUI")
}
```

When you run the app now you’ll see 100 list rows that can be tapped to show a detail view, but you’ll also see gray disclosure indicators on the right edge. This is the standard iOS way of telling users another screen is going to slide in from the right when the row is tapped, and SwiftUI is smart enough to add it automatically here. If those rows weren’t navigation links – if you comment out the `NavigationLink` line and its closing brace – you’ll see the indicators disappear.

# Working with hierarchical Codable data

The `Codable` protocol makes it trivial to decode flat data: if you’re decoding a single instance of a type, or an array or dictionary of those instances, then things Just Work. However, in this project we’re going to be decoding slightly more complex JSON: there will be an array inside another array, using different data types.

If you want to decode this kind of hierarchical data, the key is to create separate types for each level you have. As long as the data matches the hierarchy you’ve asked for, `Codable` is capable of decoding everything with no further work from us.

To demonstrate this, put this button in to your content view:

```swift
Button("Decode JSON") {
    let input = """
    {
        "name": "Taylor Swift",
        "address": {
            "street": "555, Taylor Swift Avenue",
            "city": "Nashville"
        }
    }
    """

    // more code to come
}
```

That creates a string of JSON in code. In case you aren’t too familiar with JSON, it’s probably best to look at the Swift structs that match it – you can put these directly into the button action or outside of the `ContentView` struct, it doesn’t matter:

```swift
struct User: Codable {
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let city: String
}
```

Hopefully you can now see what the JSON contains: a user has a name string and an address, and addresses are a street string and a city string. 

Now for the best part: we can convert our JSON string to the `Data` type (which is what `Codable` works with), then decode that into a `User`instance:

```swift
let data = Data(input.utf8)
let decoder = JSONDecoder()
if let user = try? decoder.decode(User.self, from: data) {
    print(user.address.street)
}
```

If you run that program and tap the button you should see the address printed out – although just for the avoidance of doubt I should say that it’s not her actual address!

There’s no limit to the number of levels `Codable` will go through – all that matters is that the structs you define match your JSON string.

# How to lay out views in a scrolling grid

SwiftUI’s `List` view is a great way to show scrolling rows of data, but sometimes you also want *columns* of data – a grid of information, that is able to adapt to show more data on larger screens.

In SwiftUI this is accomplished with two views: `LazyHGrid` for showing horizontal data, and `LazyVGrid` for showing vertical data. Just like with lazy stacks, the “lazy” part of the name is there because SwiftUI will automatically delay loading the views it contains until the moment they are needed, meaning that we can display more data without chewing through a lot of system resources.

Creating a grid is done in two steps. First, we need to define the rows or columns we want – we only define one of the two, depending on which kind of grid we want.

For example, if we have a vertically scrolling grid then we might say we want our data laid out in three columns exactly 80 points wide by adding this property to our view:

```swift
let layout = [
    GridItem(.fixed(80)),
    GridItem(.fixed(80)),
    GridItem(.fixed(80))
]
```

Once you have your layout defined, you should place your grid inside a `ScrollView`, along with as many items as you want. Each item you create inside the grid is automatically assigned a column in the same way that rows inside a list automatically get placed inside their parent.

For example, we could render 1000 items inside our three-column grid like this:

```swift
ScrollView {
    LazyVGrid(columns: layout) {
        ForEach(0..<1000) {
            Text("Item \($0)")
        }
    }
}
```

That works for some situations, but the best part of grids is their ability to work across a variety of screen sizes. This can be done with a different column layout using *adaptive* sizes, like this:

```swift
let layout = [
    GridItem(.adaptive(minimum: 80)),
]
```

That tells SwiftUI we’re happy to fit in as many columns as possible, as long as they are at least 80 points in width. You can also specify a maximum range for even more control:

```swift
let layout = [
    GridItem(.adaptive(minimum: 80, maximum: 120)),
]
```

I tend to rely on these adaptive layouts the most, because they allow grids that make maximum use of available screen space.

Before we’re done, I want to briefly show you how to make *horizontal* grids. The process is almost identical, you just need to make your `ScrollView` work horizontally, then create a `LazyHGrid` using rows rather than columns:

```swift
ScrollView(.horizontal) {
    LazyHGrid(rows: layout) {
        ForEach(0..<1000) {
            Text("Item \($0)")
        }
    }
}
```

That brings us to the end of the overview for this project, so please go ahead and reset ContentView.swift to its original state.

# Loading a specific kind of Codable data

In this app we’re going to load two different kinds of JSON into Swift structs: one for astronauts, and one for missions. Making this happen in a way that is easy to maintain and doesn’t clutter our code takes some thinking, but we’ll work towards it step by step.

First, drag in the two JSON files for this project. These are available in the GitHub repository for this book, under “project8-files” – look for astronauts.json and missions.json, then drag them into your project navigator. While we’re adding assets, you should also copy all the images into your asset catalog – these are in the “Images” subfolder. The images of astronauts and mission badges were all created by NASA, so under Title 17, Chapter 1, Section 105 of the US Code they are available for us to use under a public domain license.

If you look in astronauts.json, you’ll see each astronaut is defined by three fields: an ID (“grissom”, “white”, “chaffee”, etc), their name (“Virgil I. "Gus" Grissom”, etc), and a short description that has been copied from Wikipedia. If you intend to use the text in your own shipping projects, it’s important that you give credit to Wikipedia and its authors and make it clear that the work is licensed under CC-BY-SA available from here: https://creativecommons.org/licenses/by-sa/3.0. 

Let’s convert that astronaut data into a Swift struct now – press Cmd+N to make a new file, choose Swift file, then name it Astronaut.swift. Give it this code:

```swift
struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}
```

As you can see, I’ve made that conform to `Codable` so we can create instances of this struct straight from JSON, but also `Identifiable`so we can use arrays of astronauts inside `ForEach` and more – that `id` field will do just fine.

Next we want to convert astronauts.json into a dictionary of `Astronaut` instances, which means we need to use `Bundle` to find the path to the file, load that into an instance of `Data`, and pass it through a `JSONDecoder`. Previously we put this into a method on `ContentView`, but here I’d like to show you a better way: we’re going to write an extension on `Bundle` to do it all in one centralized place.

Create another new Swift file, this time called Bundle-Decodable.swift. This will mostly use code you’ve seen before, but there’s one small difference: previously we used `String(contentsOf:)` to load files into a string, but because `Codable` uses `Data` we are instead going to use `Data(contentsOf:)`. It works in just the same way as `String(contentsOf:)`: give it a file URL to load, and it either returns its contents or throws an error.

Add this to Bundle-Decodable.swift now:

```swift
extension Bundle {
    func decode(_ file: String) -> [String: Astronaut] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode([String: Astronaut].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}
```

We'll come back to that in a moment, but as you can see it makes liberal use of `fatalError()`: if the file can’t be found, loaded, or decoded the app will crash. As before, though, this will never actually happen unless you’ve made a mistake, for example if you forgot to copy the JSON file into your project.

Now, you might wonder why we used an extension here rather than a method, but the reason is about to become clear as we load that JSON into our content view. Add this property to the `ContentView` struct now:

```swift
let astronauts = Bundle.main.decode("astronauts.json")
```

Yes, that’s all it takes. Sure, all we’ve done is just moved code out of `ContentView` and into an extension, but there’s nothing wrong with that – anything we can do to help our views stay small and focused is a good thing.

If you want to double check that your JSON is loaded correctly, modify the default `body` property to this:

```swift
Text(String(astronauts.count))
```

That should display 32 rather than “Hello World”.

Before we're done, I want to go back to our little extension and look at it a little more closely. The code we have is perfectly fine for this app, but if you want to use it in the future I'd recommend adding some extra code to help you diagnose problems.

Replace the second part of the method with this:

```swift
let decoder = JSONDecoder()

do {
    return try decoder.decode([String: Astronaut].self, from: data)
} catch DecodingError.keyNotFound(let key, let context) {
    fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' – \(context.debugDescription)")
} catch DecodingError.typeMismatch(_, let context) {
    fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
} catch DecodingError.valueNotFound(let type, let context) {
    fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
} catch DecodingError.dataCorrupted(_) {
    fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON.")
} catch {
    fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
}
```

It's not a big change, but it means the method will now tell you what went wrong with decoding – it's great for times when your Swift code and JSON file don't quite match up!



# Using generics to load any kind of Codable data

We added a `Bundle` extension for loading one specific type of JSON data from our app bundle, but now we have a second type: missions.json. This contains slightly more complex JSON:

- Every mission has an ID number, which means we can use `Identifiable` easily.
- Every mission has a description, which is a free text string taken from Wikipedia.
- Every mission has an array of crew, where each crew member has a name and role.
- All but one missions has a launch date. Sadly, Apollo 1 never launched because a launch rehearsal cabin fire destroyed the command module and killed the crew.

Let’s start converting that to code. Crew roles need to be represented as their own struct, storing the name string and role string. So, create a new Swift file called Mission.swift and give it this code:

```swift
struct CrewRole: Codable {
    let name: String
    let role: String
}
```

As for the missions, this will be an ID integer, an array of `CrewRole`, and a description string. But what about the launch date – we might have one, but we also might not have one. What should *that* be?

Well, think about it: how does Swift represent this “maybe, maybe not” elsewhere? How would we store “might be a string, might be nothing at all”? I hope the answer is clear: we use optionals. In fact, if we mark a property as optional `Codable` will automatically skip over it if the value is missing from our input JSON.

So, add this second struct to Mission.swift now:

```swift
struct Mission: Codable, Identifiable {
    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
}
```

Before we look at how to load JSON into that, I want to demonstrate one more thing: our `CrewRole` struct was made specifically to hold data about missions, and as a result we can actually put the `CrewRole` struct *inside* the `Mission` struct like this:

```swift
struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }

    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
}
```

This is called a *nested struct*, and is simply one struct placed inside of another. This won’t affect our code in this project, but elsewhere it’s useful to help keep your code organized: rather than saying `CrewRole` you’d write `Mission.CrewRole`. If you can imagine a project with several hundred custom types, adding this extra context can really help!

Now let’s think about how we can load missions.json into an array of `Mission` structs. We already added a `Bundle` extension that loads some JSON file into a dictionary of `Astronaut` structs, so we could very easily copy and paste that, then tweak it so it loads missions rather than astronauts. However, there’s a better solution: we can leverage Swift’s generics system.

Generics allow us to write code that is capable of working with a variety of different types. In this project, we wrote the `Bundle` extension to work with dictionary of astronauts, but really we want to be able to handle dictionaries of astronauts, arrays of missions, or potentially lots of other things.

To make a method generic, we give it a placeholder for certain types. This is written in angle brackets (`<` and `>`) after the method name but before its parameters, like this:

```swift
func decode<T>(_ file: String) -> [String: Astronaut] {
```

We can use anything for that placeholder – we could have written “Type”, “TypeOfThing”, or even “Fish”; it doesn’t matter. “T” is a bit of a convention in coding, as a short-hand placeholder for “type”.

Inside the method, we can now use “T” everywhere we would use `[String: Astronaut]` – it is literally a placeholder for the type we want to work with. So, rather than returning `[String: Astronaut]` we would use this:

```swift
func decode<T>(_ file: String) -> T {
```

**Be very careful:** There is a big difference between `T` and `[T]`. Remember, `T` is a placeholder for whatever type we ask for, so if we say “decode our dictionary of astronauts,” then `T` becomes `[String: Astronaut]`. If we attempt to return `[T]` from `decode()` then we would actually be returning `[[String: Astronaut]]` – an array of dictionaries of astronauts!

Towards the middle of the `decode()` method there’s another place where `[String: Astronaut]` is used:

```swift
return try decoder.decode([String: Astronaut].self, from: data)
```

Again, please change that to `T`, like this:

```swift
return try decoder.decode(T.self, from: data)
```

So, what we’ve said is that `decode()` will be used with some sort of type, such as `[String: Astronaut]`, and it should attempt to decode the file it has loaded to be that type.

If you try compiling this code, you’ll see an error in Xcode: “Instance method 'decode(_:from:)' requires that 'T' conform to 'Decodable’”. What it means is that `T` could be anything: it could be a dictionary of astronauts, or it could be a dictionary of something else entirely. The problem is that Swift can’t be sure the type we’re working with conforms to the `Codable` protocol, so rather than take a risk it’s refusing to build our code.

Fortunately we can fix this with a *constraint*: we can tell Swift that `T` can be whatever we want, as long as that thing conforms to `Codable`. That way Swift knows it’s safe to use, and will make sure we don’t try to use the method with a type that *doesn’t* conform to `Codable`.

To add the constraint, change the method signature to this:

```swift
func decode<T: Codable>(_ file: String) -> T {
```

If you try compiling again, you’ll see that things *still* aren’t working, but now it’s for a different reason: “Generic parameter 'T' could not be inferred”, over in the `astronauts` property of `ContentView`. This line worked fine before, but there has been an important change now: before `decode()` would always return a dictionary of astronauts, but now it returns anything we want as long as it conforms to `Codable`. 

*We* know it will *still* return a dictionary of astronauts because the actual underlying data hasn’t changed, but Swift *doesn’t* know that. Our problem is that `decode()` can return any type that conforms to `Codable`, but Swift needs more information – it wants to know exactly what type it will be. 

So, to fix this we need to use a type annotation so Swift knows exactly what `astronauts` will be:

```swift
let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
```

Finally – after all that work! – we can now also load mission.json into another property in `ContentView`. Please add this below `astronauts`:

```swift
let missions: [Mission] = Bundle.main.decode("missions.json")
```

And *that* is the power of generics: we can use the same `decode()` method to load any JSON from our bundle into any Swift type that conforms to `Codable` – we don’t need half a dozen variants of the same method.

Before we’re done, there’s one last thing I’d like to explain. Earlier you saw the message “Instance method 'decode(_:from:)' requires that 'T' conform to 'Decodable’”, and you might have wondered what `Decodable` was – after all, we’ve been using `Codable` everywhere. Well, behind the scenes, `Codable` is just an alias for two separate protocols: `Encodable` and `Decodable`. You can use `Codable` if you want, or you can use `Encodable` and `Decodable` if you prefer being specific – it’s down to you.

# Formatting our mission view

Now that we have all our data in place, we can look at the design for our first screen: a grid of all the missions, next to their mission badges. 

The assets we added earlier contain pictures named “apollo1@2x.png” and similar, which means they are accessible in the asset catalog as “apollo1”, “apollo12”, and so on. Our `Mission` struct has an `id` integer providing the number part, so we could use string interpolation such as `"apollo\(mission.id)"` to get our image name and `"Apollo \(mission.id)"` to get the formatted display name of the mission.

Here, though, we’re going to take a different approach: we’re going to add some computed properties to the `Mission` struct to send that same data back. The result will be the same – “apollo1” and “Apollo 1” – but now the code is in one place: our `Mission` struct. This means any other views can use the same data without having to repeat our string interpolation code, which in turn means if we change the way these things are formatted – i.e., we change the image names to “apollo-1” or something – then we can just change the property in `Mission`and have all our code update.

So, please add these two properties to the `Mission` struct now:

```swift
var displayName: String {
    "Apollo \(id)"
}

var image: String {
    "apollo\(id)"
}
```

With those two in place we can now take a first pass at filling in `ContentView`: it will have a `NavigationStack` with a title, a `LazyVGrid`using our `missions` array as input, and each row inside there will be a `NavigationLink` containing the image, name, and launch date of the mission. The only small complexity in there is that our launch date is an optional string, so we need to use nil coalescing to make sure there’s a value for the text view to display.

First, add this property to `ContentView` to define an adaptive column layout:

```swift
let columns = [
    GridItem(.adaptive(minimum: 150))
]
```

And now replace your existing body property with this:

```swift
NavigationStack {
    ScrollView {
        LazyVGrid(columns: columns) {
            ForEach(missions) { mission in
                NavigationLink {
                    Text("Detail view")
                } label: {
                    VStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)

                        VStack {
                            Text(mission.displayName)
                                .font(.headline)
                            Text(mission.launchDate ?? "N/A")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    .navigationTitle("Moonshot")
}
```

I know it looks pretty ugly, but we’ll fix it right up in just a moment. First, let’s focus on what we have so far: a scrolling, vertical grid that uses `resizable()`, `scaledToFit()`, and `frame()` to make the image occupy a 100x100 space while also maintaining its original aspect ratio. 

Run the program now, and apart from the scrappy layout changes you’ll notice the dates aren’t great – although *we* can look at “1968-12-21” and understand it’s the 21st of December 1968, it’s still an unnatural date format for almost everyone. We can do better than this!

Swift’s `JSONDecoder` type has a property called `dateDecodingStrategy`, which determines how it should decode dates. We can provide that with a `DateFormatter` instance that describes how our dates are formatted. In this instance, our dates are written as year-month-day, which in the world of `DateFormat` is written as “y-MM-dd” – that means “a year, then a dash, then a zero-padded month, then a dash, then a zero-padded day”, with “zero-padded” meaning that January is written as “01” rather than “1”.

**Warning:** Date formats are case sensitive! `mm` means “zero-padded minute” and `MM` means “zero-padded month.”

So, open Bundle-Decodable.swift and add this code directly after `let decoder = JSONDecoder()`:

```swift
let formatter = DateFormatter()
formatter.dateFormat = "y-MM-dd"
decoder.dateDecodingStrategy = .formatted(formatter)
```

That tells the decoder to parse dates in the exact format we expect. 

**Tip:** When working with dates it is often a good idea to be specific about your time zone, otherwise the user’s own time zone is used when parsing the date and time. However, we’re also going to be *displaying* the date in the user’s time zone, so there’s no problem here.

If you run the code now… things will look exactly the same. Yes, nothing has changed, but that’s OK: nothing has changed because Swift doesn’t realize that `launchDate` is a date. After all, we declared it like this:

```swift
let launchDate: String?
```

Now that our decoding code understands how our dates are formatted, we can change that property to be an optional `Date`:

```swift
let launchDate: Date?
```

…and now our code won’t even compile!

The problem *now* is this line of code in ContentView.swift:

```swift
Text(mission.launchDate ?? "N/A")
```

That attempts to use an optional `Date` inside a text view, or replace it with “N/A” if the date is empty. This is another place where a computed property works better: we can ask the mission itself to provide a formatted launch date that converts the optional date into a neatly formatted string or sends back “N/A” for missing dates.

This uses the same `formatted()` method we’ve used previously, so this should be somewhat familiar for you. Add this computed property to `Mission` now:

```swift
var formattedLaunchDate: String {
    launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
}
```

And now replace the broken text view in `ContentView` with this:

```swift
Text(mission.formattedLaunchDate)
```

With that change our dates will be rendered in a much more natural way, and, even better, will be rendered in whatever way is region-appropriate for the user – what you see isn’t necessarily what I see.

Now let’s focus on the bigger problem: our layout is pretty dull!

To spruce it up a little, I want to introduce you to two useful features: how to share custom app colors easily, and how to force a dark theme for our app.

First, colors. There are two ways to do this, and both are useful: you can add colors to your asset catalog with specific names, or you can add them as Swift extensions. They both have their advantages – using the asset catalog lets you work visually, but using code makes it easier to monitor changes using something like GitHub.

Of the two I prefer the code approach, because it makes it easier to track changes when you're working in teams, so we're going to place our color names into Swift as extensions. 

If we make these extensions on `Color` we can use them in a handful of places in SwiftUI, but Swift gives us a better option with only a little more code. You see, `Color` conforms to a bigger protocol called `ShapeStyle` that is what lets us use colors, gradients, materials, and more as if they were the same thing.

This `ShapeStyle` protocol is what the `background()` modifier uses, so what we really want to do is extend `Color` but do so in a way that all the SwiftUI modifiers using `ShapeStyle` work too. This can be done with a very precise extension that literally says “we want to add functionality to `ShapeStyle`, but only for times when it’s being used as a color.”

To try this out, make a new Swift file called Color-Theme.swift, change its Foundation import for SwiftUI, then give it this code:

```swift
extension ShapeStyle where Self == Color {
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }

    static var lightBackground: Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
}
```

That adds two new colors called `darkBackground` and `lightBackground`, each with precise values for red, green, and blue. But more importantly they place those inside a very specific extension that allows us to use those colors everywhere SwiftUI expects a `ShapeStyle`.

I want to put those new colors into action immediately. First, find the `VStack` containing the mission name and launch date – it should already have `.frame(maxWidth: .infinity)` on there, but I’d like you to change its modifier order to this:

```swift
.padding(.vertical)
.frame(maxWidth: .infinity)
.background(.lightBackground)
```

Next, I want to make the *outer* `VStack` – the one that is the whole label for our `NavigationLink` – look more like a box in our grid, which means drawing a line around it and clipping the shape just a little. To get that effect, add these modifiers to the end of it:

```swift
.clipShape(.rect(cornerRadius: 10))
.overlay(
    RoundedRectangle(cornerRadius: 10)
        .stroke(.lightBackground)
)
```

Third, we need to add a little padding to get things away from their edges just a touch. That means adding some simple padding to the mission images, directly after their 100x100 frame:

```swift
.padding()
```

Then also adding some horizontal and bottom padding to the grid:

```swift
.padding([.horizontal, .bottom])
```

**Important:** This should be added to the `LazyVGrid`, *not* to the `ScrollView`. If you pad the scroll view you’re also padding its scrollbars, which will look odd.

Now we can replace the white background with the custom background color we created earlier – add this modifier to the `ScrollView`, after its `navigationTitle()` modifier:

```swift
.background(.darkBackground)
```

At this point our custom layout is almost done, but to finish up we’re going to look at the remaining colors we have – the light blue color used for our mission text isn’t great, and the “Moonshot” title is black at the top, which is impossible to read against our dark blue background.

We can fix the first of these by assigning specific colors to those two text fields:

```swift
VStack {
    Text(mission.displayName)
        .font(.headline)
        .foregroundStyle(.white)
    Text(mission.formattedLaunchDate)
        .font(.caption)
        .foregroundStyle(.white.opacity(0.5))
}
```

Using a translucent white for the foreground color allows just a hint of the color behind to come through.

As for the Moonshot title, that belongs to our `NavigationStack`, and will appear either black or white depending on whether the user is in light mode or dark mode. To fix this, we can tell SwiftUI our view prefers to be in dark mode *always* – this will cause the title to be in white no matter what, and will also darken other colors such as navigation bar backgrounds.

So, to finish up the design for this view please add this final modifier to the `ScrollView`, below its background color:

```swift
.preferredColorScheme(.dark)
```

If you run the app now you’ll see we have a beautifully scrolling grid of mission data that will smoothly adapt to a wide range of device sizes, we have bright white navigation text and a dark navigation background no matter what appearance the user has enabled, and tapping any of our missions will bring in a temporary detail view. A great start!

# Showing mission details with ScrollView and containerRelativeFrame()

When the user selects one of the Apollo missions from our main list, we want to show information about the mission: its mission badge, its mission description, and all the astronauts that were on the crew along with their roles. The first two of those aren’t too hard, but the third requires a little more work because we need to match up crew IDs with crew details across our two JSON files.

Let’s start simple and work our way up: make a new SwiftUI view called MissionView.swift. Initially this will just have a `mission` property so that we can show the mission badge and description, but shortly we’ll add more to it.

In terms of layout, this thing needs to have a scrolling `VStack` with a resizable image for the mission badge, then a text view. We’ll use `containerRelativeFrame()` to set the width of the mission image – through some trial and error I found that the mission badge worked best when it wasn’t full width – somewhere between 50% and 70% width looked better, to avoid it becoming weirdly big on the screen.

Put this code into MissionView.swift now:

```swift
struct MissionView: View {
    let mission: Mission

    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                    .padding(.top)

                VStack(alignment: .leading) {
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)

                    Text(mission.description)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
}
```

Placing a `VStack` inside another `VStack` allows us to control alignment for one specific part of our view – our main mission image can be centered, while the mission details can be aligned to the leading edge.

Anyway, with that new view in place the code will no longer build, all because of the previews struct below it – that thing needs a `Mission`object passed in so it has something to render. Fortunately, our `Bundle` extension is available here as well:

```swift
#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")

    return MissionView(mission: missions[0])
        .preferredColorScheme(.dark)
}
```

**Tip:** This view will automatically have a dark color scheme because it’s applied to the `NavigationStack` in `ContentView`, but the `MissionView` preview doesn’t know that so we need to enable it by hand.

If you look in the preview you’ll see that’s a good start, but the next part is trickier: we want to show the list of astronauts who took part in the mission below the description. Let’s tackle that next…

# Merging Codable structs

Below our mission description we want to show the pictures, names, and roles of each crew member, which means matching up data that came from two different JSON files.

If you remember, our JSON data is split across missions.json and astronauts.json. This eliminates duplication in our data, because some astronauts took part in multiple missions, but it also means we need to write some code to join our data together – to resolve “armstrong” to “Neil A. Armstrong”, for example. You see, on one side we have missions that know crew member “armstrong” had the role “Commander”, but has no idea who “armstrong” is, and on the other side we have “Neil A. Armstrong” and a description of him, but no concept that he was the commander on Apollo 11.

So, what we need to do is make our `MissionView` accept the mission that got tapped, along with our full astronauts dictionary, then have it figure out which astronauts actually took part in the launch.

Add this nested struct inside `MissionView` now:

```swift
struct CrewMember {
    let role: String
    let astronaut: Astronaut
}
```

Now for the tricky part: we need to add a property to `MissionView` that stores an array of `CrewMember` objects – these are the fully resolved role / astronaut pairings. At first that’s as simple as adding another property:

```swift
let crew: [CrewMember]
```

But then how do we *set* that property? Well, think about it: if we make this view be handed its mission and all astronauts, we can loop over the mission crew, then for each crew member look in the dictionary to find the one that has a matching ID. When we find one we can convert that and their role into a `CrewMember` object, but if we don’t it means somehow we have a crew role with an invalid or unknown name. 

**That latter case should never happen.** To be clear, if you’ve added some JSON to your project that points to missing data in your app, you’ve made a fundamental mistake – it’s not the kind of thing you should try to write error handling for at runtime, because it should never be allowed to happen in the first place. So, this is a great example of where `fatalError()` is useful: if we can’t find an astronaut using their ID, we should exit immediately and complain loudly.

Let’s put all that into code, using a custom initializer for `MissionView`. Like I said, this will accept the mission it represents along with all the astronauts, and its job is to store the mission away then figure out the array of resolved astronauts.

Here’s the code:

```swift
init(mission: Mission, astronauts: [String: Astronaut]) {
    self.mission = mission

    self.crew = mission.crew.map { member in
        if let astronaut = astronauts[member.name] {
            return CrewMember(role: member.role, astronaut: astronaut)
        } else {
            fatalError("Missing \(member.name)")
        }
    }
}
```

As soon as that code is in, our preview struct will stop working again because it needs more information. So, add a second call to `decode()`there so it loads all the astronauts, then passes those in too:

```swift
#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
```

Now that we have all our astronaut data, we can show this directly below the mission description using a horizontal scroll view. We’re also going to add a little extra styling to the astronaut pictures to make them look better, using a capsule clip shape and overlay.

Add this code just after the `VStack(alignment: .leading)`:

```swift
ScrollView(.horizontal, showsIndicators: false) {
    HStack {
        ForEach(crew, id: \.role) { crewMember in
            NavigationLink {
                Text("Astronaut details")
            } label: {
                HStack {
                    Image(crewMember.astronaut.id)
                        .resizable()
                        .frame(width: 104, height: 72)
                        .clipShape(.capsule)
                        .overlay(
                            Capsule()
                                .strokeBorder(.white, lineWidth: 1)
                        )

                    VStack(alignment: .leading) {
                        Text(crewMember.astronaut.name)
                            .foregroundStyle(.white)
                            .font(.headline)
                        Text(crewMember.role)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
```

Why *after* the `VStack` rather than inside? Because scroll views work best when they take full advantage of the available screen space, which means they should scroll edge to edge. If we put this inside our `VStack` it would have the same padding as the rest of our text, which means it would scroll strangely – the crew would get clipped as it hit the leading edge of our `VStack`, which looks odd.

We’ll make that `NavigationLink` do something more useful shortly, but first we need to modify the `NavigationLink` in `ContentView` – it pushes to `Text("Detail View")` right now, but please replace it with this:

```swift
MissionView(mission: mission, astronauts: astronauts)
```

Now go ahead and run the app in the simulator – it’s starting to become useful!

Before you move on, try spending a few minutes customizing the way the astronauts are shown – I’ve used a capsule clip shape and overlay, but you could try circles or rounded rectangles, you could use different fonts or larger images, or even add some way of marking who the mission commander was.

In my project, I think it would be useful to add a little visual separation in our mission view, so that the mission badge, description, and crew are more clearly split up. 

SwiftUI does provide a dedicated `Divider` view for creating a visual divide in your layout, but it’s not customizable – it’s always just a skinny line. So, to get something a little more useful, I’m going to draw a custom divider to break up our view.

First, place this directly before the “Mission Highlights” text:

```swift
Rectangle()
    .frame(height: 2)
    .foregroundStyle(.lightBackground)
    .padding(.vertical)
```

Now place another one of those – the same code – directly after the `mission.description` text. Much better!

To finish up this view, I’m going to add a title before our crew, but this needs to be done carefully. You see, although this relates to the scroll view, it needs to have the same padding as the rest of our text. So, the best place for this is inside the `VStack`, directly after the previous rectangle:

```swift
Text("Crew")
    .font(.title.bold())
    .padding(.bottom, 5)
```

You don’t need to put it there – if you wanted we could move it outside the `VStack` then apply padding individually to that text view. However, if you do that make sure you apply the same amount of padding to keep everything neatly aligned.

# Finishing up with one last view

To finish this program we’re going to make a third and final view to display astronaut details, which will be reached by tapping one of the astronauts in the mission view. This should mostly just be practice for you, but I hope it also shows you the importance of `NavigationStack` – we’re digging deeper into our app’s information, and the presentation of views sliding in and out really drives that home to the user.

Start by making a new SwiftUI view called `AstronautView`. This will have a single `Astronaut` property so it knows what to show, then it will lay that out using a similar `ScrollView`/`VStack` combination as we had in `MissionView`. Give it this code:

```swift
struct AstronautView: View {
    let astronaut: Astronaut

    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()

                Text(astronaut.description)
                    .padding()
            }
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
```

Once again we need to update the preview so that it creates its view with some data:

```swift
#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return AstronautView(astronaut: astronauts["aldrin"]!)
        .preferredColorScheme(.dark)
}
```

Now we can present that from the `NavigationLink` inside `MissionView`. This points to `Text("Astronaut details")` right now, but we can update it to point to our new `AstronautView` instead:

```swift
AstronautView(astronaut: crewMember.astronaut)
```

That was easy, right? But if you run the app now you’ll see how natural it makes our user interface feel – we start at the broadest level of information, showing all our missions, then tap to select one specific mission, then tap to select one specific astronaut. iOS takes care of animating in the new views, but also providing back buttons and swipes to return to previous views.

# Moonshot: Wrap up

This app is the most complex one we’ve built so far. Yes, there are multiple views, but we also strayed away from lists and forms and into our own scrolling layouts, using `containerRelativeFrame()` to get precise sizes to make the most of our space.

But this was also the most complex *Swift* code we’ve written so far – generics are an incredibly powerful feature, and once you add in constraints you open up a huge range of functionality that lets you save time while also gaining flexibility.

You’re also now starting to see how useful `Codable` is: its ability to decode a hierarchy of data in one pass is invaluable, which is why it’s central to so many Swift apps.

## Review what you learned

Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.

[Click here to review what you learned in this project](https://www.hackingwithswift.com/review/ios-swiftui/moonshot).

## Challenge

One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

1. Add the launch date to `MissionView`, below the mission badge. You might choose to format this differently given that more space is available, but it’s down to you.
2. Extract one or two pieces of view code into their own new SwiftUI views – the horizontal scroll view in `MissionView` is a great candidate, but if you followed my styling then you could also move the `Rectangle` dividers out too.
3. For a tough challenge, add a toolbar item to `ContentView` that toggles between showing missions as a grid and as a list.

**Tip:** For that last one, your best bet is to make all your grid code and all your list code two separate views, and switch between them using an `if` condition in `ContentView`. You can’t attach SwiftUI modifiers to an `if` condition, but you can wrap that condition in a `Group` then attach modifiers to there, like this:

```swift
Group {
    if showingGrid {
        GridLayout(astronauts: astronauts, missions: missions)
    } else {
        ListLayout(astronauts: astronauts, missions: missions)
    }
}
.navigationTitle("My Group")
```

You might hit some speed bumps trying to style your list, because they have a particular look and feel on iOS by default. Try attaching `.listStyle(.plain)` to your list, then something like `.listRowBackground(Color.darkBackground)` to the contents of your list row – that should get you a long way towards your goal.

# Moonshot

This challenge asks you to add some extra text to the mission view, break up at least two SwiftUI views, then, for something harder, allow the user to move between a grid and a list for missions. Let’s tackle it now…

## Challenge 1: Showing launch dates

The first challenge is a gentle warm up: we need to add a launch date for each mission, shown below the mission badge in `MissionView`. This is a little above the level of trivial because not all missions have a launch date, but also because this is your chance to format the date differently depending on what you want.

I’m going to solve this by only showing a date for launches that happened, and I’ll use the `.complete` date format that includes the *day name* something happened as well as the day number, month, and year. As a little extra, I’ll use a `Label` view so we can place a small calendar icon to the side.

Open MissionView.swift, then add this code below the mission badge:

```swift
if let date = mission.launchDate {
    Label(date.formatted(date: .complete, time: .omitted), systemImage: "calendar")
}
```

Nice!

## Challenge 2: Extracting subviews

The second challenge was to extract one or two pieces of view code into their own new SwiftUI views. This project is really ripe for breaking up views, because both `ContentView` and `MissionView` are really big.

The easiest one to start with – at least if you followed my styling! – is the custom divider we made, which was a rectangle with a frame height of 2, with a little color and padding.

To make that into its own view, you’d create a new SwiftUI view called something like CustomDivider.swift, then give it this code:

```swift
struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}
```

And now everywhere the rectangle was used – along with its modifiers – could be replaced with this: `CustomDivider()`.

A slightly more complex candidate for extraction is the crew roster at the bottom of `MissionView`. To pull that out you’d need to cut the entire horizontal `ScrollView` to your clipboard, then paste it into a new view that had a `crew` property.

So, start by making a new SwiftUI view called `CrewRoster`, then give it this property:

```swift
let crew: [MissionView.CrewMember]
```

Remember, the `CrewMember` struct is nested inside `MissionView`, so we need to write `MissionView.CrewMember` so that Swift understands what we mean.

You’ll need to provide some example data in the preview struct, so you can either borrow some of the initializer code from `MissionView`, or if you’re pressed for time you can pass in an empty array like this:

```swift
#Preview {
    CrewRoster(crew: [])
}
```

With that in place, you can just move the whole `ScrollView` code inside the new view’s body, like this:

```swift
ScrollView(.horizontal, showsIndicators: false) {
    HStack {
        ForEach(crew, id: \.role) { crewMember in
            NavigationLink {
                AstronautView(astronaut: crewMember.astronaut)
            } label: {
                HStack {
                    Image(crewMember.astronaut.id)
                        .resizable()
                        .frame(width: 104, height: 72)
                        .clipShape(.capsule)
                        .overlay(
                            Capsule()
                                .strokeBorder(.white, lineWidth: 1)
                        )

                    VStack(alignment: .leading) {
                        Text(crewMember.astronaut.name)
                            .foregroundStyle(.white)
                            .font(.headline)

                        Text(crewMember.role)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
```

And now the hole where it used to be in `MissionView` can be replaced with this:

```swift
CrewRoster(crew: crew)
```

The end result will be identical from a layout perspective, but we’ve made `MissionView` simpler, and we’ve also now got a separate `CrewRoster` view that can be used elsewhere if needed – it’s a big win.

## Challenge 3: List vs grid toggle

The final challenge was the toughest: adding a toolbar item to `ContentView` that toggles between showing missions as a grid and as a list. There are a few reasons why this was tough, but if you break it down into small parts it becomes more achievable.

The first step I would take is to recognize that having a whole other layout inside `ContentView` would make it unmanageably big. So, I would start by taking all the grid code and moving it to a new view called `GridLayout` or similar – this would need the same `astronauts`, `missions`, and `columns` property as `ContentView`, but doesn’t need to *load* the first two because they can just be passed in.

Here’s the starter code for it:

```swift
struct GridLayout: View {
    let astronauts: [String: Astronaut]
    let missions: [Mission]

    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
}
```

You’ll need to provide default property values inside your preview, but this is another place where our `decode()` extension comes in handy:

```swift
#Preview {
    GridLayout(astronauts: Bundle.main.decode("astronauts.json"), missions: Bundle.main.decode("missions.json"))
        .preferredColorScheme(.dark)
}
```

With that done, you can literally move the entire `ScrollView` from `ContentView` into the body of `GridLayout` – the code doesn’t need to change at all.

The second step would be to create a layout using a list, which means another new SwiftUI view that can store astronauts and missions.

Create a new ListLayout.swift view now, then give it this code:

```swift
struct ListLayout: View {
    let astronauts: [String: Astronaut]
    let missions: [Mission]

    var body: some View {
        List(missions) { mission in
            NavigationLink {
                MissionView(mission: mission, astronauts: astronauts)
            } label: {
                HStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding()

                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        Text(mission.formattedLaunchDate)
                    }
                }
            }
        }
    }
}
```

Again, make sure you adjust your preview code so that everything compiles:

```swift
#Preview {
    ListLayout(astronauts: Bundle.main.decode("astronauts.json"), missions: Bundle.main.decode("missions.json"))
        .preferredColorScheme(.dark)
}
```

Now, by default iOS lists will likely stubbornly refuse your attempts to theme them, but that’s okay because there are two modifiers that will help convince iOS to let a little personality shine through.

First, you can adjust the color of any list row by attaching `listRowBackground()` to the row. In our case, that would mean attaching it as a modifier to the `NavigationLink`, like this:

```swift
.listRowBackground(Color.darkBackground)
```

Second, you can make the rest of the list adopt the same background color as our grid by making it use the *plain* style. Add this to the end of the list:

```swift
.listStyle(.plain)
```

We’re getting there!

Now for the tricky part: we need to update `ContentView` to switch between those two layouts. This means:

1. Having some `@State` storage that tracks which view type we’re showing.
2. Showing one or the other of those views depending on our program state.
3. Attaching a toolbar to both views, along with our navigation title, background color, and dark mode scheme.

Here’s how that looks in code:

```swift
struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    @State private var showingGrid = true

    var body: some View {
        NavigationStack {
            Group {
                if showingGrid {
                    GridLayout(astronauts: astronauts, missions: missions)
                } else {
                    ListLayout(astronauts: astronauts, missions: missions)
                }
            }
            .toolbar {
                Button {
                    showingGrid.toggle()
                } label: {
                    if showingGrid {
                        Label("Show as table", systemImage: "list.dash")
                    } else {
                        Label("Show as grid", systemImage: "square.grid.2x2")
                    }
                }

            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}
```

Notice how we needed to use a `Group` view so we had somewhere to attach our toolbar and other modifiers?

Anyway, with that change we’ve solved all three challenges – we’re done!

## Bonus: Remembering their choice

Although we’ve successfully completed the three challenges, there is one small tweak that I would recommend: having our app remember which view type the user preferred, grid or list.

This is not only a user-friendly change – after all, they did tell you how they wanted to view the data, so it’s a smart idea to remember that – but it’s also a really *easy* one to code. A match made in heaven!

To have our app remember whether to show the grid or the list view by default, change the `showingGrid` property from `@State` to `@AppStorage` like this:

```swift
@AppStorage("showingGrid") private var showingGrid = true
```

That’s all it takes – nice!