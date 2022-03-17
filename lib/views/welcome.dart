// ignore_for_file: unnecessary_const, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WelcomeScreen extends StatefulWidget {
  final String apiUrl;
  const WelcomeScreen({required this.apiUrl});
  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  static const routeName = '/welcome-screen';
  double _anim_wrapper_height = 0.35;
  bool busy = false;
  @override
  void initState() {
    super.initState();
  }

  initIntroAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      _anim_wrapper_height = 0.46;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
              tag: 'bg-transition',
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/auth_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          Positioned(
            bottom: -40,
            left: -10,
            right: -10,
            child: Hero(
                tag: 'clip-transition',
                child: AnimatedContainer(
                  curve: Curves.linearToEaseOut,
                  duration: const Duration(milliseconds: 1000),
                  height:
                      MediaQuery.of(context).size.height * _anim_wrapper_height,
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    color: Colors.black,
                  ),
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 25),
                  child: Shimmer.fromColors(
                    child: Column(
                      children: [
                        const Hero(
                            tag: 'title-transition',
                            child: Text(
                              "Flash",
                              style: TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),
                        const Hero(
                            tag: 'subtitle-transition',
                            child: Text(
                              'By Iky Masie',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            )),
                      ],
                    ),
                    baseColor: Colors.black,
                    highlightColor: Colors.amber,
                    loop: 50,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    busy
                        ? Container()
                        : Container(
                            height: 72,
                            width: double.infinity,
                            child: Material(
                              color: Colors.lightGreen,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: InkWell(
                                onTap: () {},
                                child: Center(
                                  child: Text(
                                    busy ? 'Eita!!' : 'Buy Airtime',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.only(
                                top: 25, left: 24, right: 24),
                          ),
                  ],
                ),
              ),
            ],
          ),
          AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.decelerate,
              left: 0,
              right: 0,
              bottom:
                  _anim_wrapper_height * MediaQuery.of(context).size.height -
                      80,
              child: _getIcon()),
        ],
      ),
    );
  }

  Widget _getIcon() {
    if (busy) {
      return SizedBox(
        height: 60,
        width: 60,
        child: Material(
          color: Colors.black,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: const Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              height: 60,
              width: 60,
              child: const CircularProgressIndicator(
                color: Colors.amber,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      );
    } else {
      return Hero(
          tag: 'app-icon',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
            height: 70,
            width: 70,
            decoration: const BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/icons/icon.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ));
    }
  }
}
