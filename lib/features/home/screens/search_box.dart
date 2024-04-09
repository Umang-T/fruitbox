import 'package:flutter/material.dart';
import '../../../constants/global_variables.dart';
import '../../user/models/category_model.dart';
import '../../user/models/product_model.dart';
import '../../../common/widget/card.dart';

class SearchResults extends StatelessWidget {
  final List<dynamic> results;

  const SearchResults({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          if (result is Category) {
            return buildCategoryCard(result);
          } else if (result is Product) {
            return buildProductCard(result);
          } else {
            return Container(); // Return an empty container for other types of data
          }
        },
      ),
    );
  }

  Widget buildCategoryCard(Category category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Card(
        elevation: 5,
        child: ListTile(
          title: Text(category.name),
          onTap: () {
            // Handle category tap
          },
        ),
      ),
    );
  }

  Widget buildProductCard(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ProductCard(product: product),
    );
  }
}

class SearchBox extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const SearchBox({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: appPading,
        right: appPading,
        top: appPading,
      ),
      child: Material(
        elevation: 10.0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        child: TextField(
          onChanged: onSearch, // Call the callback function when the text changes
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(
              vertical: appPading * 0.75,
              horizontal: appPading,
            ),
            fillColor: Colors.white,
            hintText: 'Find your choice!',
            suffixIcon: Icon(
              Icons.search_rounded,
              size: 30,
              color: GlobalVariables.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
