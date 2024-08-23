## Wprowadzenie do projektu Moonshot

W projekcie Moonshot stworzymy aplikację, która będzie edukować użytkowników na temat historycznego programu kosmicznego NASA Apollo, w tym jego misji i astronautów. Projekt ten ma na celu pomóc Ci w wzmocnieniu umiejętności programistycznych. 

W tym projekcie zyskasz więcej doświadczenia z `Codable`, ale co ważniejsze, będziesz także pracować z widokami przewijania, nawigacją i bardziej interesującymi układami. 

Tak, zdobędziesz więcej praktyki z `List`, `Text` i innymi elementami, ale także zaczniesz rozwiązywać ważne problemy SwiftUI – jak sprawić, by obraz poprawnie wpasował się w swoje miejsce? Jak możemy oczyścić kod za pomocą właściwości obliczanych? Jak możemy komponować mniejsze widoki w większe, aby pomóc w organizacji projektu?

Jak zawsze jest dużo do zrobienia, więc zaczynajmy: utwórz nową aplikację na iOS, używając szablonu App, nazywając ją „Moonshot”. Będziemy jej używać w projekcie, ale najpierw przyjrzyjmy się bliżej nowym technikom, które musisz opanować...

## Zmiana rozmiaru obrazów, aby dopasować je do dostępnej przestrzeni

Kiedy tworzymy widok `Image` w SwiftUI, automatycznie dopasowuje się on do wymiarów swojej zawartości. Jeśli obrazek ma rozmiar 1000x500, to widok `Image` również będzie miał rozmiar 1000x500. Czasami jest to dokładnie to, czego chcemy, ale najczęściej będziemy chcieli pokazać obraz w mniejszym rozmiarze. Pokażę Ci, jak to zrobić, a także jak sprawić, aby obrazek dopasował się do określonej szerokości ekranu użytkownika, używając relatywnej ramki.

Najpierw dodaj jakiś obraz do swojego projektu. Nie ma znaczenia, jaki to obraz, o ile jest szerszy niż ekran. Nazwałem mój obraz "Example", ale oczywiście w kodzie poniżej powinieneś zastąpić nazwę swojego obrazu.

Teraz narysujmy ten obraz na ekranie:

```swift
struct ContentView: View {
    var body: some View {
        Image("Example")
    }
}
```

**Wskazówka:** Kiedy używasz stałych nazw obrazów, takich jak ta, Xcode generuje dla nich stałe nazwy, których możesz używać zamiast ciągów znaków. W tym przypadku oznacza to, że można napisać `Image(.example)`, co jest znacznie bezpieczniejsze niż używanie ciągu znaków!

Już w podglądzie możesz zobaczyć, że obraz jest zbyt duży w stosunku do dostępnej przestrzeni. Obrazy mają ten sam modyfikator `frame()`, co inne widoki, więc możesz spróbować zmniejszyć jego rozmiar w ten sposób:

```swift
Image(.example)
    .frame(width: 300, height: 300)
```

Jednak to nie zadziała – Twój obraz wciąż będzie wyświetlany w pełnym rozmiarze. Jeśli chcesz wiedzieć *dlaczego*, zmień tryb podglądu Xcode z Live na Selectable – poszukaj trzech przycisków w dolnym lewym rogu podglądu Xcode i kliknij ten z kursorem myszy.

**Ważne:** To zatrzymuje działanie podglądu na żywo, więc nie będziesz mógł wchodzić w interakcję ze swoim widokiem, dopóki ponownie nie wybierzesz opcji Live.

W trybie Selectable przyjrzyj się dokładnie oknu podglądu: zobaczysz, że Twój obraz jest w pełnym rozmiarze, ale teraz pojawiło się pudełko o rozmiarach 300x300, które znajduje się na środku. Ramka *widoku obrazu* została ustawiona poprawnie, ale *zawartość* obrazu nadal jest wyświetlana w oryginalnym rozmiarze.

Spróbuj zmienić obraz na taki:

```swift
Image(.example)
    .frame(width: 300, height: 300)
    .clipped()
```

Teraz zobaczysz to wyraźniej: nasz widok obrazu ma rzeczywiście 300x300, ale to nie jest dokładnie to, czego chcieliśmy.

Jeśli chcesz, aby zawartość obrazu również została zmieniona, musimy użyć modyfikatora `resizable()`, jak w poniższym przykładzie:

```swift
Image(.example)
    .resizable()
    .frame(width: 300, height: 300)
```

To już lepiej, ale nadal nie idealnie. Tak, obraz jest teraz zmieniany poprawnie, ale prawdopodobnie wygląda na zniekształcony. Mój obraz nie był kwadratowy, więc teraz wygląda na zdeformowany, gdy został zmieniony na kwadratowy kształt.

Aby to naprawić, musimy poprosić obraz o proporcjonalne skalowanie, co można zrobić za pomocą modyfikatorów `scaledToFit()` i `scaledToFill()`. Pierwszy z nich oznacza, że cały obraz zmieści się w kontenerze, nawet jeśli oznacza to, że niektóre części widoku będą puste, a drugi oznacza, że widok nie będzie miał pustych części, nawet jeśli to oznacza, że część naszego obrazu znajdzie się poza kontenerem.

Wypróbuj oba, aby zobaczyć różnicę. Oto jak wygląda tryb `.fit`:

```swift
Image(.example)
    .resizable()
    .scaledToFit()
    .frame(width: 300, height: 300)
```

A oto jak wygląda `scaledToFill()`:

```swift
Image(.example)
    .resizable()
    .scaledToFill()
    .frame(width: 300, height: 300)
```

Wszystko to działa świetnie, jeśli chcemy ustalonych rozmiarów obrazów, ale bardzo często chcemy, aby obrazy automatycznie skalowały się, aby wypełnić więcej ekranu w jednym lub obu wymiarach. To znaczy, zamiast twardego kodowania szerokości 300, co *naprawdę* chcemy powiedzieć, to „spraw, aby ten obraz wypełniał 80% szerokości ekranu”.

Zamiast wymuszać określoną ramkę, SwiftUI ma dedykowany modyfikator `containerRelativeFrame()`, który pozwala nam uzyskać dokładnie taki wynik, jaki chcemy. Część "container" może być całym ekranem, ale może to być również tylko część ekranu, którą zajmuje bezpośredni rodzic tego widoku – może nasz obraz jest wyświetlany wewnątrz `VStack` wraz z innymi widokami.

Będziemy bardziej szczegółowo omawiać kontenery i ramki w projekcie 18, ale na razie użyjemy go do jednego zadania: upewnimy się, że nasz obraz wypełnia 80% dostępnej szerokości ekranu.

Na przykład, możemy sprawić, że obraz będzie miał 80% szerokości ekranu:

```swift
Image(.example)
    .resizable()
    .scaledToFit()
    .containerRelativeFrame(.horizontal) { size, axis in
        size * 0.8
    }
```

Rozbijmy ten kod na części:

1. Mówimy, że chcemy nadać temu obrazowi ramkę względną do poziomego rozmiaru jego rodzica. Nie określamy pionowego rozmiaru; o tym więcej za chwilę.
2. SwiftUI uruchamia zamknięcie, w którym otrzymujemy rozmiar i oś. Dla nas oś będzie `.horizontal`, ponieważ to ona jest używana, ale ma to większe znaczenie, gdy tworzysz względne poziome *i* pionowe rozmiary. Wartość `size` będzie rozmiarem naszego kontenera, który dla tego obrazu jest całym ekranem.
3. Musimy zwrócić rozmiar, którego chcemy dla tej osi, więc zwracamy 80% szerokości kontenera.

Ponownie, nie musimy tutaj określać wysokości. Dzieje się tak, ponieważ przekazaliśmy SwiftUI wystarczająco dużo informacji, aby mogło automatycznie obliczyć wysokość: zna oryginalną szerokość, zna naszą docelową szerokość i zna nasz tryb zawartości, więc rozumie, jaka będzie proporcjonalna wysokość obrazu względem szerokości.

Przyjrzeliśmy się, jak `List` i `Form` pozwalają nam tworzyć przewijane tabele danych, ale jeśli chcemy przewijać *dowolne* dane – tj. po prostu niektóre widoki, które sami utworzyliśmy – musimy sięgnąć po `ScrollView` SwiftUI.

