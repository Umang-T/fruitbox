import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: appPading,
        right: appPading,
        top: appPading ,

      ),

      child: Material(
        elevation: 10.0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        child: const TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(
                vertical: appPading*0.75,
                horizontal: appPading,

              ),
              fillColor: Colors.white,
              hintText: 'Search here......',
              suffixIcon: Icon(Icons.search_rounded,size: 30 , color: GlobalVariables.secondaryColor,)

          ),
        ),

      )
      ,);
    }
}