import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CollectionNavbar extends StatefulWidget {
  const CollectionNavbar(
      {Key? key,
      required this.galleryButtonFunction,
      required this.cameraButtonFunction})
      : super(key: key);

  final VoidCallback galleryButtonFunction;
  final VoidCallback cameraButtonFunction;

  @override
  _CollectionNavbarState createState() => _CollectionNavbarState();
}

class _CollectionNavbarState extends State<CollectionNavbar> {
  /// Toggles between play and pause animation states
  void _openNav() =>
      _open!.change(!_open!.value); //_open!.change(!_open!.value);

  void _cameraButtonClicked() {
    widget.cameraButtonFunction();
  }

  void _galleryButtonClicked() {
    widget.galleryButtonFunction();
  }

  void _homeButtonClicked() {
    _home!.fire();
  }

  void _downloadButtonClicked() {
    _download!.fire();
  }

  SMIBool? _open;
  SMITrigger? _home;
  SMITrigger? _download;

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'state_machine');
    artboard.addController(controller!);
    _open = controller.findInput<bool>('open') as SMIBool;
    _home = controller.findInput<bool>('home') as SMITrigger;
    _download = controller.findInput<bool>('download') as SMITrigger;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: GestureDetector(
          onTapUp: onTapListener,
          child: SizedBox(
            height: size.height * 0.1,
            child: RiveAnimation.asset(
              'assets/lingua_eidetic.riv',
              fit: BoxFit.cover,
              onInit: _onRiveInit,
              artboard: 'Collection Navigation Bar',
              antialiasing: true,
            ),
          )),
    );
  }

  void onTapListener(TapUpDetails details) {
    Size size = MediaQuery.of(context).size;
    final double x = details.localPosition.dx;
    if (x <= size.width * 0.564 && x >= size.width * 0.44)
      _openNav();
    else if (x <= size.width * 0.72 && x >= size.width * 0.575)
      _galleryButtonClicked();
    else if (x <= size.width * 0.43 && x >= size.width * 0.29)
      _cameraButtonClicked();
    else if (x >= size.width * 0.85)
      _downloadButtonClicked();
    else if (x <= size.width * 0.15) _homeButtonClicked();
  }
}