Widoki przewijania mogą przewijać się w poziomie, pionie lub w obu kierunkach, a także możesz kontrolować, czy system powinien pokazywać wskaźniki przewijania obok nich – to są te małe paski przewijania, które pojawiają się, aby dać użytkownikom poczucie, jak duża jest zawartość. Kiedy umieszczamy widoki wewnątrz widoków przewijania, automatycznie określają one rozmiar tej zawartości, aby użytkownicy mogli przewijać od jednego końca do drugiego.

Na przykład, moglibyśmy stworzyć przewijaną listę 100 widoków tekstowych, tak jak poniżej:

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

Jeśli uruchomisz to na symulatorze, zobaczysz, że możesz swobodnie przesuwać widok przewijania, a jeśli przewiniesz do końca, zobaczysz również, że `ScrollView` traktuje obszar bezpieczny dokładnie tak samo jak `List` i `Form`

 – ich zawartość idzie *pod* wskaźnik początkowy, ale dodają trochę dodatkowego odstępu, aby ostatnie widoki były w pełni widoczne.

Możesz również zauważyć, że przewijanie jest trochę irytujące, gdy trzeba dotknąć dokładnie w środku – częściej cały obszar powinien być przewijalny. Aby uzyskać *takie* zachowanie, powinniśmy sprawić, by `VStack` zajmował więcej miejsca, jednocześnie zachowując domyślne wyrównanie na środku, jak poniżej:

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

Teraz możesz dotknąć i przesuwać w dowolnym miejscu na ekranie, co jest znacznie bardziej przyjazne dla użytkownika.

Wszystko to wydaje się bardzo proste, jednak istnieje ważna pułapka, o której musisz wiedzieć: gdy dodajemy widoki do widoku przewijania, są one tworzone natychmiast. Aby to zademonstrować, możemy utworzyć prostą osłonę wokół zwykłego widoku tekstowego, jak poniżej:

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

Teraz możemy użyć tego wewnątrz naszego `ForEach`:

```swift
ForEach(0..<100) {
    CustomText("Item \($0)")
        .font(.title)
}
```

Wynik będzie wyglądał identycznie, ale teraz, gdy uruchomisz aplikację, zobaczysz w logu Xcode wydrukowane „Creating a new CustomText” sto razy – SwiftUI nie poczeka, aż przewiniesz w dół, aby je zobaczyć, po prostu stworzy je natychmiast.

Jeśli chcesz tego uniknąć, istnieje alternatywa zarówno dla `VStack`, jak i `HStack`, zwana odpowiednio `LazyVStack` i `LazyHStack`. Można je stosować dokładnie w ten sam sposób, co zwykłe stosy, ale będą one ładować swoją zawartość na żądanie – nie będą tworzyć widoków, dopóki nie zostaną faktycznie pokazane, co minimalizuje zużycie zasobów systemowych.

Więc w tej sytuacji moglibyśmy zamienić nasz `VStack` na `LazyVStack`, jak poniżej:

```swift
LazyVStack(spacing: 10) {
    ForEach(0..<100) {
        CustomText("Item \($0)")
            .font(.title)
    }
}
.frame(maxWidth: .infinity)
```

Wystarczy dodać "Lazy" przed "VStack", aby nasz kod działał bardziej efektywnie – teraz tworzy on tylko struktury `CustomText`, gdy są one faktycznie potrzebne.

Chociaż *kod* używany do zwykłych i leniwych stosów jest taki sam, istnieje jedna ważna różnica w układzie: leniwe stosy zawsze zajmują tyle miejsca, ile jest dostępne w naszych układach, podczas gdy zwykłe stosy zajmują tylko tyle miejsca, ile jest potrzebne. Jest to zamierzone, ponieważ zapobiega to konieczności dostosowywania rozmiaru leniwych stosów, jeśli zostanie załadowany nowy widok, który wymaga więcej miejsca.

Jeszcze jedna rzecz: możesz tworzyć poziome widoki przewijania, przekazując `.horizontal` jako parametr podczas tworzenia `ScrollView`. Po wykonaniu tego, upewnij się, że tworzysz *poziomy* stos lub leniwy stos, aby Twoja zawartość była ułożona zgodnie z oczekiwaniami:

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

# Przejście do nowych widoków za pomocą `NavigationLink`

`NavigationStack` w SwiftUI pokazuje pasek nawigacyjny na górze naszych widoków, ale robi coś jeszcze: pozwala nam dodawać nowe widoki do stosu widoków. W rzeczywistości jest to najbardziej podstawowa forma nawigacji w iOS – możesz to zobaczyć w Ustawieniach, gdy dotkniesz Wi-Fi lub Ogólne, lub w Wiadomościach, gdy dotkniesz czyjegoś imienia.

Ten system stosu widoków różni się od arkuszy, które używaliśmy wcześniej. Tak, oba pokazują jakiś nowy widok, ale różnica polega na *sposobie*, w jaki są prezentowane, co wpływa na to, jak użytkownicy je postrzegają.

Zacznijmy od przejrzenia kodu, abyś mógł zobaczyć to na własne oczy – możemy pokazać prosty widok tekstowy w `NavigationStack`, tak jak poniżej:

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

Ten widok tekstowy to tylko statyczny tekst; nie jest to przycisk z żadnym powiązanym działaniem, mimo tego, co sugeruje jego tytuł. Zamierzamy sprawić, że gdy użytkownik go dotknie, zaprezentujemy mu nowy widok, co jest realizowane za pomocą `NavigationLink`: podaj mu docelowy widok i coś, co można dotknąć, a reszta zostanie załatwiona.

Jedną z wielu rzeczy, które uwielbiam w SwiftUI, jest to, że możemy używać `NavigationLink` z dowolnym rodzajem docelowego widoku. Tak, możemy zaprojektować niestandardowy widok do przejścia, ale możemy również przejść bezpośrednio do jakiegoś tekstu.

Aby to wypróbować, zmień swój widok na taki:

```swift
NavigationStack {
    NavigationLink("Tap Me") {
        Text("Detail View")
    }
    .navigationTitle("SwiftUI")
}
```

Uruchom teraz kod i zobacz, co myślisz. Zobaczysz, że „Tap Me” wygląda teraz jak przycisk, a po dotknięciu go pojawia się nowy widok, który przesuwa się z prawej strony i wyświetla „Detail View”. Co więcej, zobaczysz, że tytuł „SwiftUI” animuje się w dół, stając się przyciskiem wstecz, który możesz dotknąć lub przesunąć od lewej krawędzi, aby wrócić.

Jeśli chcesz, aby coś innego niż prosty widok tekstowy było Twoją etykietą, możesz użyć dwóch domykających klamer z `NavigationLink`. Na przykład, możemy stworzyć etykietę składającą się z kilku widoków tekstowych i obrazu:

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

Zarówno `sheet()`, jak i `NavigationLink` pozwalają nam pokazać nowy widok z bieżącego, ale sposób, w jaki to robią, jest inny i należy je starannie wybierać:

- `NavigationLink` służy do pokazywania szczegółów dotyczących wyboru użytkownika, jakbyś zagłębiał się w dany temat.
- `sheet()` służy do pokazywania niezwiązanej zawartości, takiej jak ustawienia lub okno tworzenia.

Najczęstsze miejsce, gdzie zobaczysz `NavigationLink`, to lista, a SwiftUI robi tam coś naprawdę wspaniałego.

Spróbuj zmodyfikować swój kod w następujący sposób:

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

Gdy teraz uruchomisz aplikację, zobaczysz 100 wierszy na liście, które można dotknąć, aby pokazać widok szczegółowy, ale zobaczysz także szare wskaźniki ujawniania na prawej krawędzi. To standardowy sposób iOS na informowanie użytkowników, że po dotknięciu wiersza pojawi się nowy ekran przesuwający się z prawej strony, a SwiftUI jest na tyle inteligentny, że automatycznie dodaje go tutaj. Jeśli te wiersze nie byłyby linkami nawigacyjnymi – jeśli zakomentujesz linię `NavigationLink` i jej zamykającą klamrę – zobaczysz, że wskaźniki znikną.



