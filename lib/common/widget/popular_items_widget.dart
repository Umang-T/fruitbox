import 'package:flutter/material.dart';
import '../../constants/global_variables.dart';

class  PopularItemsWidget extends StatefulWidget {
  const  PopularItemsWidget({super.key});

  @override
  State< PopularItemsWidget> createState() => _PopularItemsWidgetState();
}

class _PopularItemsWidgetState extends State< PopularItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
       child: GridView.count(
          childAspectRatio: 0.68,
          //physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          shrinkWrap: true,

          children: [
            for(int i=1; i<8; i++)
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: GlobalVariables.greyBackgroundColor,
                  borderRadius: BorderRadius.circular(10),


                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: GlobalVariables.secondaryColor,
                            borderRadius: BorderRadius.circular(10),

                          ),
                          child: const Text("-50%",style: TextStyle(
                            fontSize: 14,color: Colors.white,
                            fontWeight: FontWeight.bold,

                          ),),

                        ),
                        const Icon(
                          Icons.favorite_border,
                          color: Colors.red,

                        ),
                      ],
                    ),
                    InkWell(
                      onTap: (){},
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Image.asset("assets/images/cat1.png", height: 120, width: 120,),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Apple", style: TextStyle(fontSize: 18,color:  Colors.black , fontWeight: FontWeight.bold),

                      ),
                    ),
                    // Container(),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹200",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          Icon(
                            Icons.shopping_cart_checkout,
                            size: 25,
                            color: GlobalVariables.secondaryColor,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ],
        )
    );
    }
}