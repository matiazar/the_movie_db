import 'package:flutter/cupertino.dart';

class NavigationModel with ChangeNotifier {
  int _index = 0;
  // PageController _pageController = new PageController();

  int get index => _index;

  set index(int value) {
    _index = value;

    // _pageController.animateToPage(valor, duration: Duration(milliseconds: 250), curve: Curves.easeOut );

    notifyListeners();
  }

  // PageController get pageController => this._pageController;

}