# Praca z hierarchicznymi danymi Codable

Protokół `Codable` sprawia, że dekodowanie płaskich danych jest banalnie proste: jeśli dekodujesz pojedynczy przykład typu, lub tablicę czy słownik tych przykładów, wszystko działa bez problemu. Jednak w tym projekcie będziemy dekodować nieco bardziej złożone JSON-y: będzie tablica wewnątrz innej tablicy, używająca różnych typów danych.

Jeśli chcesz dekodować tego rodzaju hierarchiczne dane, kluczem jest stworzenie oddzielnych typów dla każdego poziomu, jaki masz. Dopóki dane pasują do hierarchii, którą zdefiniowałeś, `Codable` jest w stanie dekodować wszystko bez dodatkowej pracy z naszej strony.

Aby to zademonstrować, dodaj ten przycisk do swojego widoku zawartości:

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

    // więcej kodu pojawi się za chwilę
}
```

To tworzy ciąg JSON w kodzie. Jeśli nie jesteś zbyt zaznajomiony z JSON-em, najlepiej będzie spojrzeć na struktury Swift, które do niego pasują – możesz je umieścić bezpośrednio w akcji przycisku lub poza strukturą `ContentView`, nie ma to znaczenia:

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

Mam nadzieję, że teraz widzisz, co zawiera JSON: użytkownik ma ciąg `name` i adres, a adresy to ciąg `street` i `city`.

A teraz najlepsza część: możemy przekonwertować nasz ciąg JSON na typ `Data` (który jest tym, z czym pracuje `Codable`), a następnie dekodować go na instancję `User`:

```swift
let data = Data(input.utf8)
let decoder = JSONDecoder()
if let user = try? decoder.decode(User.self, from: data) {
    print(user.address.street)
}
```

Jeśli uruchomisz ten program i klikniesz przycisk, powinieneś zobaczyć wydrukowany adres – chociaż dla uniknięcia wątpliwości powinienem powiedzieć, że to nie jest jej rzeczywisty adres!

Nie ma limitu co do liczby poziomów, przez które `Codable` może przejść – ważne jest tylko, aby struktury, które definiujesz, pasowały do twojego ciągu JSON.

# Jak układać widoki w przewijanej siatce

Widok `List` w SwiftUI to świetny sposób na wyświetlanie przewijanych wierszy danych, ale czasami chcesz również wyświetlać *kolumny* danych – siatkę informacji, która potrafi dostosować się do większych ekranów, aby pokazać więcej danych.

W SwiftUI jest to możliwe dzięki dwóm widokom: `LazyHGrid` do wyświetlania danych poziomych i `LazyVGrid` do wyświetlania danych pionowych. Podobnie jak w przypadku leniwych stosów, „lazy” w nazwie oznacza, że SwiftUI automatycznie opóźnia ładowanie widoków, które zawiera, do momentu, w którym są one potrzebne, co pozwala nam wyświetlać więcej danych bez zużywania dużej ilości zasobów systemowych.

Tworzenie siatki odbywa się w dwóch krokach. Najpierw musimy zdefiniować wiersze lub kolumny, które chcemy – definiujemy tylko jedną z tych dwóch opcji, w zależności od tego, jaki rodzaj siatki chcemy.

Na przykład, jeśli mamy pionowo przewijaną siatkę, możemy powiedzieć, że chcemy, aby nasze dane były ułożone w trzech kolumnach, każda dokładnie o szerokości 80 punktów, dodając tę właściwość do naszego widoku:

```swift
let layout = [
    GridItem(.fixed(80)),
    GridItem(.fixed(80)),
    GridItem(.fixed(80))
]
```

Gdy mamy już zdefiniowany układ, powinniśmy umieścić naszą siatkę w `ScrollView`, wraz z tyloma elementami, ile chcemy. Każdy element, który utworzysz w siatce, jest automatycznie przypisywany do kolumny w taki sam sposób, w jaki wiersze wewnątrz listy są automatycznie umieszczane wewnątrz rodzica.

Na przykład możemy wyświetlić 1000 elementów w naszej trójkolumnowej siatce w następujący sposób:

```swift
ScrollView {
    LazyVGrid(columns: layout) {
        ForEach(0..<1000) {
            Text("Item \($0)")
        }
    }
}
```

To działa w niektórych sytuacjach, ale najlepszą cechą siatek jest ich zdolność do działania na różnych rozmiarach ekranów. Można to zrobić za pomocą innego układu kolumn przy użyciu *adaptacyjnych* rozmiarów, jak w poniższym przykładzie:

```swift
let layout = [
    GridItem(.adaptive(minimum: 80)),
]
```

To mówi SwiftUI, że jesteśmy zadowoleni z dopasowania jak największej liczby kolumn, o ile mają one co najmniej 80 punktów szerokości. Możesz także określić maksymalny zakres, aby uzyskać jeszcze większą kontrolę:

```swift
let layout = [
    GridItem(.adaptive(minimum: 80, maksimum: 120)),
]
```

Zazwyczaj polegam na tych adaptacyjnych układach, ponieważ pozwalają one na maksymalne wykorzystanie dostępnej przestrzeni ekranu.

Zanim skończymy, chcę krótko pokazać, jak tworzyć *poziome* siatki. Proces jest prawie identyczny, wystarczy ustawić, aby `ScrollView` działał poziomo, a następnie stworzyć `LazyHGrid` używając wierszy zamiast kolumn:

```swift
ScrollView(.horizontal) {
    LazyHGrid(rows: layout) {
        ForEach(0..<1000) {
            Text("Item \($0)")
        }
    }
}
```

To kończy przegląd dla tego projektu, więc proszę, zresetuj ContentView.swift do jego oryginalnego stanu.

# Ładowanie specyficznych danych typu Codable

W tej aplikacji załadujemy dwa różne rodzaje danych JSON do struktur Swift: jeden dla astronautów, a drugi dla misji. Zrobienie tego w sposób, który jest łatwy do utrzymania i nie zaśmieca naszego kodu, wymaga przemyślenia, ale przejdziemy przez to krok po kroku.

Najpierw przeciągnij dwa pliki JSON do tego projektu. Znajdziesz je w repozytorium GitHub dla tej książki, w folderze „project8-files” – szukaj plików `astronauts.json` i `missions.json`, a następnie przeciągnij je do nawigatora projektu. Podczas dodawania zasobów powinieneś także skopiować wszystkie obrazy do katalogu zasobów – znajdują się one w podfolderze „Images”. Obrazy astronautów i odznak misji zostały stworzone przez NASA, więc zgodnie z Title 17, Chapter 1, Section 105 of the US Code, są one dostępne do użytku publicznego na licencji public domain.

Jeśli spojrzysz na `astronauts.json`, zobaczysz, że każdy astronauta jest zdefiniowany przez trzy pola: ID („grissom”, „white”, „chaffee”, itd.), ich imię („Virgil I. "Gus" Grissom”, itd.) oraz krótki opis, który został skopiowany z Wikipedii. Jeśli zamierzasz użyć tego tekstu w swoim projekcie komercyjnym, ważne jest, abyś podziękował Wikipedii i jej autorom oraz jasno wskazał, że praca jest licencjonowana na licencji CC-BY-SA, dostępnej tutaj: [https://creativecommons.org/licenses/by-sa/3.0](https://creativecommons.org/licenses/by-sa/3.0).

Teraz skonwertujemy dane astronautów na strukturę Swift – naciśnij Cmd+N, aby utworzyć nowy plik, wybierz Swift file, a następnie nazwij go `Astronaut.swift`. Wprowadź poniższy kod:

```swift
struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}
```

Jak widzisz, zastosowałem protokół `Codable`, aby móc tworzyć instancje tej struktury bezpośrednio z JSON, ale również `Identifiable`, aby móc używać tablic astronautów w `ForEach` i więcej – pole `id` będzie do tego idealne.

Następnie chcemy przekształcić `astronauts.json` w słownik instancji `Astronaut`, co oznacza, że musimy użyć `Bundle`, aby znaleźć ścieżkę do pliku, załadować go do instancji `Data`, a następnie przekazać przez `JSONDecoder`. Wcześniej umieszczaliśmy to w metodzie na `ContentView`, ale tutaj chciałbym pokazać ci lepszy sposób: napiszemy rozszerzenie `Bundle`, aby zrobić to wszystko w jednym scentralizowanym miejscu.

Utwórz kolejny nowy plik Swift, tym razem nazwij go `Bundle-Decodable.swift`. Będzie on zawierał kod, który już widziałeś, ale jest jedna mała różnica: wcześniej używaliśmy `String(contentsOf:)`, aby ładować pliki do stringa, ale ponieważ `Codable` używa `Data`, zamiast tego użyjemy `Data(contentsOf:)`. Działa to w ten sam sposób, co `String(contentsOf:)`: podaj adres URL pliku do załadowania, a on zwróci jego zawartość lub zgłosi błąd.

Dodaj to teraz do `Bundle-Decodable.swift`:

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

Wrócimy do tego za chwilę, ale jak widzisz, używa on hojnie `fatalError()`: jeśli pliku nie można znaleźć, załadować lub zdekodować, aplikacja się zawiesi. Jak wcześniej, jednakże, to nigdy się nie zdarzy, chyba że popełnisz błąd, na przykład zapomnisz skopiować plik JSON do swojego projektu.

Teraz możesz się zastanawiać, dlaczego użyliśmy rozszerzenia, a nie metody, ale zaraz stanie się to jasne, gdy załadujemy ten JSON do naszego widoku treści. Dodaj tę właściwość do struktury `ContentView`:

```swift
let astronauts = Bundle.main.decode("astronauts.json")
```

Tak, to wszystko, co jest potrzebne. Oczywiście wszystko, co zrobiliśmy, to przeniesienie kodu z `ContentView` do rozszerzenia, ale nie ma w tym nic złego – cokolwiek możemy zrobić, aby nasze widoki były małe i skoncentrowane, jest dobrą rzeczą.

Jeśli chcesz upewnić się, że twój JSON jest poprawnie załadowany, zmień domyślną właściwość `body` na tę:

```swift
Text(String(astronauts.count))
```

Powinno to wyświetlić liczbę 32 zamiast „Hello World”.

Zanim skończymy, chcę wrócić do naszego małego rozszerzenia i przyjrzeć się mu trochę dokładniej. Kod, który mamy, jest w pełni odpowiedni dla tej aplikacji, ale jeśli chcesz go użyć w przyszłości, zalecam dodanie kilku dodatkowych kodów, które pomogą ci zdiagnozować problemy.

Zastąp drugą część metody tym:

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

To nie jest wielka zmiana, ale oznacza to, że metoda teraz poinformuje cię, co poszło nie tak z dekodowaniem – to świetne rozwiązanie na sytuacje, kiedy twój kod Swift i plik JSON nie do końca się zgadzają!

# Użycie generyków do ładowania dowolnego rodzaju danych zgodnych z Codable

W poprzednich krokach dodaliśmy rozszerzenie `Bundle` do ładowania jednego specyficznego rodzaju danych JSON z naszego pakietu aplikacji, ale teraz mamy drugi rodzaj: `missions.json`. Ten plik zawiera nieco bardziej złożony JSON:

- Każda misja ma numer ID, co oznacza, że możemy łatwo użyć `Identifiable`.
- Każda misja ma opis, który jest swobodnym tekstem pobranym z Wikipedii.
- Każda misja ma tablicę członków załogi, gdzie każdy członek załogi ma imię i rolę.
- Wszystkie misje poza jedną mają datę startu. Niestety, Apollo 1 nigdy nie wystartował z powodu pożaru kabiny podczas prób przedstartowych, który zniszczył moduł dowodzenia i zabił załogę.

Zacznijmy od przekształcenia tego w kod. Role załogi muszą być reprezentowane jako osobna struktura, przechowująca ciąg znaków `name` oraz `role`. Utwórz nowy plik Swift o nazwie `Mission.swift` i dodaj do niego następujący kod:

```swift
struct CrewRole: Codable {
    let name: String
    let role: String
}
```

Jeśli chodzi o misje, to będą one zawierały ID jako liczbę całkowitą, tablicę `CrewRole` oraz opis jako ciąg znaków. Ale co z datą startu – może być, ale może jej nie być. Jak powinniśmy to przechowywać?

Pomyślmy: jak Swift reprezentuje takie "może być, może nie być" w innych przypadkach? Jak moglibyśmy przechowywać "może być ciągiem znaków, a może być niczym"? Mam nadzieję, że odpowiedź jest jasna: używamy opcjonalnych wartości. W rzeczywistości, jeśli oznaczymy właściwość jako opcjonalną, `Codable` automatycznie pominie ją, jeśli wartość będzie brakować w naszym wejściowym JSON.

Dodaj teraz drugą strukturę do `Mission.swift`:

```swift
struct Mission: Codable, Identifiable {
    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
}
```

Zanim przejdziemy do tego, jak załadować JSON do tej struktury, chcę pokazać jeszcze jedną rzecz: nasza struktura `CrewRole` została stworzona specjalnie do przechowywania danych o misjach, dlatego możemy ją umieścić wewnątrz struktury `Mission`, jak poniżej:

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

To się nazywa zagnieżdżona struktura i jest to po prostu jedna struktura umieszczona wewnątrz innej. Nie wpłynie to na nasz kod w tym projekcie, ale w innych przypadkach jest to przydatne do utrzymania porządku w kodzie: zamiast pisać `CrewRole`, napisałbyś `Mission.CrewRole`. Jeśli możesz sobie wyobrazić projekt z kilkuset typami niestandardowymi, dodanie tego kontekstu może naprawdę pomóc!

Teraz pomyślmy, jak możemy załadować `missions.json` do tablicy struktur `Mission`. Wcześniej dodaliśmy rozszerzenie `Bundle`, które ładuje plik JSON do słownika struktur `Astronaut`, więc moglibyśmy łatwo skopiować i wkleić to, a następnie dostosować, aby ładowało misje zamiast astronautów. Istnieje jednak lepsze rozwiązanie: możemy wykorzystać system generyków w Swifcie.

Generyki pozwalają nam pisać kod, który jest zdolny do pracy z różnymi typami. W tym projekcie napisaliśmy rozszerzenie `Bundle` do pracy ze słownikiem astronautów, ale tak naprawdę chcemy być w stanie obsługiwać słowniki astronautów, tablice misji lub potencjalnie wiele innych rzeczy.

Aby uczynić metodę generyczną, dodajemy do niej zastępczy typ. Jest on zapisany w nawiasach ostrych (`<` i `>`) po nazwie metody, ale przed jej parametrami, jak poniżej:

```swift
func decode<T>(_ file: String) -> [String: Astronaut] {
```

Możemy użyć dowolnej nazwy dla tego zastępczego typu – moglibyśmy napisać „Type”, „TypeOfThing” lub nawet „Fish”; to nie ma znaczenia. „T” to konwencja w programowaniu, jako skrót dla „type” (typ).

Wewnątrz metody możemy teraz używać „T” wszędzie tam, gdzie używaliśmy `[String: Astronaut]` – dosłownie jest to zastępstwo dla typu, z którym chcemy pracować. Tak więc zamiast zwracać `[String: Astronaut]`, używamy tego:

```swift
func decode<T>(_ file: String) -> T {
```

Bądź bardzo ostrożny: istnieje duża różnica między `T` a `[T]`. Pamiętaj, że `T` to zastępstwo dla dowolnego typu, o który poprosimy, więc jeśli powiemy „dekoduj nasz słownik astronautów”, to `T` stanie się `[String: Astronaut]`. Jeśli spróbujemy zwrócić `[T]` z `decode()`, w rzeczywistości zwrócimy `[[String: Astronaut]]` – tablicę słowników astronautów!

W środku metody `decode()` jest jeszcze jedno miejsce, gdzie używane jest `[String: Astronaut]`:

```swift
return try decoder.decode([String: Astronaut].self, from: data)
```

Tutaj również zmieniamy to na `T`, tak:

```swift
return try decoder.decode(T.self, from: data)
```

W ten sposób powiedzieliśmy, że `decode()` będzie używany z jakimś typem, takim jak `[String: Astronaut]`, i powinien spróbować zdekodować plik, który został załadowany, aby był tym typem.

Jeśli spróbujesz skompilować ten kod, zobaczysz błąd w Xcode: „Instance method 'decode(_:from:)' requires that 'T' conform to 'Decodable’”. Oznacza to, że `T` może być czymkolwiek: może być słownikiem astronautów, ale może być też czymś zupełnie innym. Problem polega na tym, że Swift nie może być pewien, że typ, z którym pracujemy, jest zgodny z protokołem `Codable`, więc zamiast ryzykować, odmawia zbudowania naszego kodu.

Na szczęście możemy to naprawić za pomocą ograniczenia: możemy powiedzieć Swiftowi, że `T` może być czymkolwiek, o ile jest zgodne z `Codable`. Dzięki temu Swift wie, że jest to bezpieczne, i upewni się, że nie próbujemy używać metody z typem, który nie jest zgodny z `Codable`.

Aby dodać to ograniczenie, zmień sygnaturę metody na:

```swift
func decode<T: Codable>(_ file: String) -> T {
```

Jeśli spróbujesz skompilować ponownie, zobaczysz, że nadal nie działa, ale teraz z innego powodu: „Generic parameter 'T' could not be inferred”, w odniesieniu do właściwości `astronauts` w `ContentView`. Ta linia działała wcześniej dobrze, ale teraz nastąpiła ważna zmiana: wcześniej `decode()` zawsze zwracało słownik astronautów, ale teraz zwraca cokolwiek chcemy, pod warunkiem, że jest zgodne z `Codable`.

Wiemy, że nadal zwróci słownik astronautów, ponieważ rzeczywiste dane nie uległy zmianie, ale Swift tego nie wie. Nasz problem polega na tym, że `decode()` może zwrócić dowolny typ zgodny z `Codable`, ale Swift potrzebuje więcej informacji – chce wiedzieć, jaki dokładnie typ to będzie.

Aby to naprawić, musimy użyć adnotacji typu, aby Swift wiedział dokładnie, czym będą `astronauts`:

```swift
let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
```

Wreszcie – po całej tej pracy! – możemy teraz również załadować `missions.json` do kolejnej właściwości w `ContentView`. Proszę, dodaj to poniżej `astronauts`:

```swift
let missions: [Mission] = Bundle.main.decode("missions.json")
```

I to jest właśnie moc generyków: możemy użyć tej samej metody `decode()

# Formatowanie widoku misji

Teraz, gdy mamy wszystkie dane na miejscu, możemy przyjrzeć się projektowi naszego pierwszego ekranu: siatce wszystkich misji z ich odznakami.

Dodane wcześniej zasoby zawierają obrazy o nazwach takich jak „apollo1@2x.png” i podobne, co oznacza, że są one dostępne w katalogu zasobów jako „apollo1”, „apollo12” i tak dalej. Nasza struktura `Mission` ma właściwość `id`, która zapewnia numer misji, więc możemy użyć interpolacji ciągów znaków, takich jak „apollo\(mission.id)” dla nazwy obrazu i „Apollo \(mission.id)” dla sformatowanej nazwy misji.

Tutaj jednak podejdziemy do tego inaczej: dodamy kilka właściwości wyliczanych do struktury `Mission`, które będą zwracać te same dane. Rezultat będzie ten sam – „apollo1” i „Apollo 1” – ale teraz kod będzie w jednym miejscu: w strukturze `Mission`. Oznacza to, że inne widoki mogą używać tych samych danych bez konieczności powtarzania naszego kodu do interpolacji ciągów, co z kolei oznacza, że jeśli zmienimy sposób formatowania tych danych – np. zmienimy nazwy obrazów na „apollo-1” lub coś innego – możemy po prostu zmienić właściwość w `Mission`, a cały nasz kod zostanie zaktualizowany.

Dodaj teraz te dwie właściwości do struktury `Mission`:

```swift
var displayName: String {
    "Apollo \(id)"
}

var image: String {
    "apollo\(id)"
}
```

Gdy już mamy te dwie właściwości, możemy teraz wykonać pierwszy krok w wypełnianiu `ContentView`: będzie to `NavigationStack` z tytułem, `LazyVGrid` używający naszej tablicy misji jako danych wejściowych, a każdy wiersz w tej siatce będzie `NavigationLink`, zawierającym obraz, nazwę i datę startu misji. Jedyną małą złożonością tutaj jest to, że nasza data startu jest opcjonalnym ciągiem znaków, więc musimy użyć operatora nil coalescing, aby upewnić się, że istnieje wartość do wyświetlenia w widoku tekstu.

Najpierw dodaj tę właściwość do `ContentView`, aby zdefiniować adaptacyjny układ kolumn:

```swift
let columns = [
    GridItem(.adaptive(minimum: 150))
]
```

A teraz zastąp swoją obecną właściwość `body` tym kodem:

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

Wiem, że wygląda to dość surowo, ale zaraz to poprawimy. Najpierw skupmy się na tym, co mamy do tej pory: przewijaną, pionową siatkę, która używa `resizable()`, `scaledToFit()` i `frame()`, aby obraz zajmował przestrzeń 100x100, zachowując przy tym oryginalne proporcje.

Uruchom program teraz i oprócz zmian w układzie, zauważysz, że daty nie wyglądają najlepiej – chociaż możemy zobaczyć „1968-12-21” i zrozumieć, że to 21 grudnia 1968 roku, jest to nadal nienaturalny format daty dla większości ludzi. Możemy to poprawić!

Typ `JSONDecoder` w Swift ma właściwość `dateDecodingStrategy`, która określa, jak powinien dekodować daty. Możemy przekazać jej instancję `DateFormatter`, która opisuje, jak nasze daty są formatowane. W tym przypadku nasze daty są zapisane jako rok-miesiąc-dzień, co w świecie `DateFormatter` jest zapisane jako „y-MM-dd” – to oznacza „rok, a potem myślnik, potem miesiąc z zerem na początku, potem myślnik, a potem dzień z zerem na początku”, przy czym „z zerem na początku” oznacza, że styczeń jest zapisany jako „01”, a nie „1”.

**Ostrzeżenie:** Formatowanie dat jest wrażliwe na wielkość liter! `mm` oznacza „minuty z zerem na początku”, a `MM` oznacza „miesiąc z zerem na początku”.

Otwórz plik `Bundle-Decodable.swift` i dodaj ten kod bezpośrednio po `let decoder = JSONDecoder()`:

```swift
let formatter = DateFormatter()
formatter.dateFormat = "y-MM-dd"
decoder.dateDecodingStrategy = .formatted(formatter)
```

To mówi dekoderowi, aby analizował daty w dokładnym formacie, którego oczekujemy.

**Wskazówka:** Podczas pracy z datami często warto być precyzyjnym co do swojej strefy czasowej, w przeciwnym razie podczas parsowania daty i czasu używana jest strefa czasowa użytkownika. Jednak będziemy również wyświetlać datę w strefie czasowej użytkownika, więc tutaj nie ma problemu.

Jeśli teraz uruchomisz kod… nic się nie zmieni. Tak, nic się nie zmieniło, ale to jest w porządku: nic się nie zmieniło, ponieważ Swift nie zdaje sobie sprawy, że `launchDate` to data. W końcu zadeklarowaliśmy ją tak:

```swift
let launchDate: String?
```

Teraz, gdy nasz kod dekodowania rozumie, jak nasze daty są formatowane, możemy zmienić tę właściwość na opcjonalną datę:

```swift
let launchDate: Date?
```

… a teraz nasz kod nawet się nie skompiluje!

Problem teraz tkwi w tej linii kodu w `ContentView.swift`:

```swift
Text(mission.launchDate ?? "N/A")
```

To próbuje użyć opcjonalnej daty w widoku tekstu lub zastąpić ją „N/A”, jeśli data jest pusta. To jest kolejne miejsce, w którym lepiej sprawdzi się właściwość wyliczana: możemy poprosić samą misję o dostarczenie sformatowanej daty startu, która przekształci opcjonalną datę w ładnie sformatowany ciąg znaków lub zwróci „N/A” dla brakujących dat.

Używa to tej samej metody `formatted()`, której używaliśmy wcześniej, więc powinno to być dla ciebie nieco znajome. Dodaj teraz tę właściwość wyliczaną do `Mission`:

```swift
var formattedLaunchDate: String {
    launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
}
```

A teraz zastąp uszkodzony widok tekstowy w `ContentView` tym:

```swift
Text(mission.formattedLaunchDate)
```

Dzięki tej zmianie nasze daty będą wyświetlane w znacznie bardziej naturalny sposób, a co więcej, będą wyświetlane w sposób odpowiedni dla regionu użytkownika – to, co widzisz, niekoniecznie musi być tym, co widzę ja.

Teraz skupmy się na większym problemie: nasz układ jest dość nudny!

Aby nieco go urozmaicić, chcę przedstawić dwie przydatne funkcje: jak łatwo udostępniać niestandardowe kolory aplikacji oraz jak wymusić ciemny motyw dla naszej aplikacji.

Najpierw kolory. Istnieją dwa sposoby na to, i oba są przydatne: możesz dodać kolory do swojego katalogu zasobów pod określonymi nazwami, lub możesz dodać je jako rozszerzenia w Swift. Oba mają swoje zalety – używanie katalogu zasobów pozwala pracować wizualnie, ale używanie kodu ułatwia monitorowanie zmian za pomocą czegoś takiego jak GitHub.

Z dwóch preferuję podejście oparte na kodzie, ponieważ ułatwia to śledzenie zmian, gdy pracujesz w zespołach, więc dodamy nazwy naszych kolorów do Swifta jako rozszerzenia.

Jeśli zrobimy te rozszerzenia na `Color`, możemy używać ich w kilku miejscach w SwiftUI, ale Swift daje nam lepszą opcję za pomocą tylko trochę więcej kodu. Widzisz, `Color` przestrzega większego protokołu o nazwie `ShapeStyle`, który pozwala nam używać kolorów, gradientów, materiałów i innych jako jednego i tego samego elementu.

Ten protokół `ShapeStyle` jest tym, co wykorzystuje modyfikator `background()`, więc to, co naprawdę chcemy zrobić, to rozszerzyć `Color`, ale w taki sposób, aby wszystkie modyfikatory SwiftUI używające `ShapeStyle` również działały. Można to zrobić za pomocą bardzo precyzyjnego rozszerzenia, które dosłownie mówi „chcemy dodać funkcjonalność do `ShapeStyle`, ale tylko wtedy, gdy jest używany jako kolor.”

Aby to wypróbować, utwórz nowy plik Swift o nazwie `Color-Theme.swift`, zmień jego import Foundation na SwiftUI, a następnie dodaj ten kod:

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

To dodaje dwa nowe kolory o nazwach `darkBackground` i `lightBackground`, każdy z precyzyjnymi wartościami dla czerwonego, zielonego i niebieskiego. Ale co ważniejsze, umieszczają te kolory wewnątrz bardzo specyficznego rozszerzenia, które pozwala nam używać tych kolorów wszędzie tam, gdzie SwiftUI oczekuje `ShapeStyle`.

Chcę, żebyśmy od razu użyli tych nowych kolorów. Najpierw znajdź `VStack` zawierający nazwę misji i datę startu – powinno tam już być `frame(maxWidth: .infinity)`, ale chciałbym, abyś zmienił kolejność modyfikatorów na:

```swift
.padding(.vertical)
.frame(maxWidth: .infinity)
.background(.lightBackground)
```

Następnie chcę, aby zewnętrzny `VStack` – ten, który jest całą etykietą dla naszego `NavigationLink` – wyglądał bardziej jak pudełko w naszej siatce, co oznacza narysowanie wokół niego linii i nieco przycięcie kształtu. Aby uzyskać ten efekt, dodaj te modyfikatory na jego końcu:

```swift
.clipShape(.rect(cornerRadius: 10))
.overlay(
    RoundedRectangle(cornerRadius: 10)
        .stroke(.lightBackground)
)
```

Po trzecie, musimy dodać trochę odstępu, aby odsunąć elementy od ich krawędzi. Oznacza to dodanie prostego odstępu do obrazów misji, bezpośrednio po ich ramce 100x100:

```swift
.padding()
```

Następnie dodaj również trochę odstępu poziomego i dolnego do siatki:

```swift
.padding([.horizontal, .bottom])
```

**Ważne:** Ten odstęp powinien być dodany do `LazyVGrid`, a nie do `ScrollView`. Jeśli dodasz odstęp do `ScrollView`, dodajesz również odstęp do jego pasków przewijania, co będzie wyglądać dziwnie.

Teraz możemy zastąpić białe tło niestandardowym kolorem tła, który stworzyliśmy wcześniej – dodaj ten modyfikator do `ScrollView`, po jego modyfikatorze `navigationTitle()`:

```swift
.background(.darkBackground)
```

Na tym etapie nasz niestandardowy układ jest prawie gotowy, ale aby go dokończyć, przyjrzymy się pozostałym kolorom – jasnoniebieski kolor używany dla tekstu naszej misji nie jest najlepszy, a tytuł „Moonshot” u góry jest czarny, co sprawia, że jest niemożliwy do odczytania na naszym ciemnoniebieskim tle.

Możemy naprawić pierwszy z tych problemów, przypisując konkretne kolory do tych dwóch pól tekstowych:

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

Użycie półprzezroczystej bieli dla koloru pierwszego planu pozwala, aby tylko odrobina koloru z tyłu prześwitywała.

Jeśli chodzi o tytuł „Moonshot”, należy on do naszego `NavigationStack` i będzie się pojawiał albo czarny, albo biały, w zależności od tego, czy użytkownik jest w trybie jasnym, czy ciemnym. Aby to naprawić, możemy powiedzieć SwiftUI, że nasz widok preferuje zawsze ciemny tryb – to spowoduje, że tytuł będzie biały niezależnie od tego, jaki wygląd użytkownik ma włączony, a także przyciemni inne kolory, takie jak tła paska nawigacji.

Aby dokończyć projekt tego widoku, dodaj ten ostatni modyfikator do `ScrollView`, poniżej jego koloru tła:

```swift
.preferredColorScheme(.dark)
```

Jeśli teraz uruchomisz aplikację, zobaczysz, że mamy pięknie przewijającą się siatkę danych misji, która płynnie dostosowuje się do szerokiego zakresu rozmiarów urządzeń, mamy jasnobiały tekst nawigacyjny i ciemne tło nawigacyjne niezależnie od włączonego wyglądu, a dotknięcie którejkolwiek z naszych misji wyświetli tymczasowy widok szczegółów. Świetny początek!



# Wyświetlanie szczegółów misji za pomocą ScrollView i containerRelativeFrame()

Gdy użytkownik wybierze jedną z misji Apollo z naszej głównej listy, chcemy wyświetlić informacje o tej misji: jej odznakę, opis misji oraz wszystkich astronautów, którzy brali udział w misji, wraz z ich rolami. Pierwsze dwa elementy nie są trudne, ale trzeci wymaga trochę więcej pracy, ponieważ musimy dopasować identyfikatory załogi do szczegółów załogi z naszych dwóch plików JSON.

Zacznijmy od prostych rzeczy i stopniowo dodawajmy więcej: utwórz nowy widok SwiftUI o nazwie `MissionView.swift`. Początkowo będzie on miał tylko właściwość `mission`, abyśmy mogli wyświetlić odznakę misji i opis, ale wkrótce dodamy do tego więcej elementów.

Jeśli chodzi o układ, ten widok powinien mieć przewijany `VStack` z obrazem odznaki misji, który można zmieniać rozmiar, a następnie widok tekstowy. Użyjemy `containerRelativeFrame()`, aby ustawić szerokość obrazu misji – po pewnych próbach i błędach stwierdziłem, że odznaka misji najlepiej wyglądała, gdy nie była na pełnej szerokości – najlepiej wyglądało to, gdy miała od 50% do 70% szerokości, aby uniknąć zbyt dużego rozmiaru na ekranie.

Wstaw ten kod do pliku `MissionView.swift`:

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

Umieszczenie `VStack` wewnątrz innego `VStack` pozwala nam kontrolować wyrównanie dla jednej konkretnej części naszego widoku – nasz główny obraz misji może być wyśrodkowany, podczas gdy szczegóły misji mogą być wyrównane do lewej krawędzi.

Z nowym widokiem w miejscu kod nie będzie się kompilował, wszystko z powodu struktury `#Preview` poniżej, która potrzebuje obiektu `Mission`, aby miała co renderować. Na szczęście nasze rozszerzenie `Bundle` jest tutaj również dostępne:

```swift
#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")

    return MissionView(mission: missions[0])
        .preferredColorScheme(.dark)
}
```

**Wskazówka:** Ten widok automatycznie będzie miał ciemny schemat kolorów, ponieważ jest stosowany do `NavigationStack` w `ContentView`, ale podgląd `MissionView` tego nie wie, więc musimy to włączyć ręcznie.

Jeśli spojrzysz w podgląd, zobaczysz, że to dobry początek, ale następna część jest trudniejsza: chcemy wyświetlić listę astronautów, którzy brali udział w misji, poniżej opisu. Zajmijmy się tym w kolejnym kroku.

# Łączenie struktur Codable

Pod naszą misją chcemy wyświetlić zdjęcia, nazwiska i role każdego członka załogi, co oznacza dopasowanie danych, które pochodzą z dwóch różnych plików JSON.

Jak pamiętacie, nasze dane JSON są podzielone na `missions.json` i `astronauts.json`. Eliminuje to duplikację w naszych danych, ponieważ niektórzy astronauci brali udział w wielu misjach, ale oznacza to również, że musimy napisać kod, który połączy nasze dane – na przykład, aby "armstrong" zamienić na "Neil A. Armstrong". Z jednej strony mamy misje, które wiedzą, że członek załogi "armstrong" miał rolę "Commander", ale nie mają pojęcia, kim jest "armstrong", a z drugiej strony mamy "Neil A. Armstrong" i opis jego osoby, ale bez informacji, że był on dowódcą na Apollo 11.

Co musimy zrobić, to sprawić, by nasz `MissionView` akceptował misję, którą wybrano, wraz z pełnym słownikiem astronautów, a następnie ustalić, którzy astronauci faktycznie brali udział w misji.

Dodaj teraz tę zagnieżdżoną strukturę wewnątrz `MissionView`:

```swift
struct CrewMember {
    let role: String
    let astronaut: Astronaut
}
```

Teraz nadchodzi trudniejsza część: musimy dodać właściwość do `MissionView`, która przechowuje tablicę obiektów `CrewMember` – są to w pełni rozstrzygnięte pary rola/astronauta. Początkowo jest to proste dodanie kolejnej właściwości:

```swift
let crew: [CrewMember]
```

Ale jak ustawić tę właściwość? Pomyśl o tym: jeśli przekażemy tej widokowi jego misję i wszystkich astronautów, możemy przejść przez załogę misji, a następnie dla każdego członka załogi poszukać w słowniku tego, który ma pasujące ID. Kiedy znajdziemy odpowiedniego astronautę, możemy zamienić go i jego rolę na obiekt `CrewMember`, ale jeśli go nie znajdziemy, oznacza to, że w jakiś sposób mamy rolę załogi z nieprawidłowym lub nieznanym imieniem.

Ten ostatni przypadek nie powinien się nigdy zdarzyć. Aby być jasnym, jeśli dodasz jakieś dane JSON do swojego projektu, które wskazują na brakujące dane w twojej aplikacji, popełniłeś fundamentalny błąd – to nie jest coś, na co powinieneś pisać obsługę błędów w czasie wykonania, ponieważ nie powinno się to zdarzyć w pierwszej kolejności. Dlatego jest to świetny przykład, gdzie użycie `fatalError()` jest przydatne: jeśli nie możemy znaleźć astronauty za pomocą jego ID, powinniśmy natychmiast wyjść i głośno narzekać.

Zamieńmy to wszystko na kod, używając niestandardowego inicjalizatora dla `MissionView`. Jak powiedziałem, będzie on akceptował misję, którą reprezentuje, wraz ze wszystkimi astronautami, a jego zadaniem jest zapisanie misji, a następnie ustalenie tablicy rozstrzygniętych astronautów.

Oto kod:

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

Jak tylko ten kod zostanie dodany, nasza struktura `#Preview` przestanie działać, ponieważ potrzebuje więcej informacji. Dodaj więc drugie wywołanie `decode()` tam, aby załadowało wszystkich astronautów i przekaż ich również:

```swift
#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
```

Teraz, gdy mamy wszystkie nasze dane astronautów, możemy wyświetlić je bezpośrednio pod opisem misji, używając poziomego `ScrollView`. Dodamy również nieco więcej stylizacji do zdjęć astronautów, aby wyglądały lepiej, używając kształtu kapsuły (`capsule`) oraz obramowania (`overlay`).

Dodaj ten kod tuż po `VStack(alignment: .leading)`:

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

Dlaczego po `VStack`, a nie wewnątrz? Ponieważ widoki przewijania działają najlepiej, gdy w pełni wykorzystują dostępną przestrzeń ekranu, co oznacza, że powinny przewijać się od krawędzi do krawędzi. Gdybyśmy umieścili to wewnątrz naszego `VStack`, miałoby to takie samo wcięcie jak reszta naszego tekstu, co oznacza, że przewijanie działałoby dziwnie – załoga byłaby przycinana, gdyby dotarła do lewej krawędzi naszego `VStack`, co wyglądałoby dziwnie.

Zaraz sprawimy, że `NavigationLink` będzie robił coś bardziej użytecznego, ale najpierw musimy zmodyfikować `NavigationLink` w `ContentView` – obecnie przesuwa się do `Text("Detail View")`, ale zamień to na:

```swift
MissionView(mission: mission, astronauts: astronauts)
```

Teraz uruchom aplikację w symulatorze – zaczyna być użyteczna!

Zanim przejdziesz dalej, spróbuj spędzić kilka minut na dostosowywaniu sposobu, w jaki wyświetlani są astronauci – użyłem kształtu kapsuły i obramowania, ale możesz spróbować okręgów lub zaokrąglonych prostokątów, możesz użyć różnych czcionek lub większych obrazów, a nawet dodać sposób oznaczania, kto był dowódcą misji.

W moim projekcie uważam, że warto dodać trochę wizualnego oddzielenia w naszym widoku misji, aby odznaka misji, opis i załoga były wyraźnie rozdzielone.

SwiftUI oferuje dedykowany widok `Divider` do tworzenia wizualnego podziału w twoim układzie, ale nie jest on konfigurowalny – to zawsze tylko cienka linia. Dlatego, aby uzyskać coś bardziej przydatnego, narysuję niestandardowy podział, aby rozbić nasz widok.

Najpierw umieść to bezpośrednio przed tekstem "Mission Highlights":

```swift
Rectangle()
    .frame(height: 2)
    .foregroundStyle(.lightBackground)
    .padding(.vertical)
```

Teraz umieść kolejny taki sam podział – ten sam kod – bezpośrednio po tekście `mission.description`. O wiele lepiej!

Aby zakończyć ten widok, dodam tytuł przed naszą załogą, ale trzeba to zrobić ostrożnie. Widzisz, mimo że dotyczy to widoku przewijania, musi mieć takie samo wcięcie jak reszta naszego tekstu. Więc najlepsze miejsce na to jest wewnątrz `VStack`, bezpośrednio po poprzednim prostokącie:

```swift
Text("Crew")
    .font(.title.bold())
    .padding(.bottom, 5)
```

Nie musisz go tam umieszczać – jeśli chcesz, możemy przenieść to poza `VStack`, a następnie zastosować wcięcie indywidualnie do tego widoku tekstowego. Jeśli jednak to zrobisz, upewnij się, że zastosujesz takie samo wcięcie, aby wszystko było ładnie wyrównane.

# Zakończenie z ostatnim widokiem

Aby zakończyć ten program, stworzymy trzeci i ostatni widok, który wyświetli szczegóły astronauty. Będzie on osiągany przez stuknięcie jednego z astronautów w widoku misji. To powinno być dla Ciebie głównie ćwiczenie, ale mam nadzieję, że pokaże Ci również, jak ważny jest `NavigationStack` – wchodzimy głębiej w informacje naszej aplikacji, a prezentacja widoków, które przesuwają się i znikają, naprawdę uświadamia to użytkownikowi.

Zacznij od stworzenia nowego widoku SwiftUI o nazwie `AstronautView`. Będzie on miał pojedynczą właściwość `Astronaut`, dzięki czemu będzie wiedział, co wyświetlić, a następnie zostanie on ułożony przy użyciu podobnej kombinacji `ScrollView/VStack`, jaką mieliśmy w `MissionView`. Dodaj ten kod:

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

Ponownie musimy zaktualizować podgląd, aby tworzył widok z danymi:

```swift
#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return AstronautView(astronaut: astronauts["aldrin"]!)
        .preferredColorScheme(.dark)
}
```

Teraz możemy wyświetlić ten widok z `NavigationLink` w `MissionView`. Obecnie wskazuje on na `Text("Astronaut details")`, ale możemy zaktualizować go, aby wskazywał na nasz nowy `AstronautView`:

```swift
AstronautView(astronaut: crewMember.astronaut)
```

To było łatwe, prawda? Ale jeśli teraz uruchomisz aplikację, zobaczysz, jak naturalnie wygląda nasz interfejs użytkownika – zaczynamy od najszerszego poziomu informacji, pokazując wszystkie nasze misje, a następnie stukamy, aby wybrać jedną konkretną misję, a następnie stukamy, aby wybrać jednego konkretnego astronautę. iOS automatycznie animuje wprowadzenie nowych widoków, ale także zapewnia przyciski wstecz i przesunięcia, aby wrócić do poprzednich widoków.

# Podsumowanie projektu Moonshot

Paul Hudson @twostraws 1 listopada 2023

Ta aplikacja jest najbardziej złożoną, jaką dotychczas zbudowaliśmy. Oprócz kilku widoków, odeszliśmy od list i formularzy, przechodząc do własnych układów przewijanych, używając `containerRelativeFrame()`, aby uzyskać precyzyjne rozmiary i maksymalnie wykorzystać dostępną przestrzeń.

Ale to także najtrudniejszy kod Swift, jaki napisaliśmy do tej pory – generics są niesamowicie potężną funkcją, a gdy dodasz ograniczenia, otwierasz ogromne możliwości, które pozwalają zaoszczędzić czas, jednocześnie zyskując elastyczność.

Teraz zaczynasz również dostrzegać, jak użyteczny jest `Codable`: jego zdolność do dekodowania hierarchii danych za jednym zamachem jest nieoceniona, dlatego jest centralnym elementem tak wielu aplikacji napisanych w Swift.

## Przegląd tego, czego się nauczyłeś
Każdy może przejść przez tutorial, ale potrzeba prawdziwej pracy, aby zapamiętać to, czego się nauczyło. Moim zadaniem jest upewnienie się, że wyniesiesz z tych tutoriali jak najwięcej, więc przygotowałem krótkie podsumowanie, które pomoże Ci sprawdzić, co zapamiętałeś.

Kliknij tutaj, aby przejrzeć, czego nauczyłeś się w tym projekcie.

## Wyzwanie
Jednym z najlepszych sposobów nauki jest jak najczęstsze pisanie własnego kodu, więc oto trzy sposoby, w jakie powinieneś spróbować rozszerzyć tę aplikację, aby upewnić się, że w pełni rozumiesz, o co chodzi.

1. Dodaj datę startu do `MissionView`, poniżej emblematu misji. Możesz wybrać inne formatowanie, biorąc pod uwagę, że dostępne jest więcej miejsca, ale to zależy od Ciebie.
2. Wyodrębnij jeden lub dwa fragmenty kodu widoku do nowych widoków SwiftUI – poziomy widok przewijania w `MissionView` jest doskonałym kandydatem, ale jeśli podążałeś za moim stylizowaniem, możesz także przenieść prostokątne podzielniki.
3. Dla bardziej zaawansowanego wyzwania dodaj element paska narzędzi do `ContentView`, który przełącza między wyświetlaniem misji jako siatki a listą.

**Wskazówka:** W przypadku ostatniego wyzwania najlepiej jest podzielić cały kod siatki i kod listy na dwa osobne widoki i przełączać się między nimi, używając warunku `if` w `ContentView`. Nie możesz dołączyć modyfikatorów SwiftUI do warunku `if`, ale możesz owinąć ten warunek w `Group`, a następnie dołączyć modyfikatory do tego `Group`, jak poniżej:

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

Możesz napotkać pewne trudności podczas stylizowania listy, ponieważ domyślnie mają one specyficzny wygląd na iOS. Spróbuj dołączyć `.listStyle(.plain)` do swojej listy, a następnie coś w rodzaju `.listRowBackground(Color.darkBackground)` do zawartości wiersza listy – to powinno znacznie przybliżyć Cię do celu.

### Moonshot: Realizacja wyzwań

### Wyzwanie 1: Wyświetlanie daty startu
Pierwszym wyzwaniem jest dodanie daty startu dla każdej misji, wyświetlanej poniżej emblematu misji w `MissionView`. To zadanie jest stosunkowo proste, ale wymaga formatowania daty w zależności od tego, jak chcesz, aby była wyświetlana.

Rozwiązanie:
1. Otwórz plik `MissionView.swift`.
2. Dodaj poniższy kod pod emblematem misji, aby wyświetlić datę startu, jeśli jest dostępna:
   ```swift
   if let date = mission.launchDate {
       Label(date.formatted(date: .complete, time: .omitted), systemImage: "calendar")
   }
   ```

### Wyzwanie 2: Wyodrębnianie podwidoków
Drugim wyzwaniem jest wyodrębnienie jednego lub dwóch fragmentów kodu widoku do nowych widoków SwiftUI. Dzięki temu kod stanie się bardziej zorganizowany i łatwiejszy do utrzymania.

Rozwiązanie 1: Wyodrębnienie prostokątnego podzielnika.
1. Stwórz nowy widok SwiftUI o nazwie `CustomDivider.swift`.
2. Dodaj poniższy kod:
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
3. Teraz możesz zastąpić wszędzie tam, gdzie był używany prostokąt, wywołaniem `CustomDivider()`.

Rozwiązanie 2: Wyodrębnienie listy załogi.
1. Stwórz nowy widok SwiftUI o nazwie `CrewRoster.swift`.
2. Dodaj właściwość `crew`:
   ```swift
   let crew: [MissionView.CrewMember]
   ```
3. Przenieś cały kod poziomego `ScrollView` do ciała nowego widoku:
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
4. W `MissionView` zastąp kod wywołaniem `CrewRoster(crew: crew)`.

### Wyzwanie 3: Przełączanie między siatką a listą
Najtrudniejsze wyzwanie polega na dodaniu elementu paska narzędzi do `ContentView`, który pozwoli przełączać się między wyświetlaniem misji jako siatki a listy.

Rozwiązanie:
1. Stwórz nowy widok SwiftUI o nazwie `GridLayout.swift` i przenieś tam cały kod siatki z `ContentView`.
2. Stwórz nowy widok SwiftUI o nazwie `ListLayout.swift` i przenieś tam kod listy.
3. W `ContentView` dodaj stan `@State` do śledzenia, który układ jest wyświetlany:
   ```swift
   @State private var showingGrid = true
   ```
4. Zaktualizuj `ContentView`, aby wyświetlał odpowiedni widok na podstawie stanu:
   ```swift
   Group {
       if showingGrid {
           GridLayout(astronauts: astronauts, missions: missions)
       } else {
           ListLayout(astronauts: astronauts, missions: missions)
       }
   }
   ```
5. Dodaj przycisk do paska narzędzi, który pozwoli przełączać się między widokami:
   ```swift
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
   ```

### Bonus: Zapamiętywanie wyboru użytkownika
Możesz ulepszyć aplikację, aby zapamiętywała, który widok użytkownik wolał – siatkę czy listę.

Rozwiązanie:
1. Zmień właściwość `showingGrid` na `@AppStorage`, aby wartość była automatycznie zapamiętywana:
   ```swift
   @AppStorage("showingGrid") private var showingGrid = true
   ```

I to wszystko! Dzięki tym zmianom aplikacja będzie bardziej funkcjonalna i przyjazna dla użytkownika.