import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void main() => runApp(App());

///Example App
class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.iOS:
              PageTransition(type: PageTransitionType.fade, child: this)
                  .matchingBuilder,
        }),
      ),
      home: aaaa(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/second':
            return PageTransition(
              child: const SecondPage(),
              type: PageTransitionType.theme,
              settings: settings,
              duration: const Duration(seconds: 1),
              reverseDuration: const Duration(seconds: 1),
            );
          default:
            return null;
        }
      },
    );
  }
}

/// Example page
class aaaa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Page Transition'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ElevatedButton(
              child: const Text('Fade Second Page - Default'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecondPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Left To Right Transition Second Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: const SecondPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text(
                  'Right To Left Transition Second Page Ios SwipeBack'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    isIos: true,
                    child: const SecondPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child:
                  const Text('Left To Right with Fade Transition Second Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    alignment: Alignment.topCenter,
                    child: const SecondPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Right To Left Transition Second Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: const SecondPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child:
                  const Text('Right To Left with Fade Transition Second Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: const SecondPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Top to Bottom Second Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    curve: Curves.linear,
                    type: PageTransitionType.topToBottom,
                    child: const SecondPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Bottom to Top Second Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    curve: Curves.linear,
                    type: PageTransitionType.bottomToTop,
                    child: const SecondPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Scale Transition Second Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.topCenter,
                    duration: const Duration(milliseconds: 400),
                    isIos: true,
                    child: const SecondPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Rotate Transition Second Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    curve: Curves.bounceOut,
                    type: PageTransitionType.rotate,
                    alignment: Alignment.topCenter,
                    child: const SecondPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Size Transition Second Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    alignment: Alignment.bottomCenter,
                    curve: Curves.bounceOut,
                    type: PageTransitionType.size,
                    child: const SecondPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Right to Left Joined'),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        alignment: Alignment.bottomCenter,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 600),
                        reverseDuration: const Duration(milliseconds: 600),
                        type: PageTransitionType.rightToLeftJoined,
                        child: const SecondPage(),
                        childCurrent: this));
              },
            ),
            ElevatedButton(
              child: const Text('Left to Right Joined'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 600),
                      reverseDuration: const Duration(milliseconds: 600),
                      type: PageTransitionType.leftToRightJoined,
                      child: const SecondPage(),
                      childCurrent: this),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Top to Bottom Joined'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 600),
                      reverseDuration: const Duration(milliseconds: 600),
                      type: PageTransitionType.topToBottomJoined,
                      child: const SecondPage(),
                      childCurrent: this),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Bottom to Top Joined'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 600),
                      reverseDuration: const Duration(milliseconds: 600),
                      type: PageTransitionType.bottomToTopJoined,
                      child: const SecondPage(),
                      childCurrent: this),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Right to Left Pop'),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        alignment: Alignment.bottomCenter,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 600),
                        reverseDuration: const Duration(milliseconds: 600),
                        type: PageTransitionType.rightToLeftPop,
                        child: const SecondPage(),
                        childCurrent: this));
              },
            ),
            ElevatedButton(
              child: const Text('Left to Right Pop'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 600),
                      reverseDuration: const Duration(milliseconds: 600),
                      type: PageTransitionType.leftToRightPop,
                      child: const SecondPage(),
                      childCurrent: this),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Top to Bottom Pop'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 600),
                      reverseDuration: const Duration(milliseconds: 600),
                      type: PageTransitionType.topToBottomPop,
                      child: const SecondPage(),
                      childCurrent: this),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Bottom to Top Pop'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 600),
                      reverseDuration: const Duration(milliseconds: 600),
                      type: PageTransitionType.bottomToTopPop,
                      child: const SecondPage(),
                      childCurrent: this),
                );
              },
            ),
            ElevatedButton(
              child: const Text('PushNamed With arguments'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/second",
                  arguments: "with Arguments",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

///Example second page
class SecondPage extends StatelessWidget {
  /// Page Title
  final String? title;

  /// second page constructor
  const SecondPage({Key? key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.toString()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Second Page'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    duration: const Duration(milliseconds: 300),
                    reverseDuration: const Duration(milliseconds: 300),
                    type: PageTransitionType.topToBottom,
                    child: const ThirdPage(
                      title: '',
                    ),
                  ),
                );
              },
              child: const Text('Go Third Page'),
            )
          ],
        ),
      ),
    );
  }
}

/// third page
class ThirdPage extends StatelessWidget {
  /// Page Title
  final String title;

  /// second page constructor
  const ThirdPage({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page Transition Plugin"),
      ),
      body: const Center(
        child: Text('ThirdPage Page'),
      ),
    );
  }
}
