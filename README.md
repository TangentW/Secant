# Secant
Declarative form build on UITableView.

```swift
struct SimpleForm: Form {
    
    @State
    var isDisplayed = false

    @RowsBuilder
    var rows: Rows {
        Switch("Display", isOn: $isDisplayed)
        
        if isDisplayed {
            Label("Hello World")
        }
    }
}

let viewController = FormViewController(form: SimpleForm())
```
