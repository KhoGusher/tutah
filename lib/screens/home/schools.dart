import 'package:flutter/material.dart';

import '../../../constants.dart';

class Schools extends StatelessWidget {
  const Schools({super.key});


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            children: [
              RecomendPlantCard(
                image: "assets/images/image_1.png",
                title: "MUBAS",
                country: "Malawi",
                price: 440,
                press: () {

                },
              ),
              RecomendPlantCard(
                image: "assets/images/image_2.png",
                title: "MUST",
                country: "Malawi",
                price: 440,
                press: () {

                },
              ),
            ],
          ),
          Row(
            children: [
              RecomendPlantCard(
                image: "assets/images/image_3.png",
                title: "COM",
                country: "Malawi",
                price: 440,
                press: () {},
              ),
              RecomendPlantCard(
                image: "assets/images/image_3.png",
                title: "LUANAR",
                country: "Malawi",
                price: 440,
                press: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecomendPlantCard extends StatelessWidget {

  final String image, title, country;
  final int price;
  final Function press;

  const RecomendPlantCard({super.key, required this.image, required this.title, required this.country, required this.price, required this.press});


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 5,
        bottom: kDefaultPadding * 2.5,
      ),
      width: size.width * 0.4,
      child: GestureDetector(
        onTap: (){
          // go to faculties
          Navigator.pushNamed(
              context,
              'facultyDept'
          );
        },
        child: Column(
          children: <Widget>[
            Image.asset(image),
            Container(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "$title\n".toUpperCase(),
                            style: Theme.of(context).textTheme.labelLarge),
                        TextSpan(
                          text: country.toUpperCase(),
                          style: TextStyle(
                            color: kPrimaryColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$$price',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: kPrimaryColor),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}