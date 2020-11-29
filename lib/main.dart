import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(MultipleCategorySelection());
}

class MultipleCategorySelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Dialog category selector")),
        body: CategorySelector(
          ["Banana", "Pear", "Apple", "Strawberry", "Pineapple"],
        ),
      ),
    );
  }
}

class CategorySelector extends HookWidget {
  final List<String> categories;

  CategorySelector(this.categories);
  @override
  Widget build(BuildContext context) {
    final selectedCategories = useState(List<String>());
    return Column(
      children: [
        RaisedButton(
          child: Text("Select Fruit"),
          onPressed: () async {
            List<String> selection = await showDialog(
              context: context,
              child: new Dialog(
                child: CategorySelectorDialog(
                    categories, List.from(selectedCategories.value)),
              ),
            );
            selectedCategories.value = selection;
          },
        ),
        Container(
          color: Colors.green,
          height: 2,
        ),
        SelectedCategories(
          categories: selectedCategories.value,
        )
      ],
    );
  }
}

class SelectedCategories extends StatelessWidget {
  final List<String> categories;

  const SelectedCategories({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(categories[index]),
            );
          }),
    );
  }
}

class CategorySelectorDialog extends HookWidget {
  final List<String> categories;
  final List<String> currentSelection;

  CategorySelectorDialog(this.categories, this.currentSelection);

  @override
  Widget build(BuildContext context) {
    final selectedCategories = useState(currentSelection);
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  value: selectedCategories.value.contains(categories[index]),
                  onChanged: (bool selected) {
                    if (selected) {
                      selectedCategories.value += [categories[index]];
                    } else {
                      selectedCategories.value.remove(categories[index]);
                      selectedCategories.value =
                          List.from(selectedCategories.value);
                    }
                  },
                  title: Text(categories[index]),
                );
              }),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pop(context, currentSelection);
          },
          child: Text("Cancel"),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pop(context, selectedCategories.value);
          },
          child: Text("Done"),
        )
      ],
    );
  }
}
