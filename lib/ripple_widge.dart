import 'package:flutter/material.dart';

class RippleWidget extends StatefulWidget {
  _RippleWidgetState state = _RippleWidgetState();
  @override
  _RippleWidgetState createState() => state;

  void start() {
    state.startAnimation();
  }

  void stop() {
    state.stopAnimation();
  }
}

class _RippleWidgetState extends State<RippleWidget> with TickerProviderStateMixin,WidgetsBindingObserver {
  AnimationController _animationController, _animationController1, _animationController2;
  Animation<double> _animation, _animation1, _animation2;
  List<Animation<double>> _animationList = List();

  AnimatedRipple animatedRipple;

  void stopAnimation() {
    if (animatedRipple.stopped == true) {
      return;
    }

    animatedRipple.stopped = true;
    _animationController.stop();
    _animationController1.stop();
    _animationController2.stop();
    _animationController.reset();
    _animationController1.reset();
    _animationController2.reset();
  }

  void startAnimation() {
    if (animatedRipple.stopped == false) {
      return;
    }
    animatedRipple.stopped = false;
    _animationController.forward();

    Future.delayed(Duration(milliseconds: 500), () {
      _animationController1.forward();
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      _animationController2.forward();
    });
  }


  @override
  void initState() {
    super.initState();
    print("initState");
    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.linear);
    _animationController.addStatusListener((status) {
      if (animatedRipple.stopped) {
        return;
      }
      if (status == AnimationStatus.completed) {
        print("_animation completed");
        _animationController.reset();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    _animationController1 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _animation1 = CurvedAnimation(parent: _animationController1, curve: Curves.linear);
    _animationController1.addStatusListener((status) {
      if (animatedRipple.stopped) {
        return;
      }
      if (status == AnimationStatus.completed) {
        print("_animation 1 completed");
        _animationController1.reset();
      } else if (status == AnimationStatus.dismissed) {
        _animationController1.forward();
      }
    });

    _animationController2 = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _animation2 = CurvedAnimation(parent: _animationController2, curve: Curves.linear);
    _animationController2.addStatusListener((status) {
      if (animatedRipple.stopped) {
        return;
      }
      if (status == AnimationStatus.completed) {
        print("_animation 2 completed");
        _animationController2.reset();
      } else if (status == AnimationStatus.dismissed) {
        _animationController2.forward();
      }
    });
    _animationList.add(_animation);
    _animationList.add(_animation1);
    _animationList.add(_animation2);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState, state: ${state.index}");
    switch(state.index) {
      case 2:
        if (animatedRipple.stopped == false) {
          _animationController.stop();
          _animationController1.stop();
          _animationController2.stop();
        }
        break;
      case 0:
        if (animatedRipple.stopped == false) {
          _animationController.forward();
          _animationController1.forward();
          _animationController2.forward();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    animatedRipple = AnimatedRipple(animation: _animation, animationList: _animationList,);
    return animatedRipple;
  }
}

class AnimatedRipple extends AnimatedWidget {
  final Tween<double> _opacityTween = Tween(begin: 1, end: 0);
  final Tween<double> _marginTween = Tween(begin: 200, end: 400);

  bool stopped = true;
  List<Animation<double>> _list;

  AnimatedRipple({Key key, Animation<double> animation, List<Animation<double>> animationList}): super(key: key, listenable: animation) {
   _list = animationList;
  }

  @override
  Widget build(BuildContext context) {

    //print("build。。。。。。");
    var oneBox = Container(
      //color:Colors.green,
      height:_marginTween.evaluate(_list[0]),
      width: _marginTween.evaluate(_list[0]),
      child: ClipOval(
        child: Opacity(
          opacity: _opacityTween.evaluate(_list[0]),
          child: Container(
            color: Color.fromARGB(255, 195, 195, 195),
          ),
        ),
      ),
    );
    var twoBox = Container(
      //color:Colors.green,
      height:_marginTween.evaluate(_list[1]),
      width: _marginTween.evaluate(_list[1]),
      child: ClipOval(
        child: Opacity(
          opacity: _opacityTween.evaluate(_list[1]),
          child: Container(
            color: Color.fromARGB(255, 195, 195, 195),
          ),
        ),
      ),
    );
    var threeBox = Container(
      //color:Colors.green,
      height:_marginTween.evaluate(_list[2]),
      width: _marginTween.evaluate(_list[2]),
      child: ClipOval(
        child: Opacity(
          opacity: _opacityTween.evaluate(_list[2]),
          child: Container(
            color: Color.fromARGB(255, 195, 195, 195),
          ),
        ),
      ),
    );

    List<Widget> widgeList;
    if (!stopped) {
      widgeList = [threeBox, twoBox, oneBox, Image.asset("images/bluetooth.png", height:200, width: 200)];
    } else {
      widgeList = [Image.asset("images/bluetooth.png", height:200, width: 200)];
    }

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: widgeList,
      ),
    );
  }
}