import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../core/constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String firebase =
      "https://res.cloudinary.com/practicaldev/image/fetch/s--ytGTW9Vg--/c_imagga_scale,f_auto,fl_progressive,h_900,q_auto,w_1600/https://thepracticaldev.s3.amazonaws.com/i/cufhvx44o66bb32ll2l8.png";

  String internationalization =
      "https://media.licdn.com/dms/image/C5112AQG-of-wGHAw-Q/article-cover_image-shrink_600_2000/0/1551286042912?e=2147483647&v=beta&t=Uao0Jl7quu1_LsSQzvLLnsqkONQSc7Lht4dR3dBq1Po";

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color surface = Theme.of(context).colorScheme.surface;
    Color onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: sWidth(context) * .04,
          vertical: 20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pushNamed(context, "/firebase"),
                        child: Ink(
                          height: 100,
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(cBorderRadius),
                            boxShadow: [
                              BoxShadow(
                                color: onSurface.withOpacity(.05),
                                spreadRadius: 1,
                                blurRadius: 3,
                              )
                            ],
                          ),
                          child: Image(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(firebase),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Firebase",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, "/internationalization"),
                        child: Ink(
                          height: 100,
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(cBorderRadius),
                            boxShadow: [
                              BoxShadow(
                                color: onSurface.withOpacity(.05),
                                spreadRadius: 1,
                                blurRadius: 3,
                              )
                            ],
                          ),
                          child: Image(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(internationalization),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Internationalization",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
