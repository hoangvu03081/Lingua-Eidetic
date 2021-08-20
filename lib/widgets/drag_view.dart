import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DragBean {
  DragBean({
    this.index = 0,
    this.selected = false,
  });

  int index;
  bool selected;
}

class DragView extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final List<DragBean> data;
  final double gap;
  final int itemRowCount;

  DragView({
    Key? key,
    this.gap = 16,
    required this.data,
    required this.itemBuilder,
    required this.itemRowCount,
  }) : super(key: key);

  @override
  _DragViewState createState() => _DragViewState();
}

class _DragViewState extends State<DragView> with TickerProviderStateMixin {
  bool _initialized = false;
  double _itemWidth = 0;
  List<Rect> _positions = [];
  List<DragBean> _cacheData = [];
  late AnimationController _controller;
  late AnimationController _zoomController;
  late AnimationController _floatController;
  OverlayEntry? _overlayEntry;
  double _floatLeft = 0;
  double _floatTop = 0;
  int _dragIndex = 0;
  DragBean? _dragBean;
  Offset _downLocalPos = Offset.zero;
  double _downLeft = 0;
  double _downTop = 0;
  List<int> _selectedItems = [];

  final defaultTextStyle = GoogleFonts.montserrat(
    textStyle: TextStyle(fontWeight: FontWeight.w700),
  );

  void _addOverlay(BuildContext context, Widget overlay) {
    OverlayState? overlayState = Overlay.of(context);
    if (overlayState == null) return;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (BuildContext context) {
        return Positioned(
            left: _floatLeft - widget.gap * _zoomController.value,
            top: _floatTop - widget.gap * _zoomController.value,
            child: Material(
              borderRadius: BorderRadius.circular(22),
              elevation: 8,
              child: Container(
                width: _itemWidth + widget.gap * _zoomController.value * 2,
                height: _itemWidth + widget.gap * _zoomController.value * 2,
                child: overlay,
              ),
            ));
      });
      overlayState.insert(_overlayEntry!);
    } else {
      _overlayEntry?.markNeedsBuild();
    }
    _zoomController.reset();
    _zoomController.forward();
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  int _getDragIndex(Offset offset) {
    for (int i = 0; i < widget.data.length; i++) {
      if (_positions[i].contains(offset)) {
        return i;
      }
    }
    return -1;
  }

  void _clearAll() {
    _removeOverlay();
    _cacheData.clear();
    for (int i = 0; i < widget.data.length; i++) {
      widget.data[i].index = i;
      widget.data[i].selected = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _zoomController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _floatController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    _controller.addListener(() {
      setState(() {});
    });
    _zoomController.addListener(() {
      _updateOverlay();
    });
    _floatController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _clearAll();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _zoomController.dispose();
  }

  void _init(BuildContext context, double width) {
    final gap = widget.gap;
    final itemRowCount = widget.itemRowCount;
    _itemWidth =
        (width - gap * (itemRowCount - 1)) / itemRowCount; //(width - gap) / 2;
    _positions.clear();

    for (int i = 0; i < widget.data.length; i++) {
      double left = (_itemWidth + gap) * (i % itemRowCount);
      double top = (_itemWidth + gap) * (i ~/ itemRowCount);
      _positions.add(Rect.fromLTWH(left, top, _itemWidth, _itemWidth));
    }
    _initialized = true;
  }

  void _initIndex() {
    for (int i = 0; i < widget.data.length; i++) {
      widget.data[i].index = i;
    }
    _cacheData.clear();
    _cacheData.addAll(widget.data);
  }

  Widget childWrapper(int index) {
    bool isSelected = _selectedItems.contains(index);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? Colors.yellow : Colors.red,
          width: 2,
        ),
      ),
      child: widget.itemBuilder(context, index),
    );
  }

  Widget _buildChild(BuildContext context) {
    List<Widget> children = [];
    if (_cacheData.isEmpty) {
      for (int i = 0; i < widget.data.length; i++) {
        children.add(
          Positioned.fromRect(
            rect: _positions[i],
            child: childWrapper(i),
          ),
        );
      }
    } else {
      for (int i = 0; i < widget.data.length; i++) {
        int curIndex = widget.data[i].index;
        int lastIndex = _cacheData[i].index;
        double left = _positions[curIndex].left +
            (_positions[lastIndex].left - _positions[curIndex].left) *
                _controller.value;
        double top = _positions[curIndex].top +
            (_positions[lastIndex].top - _positions[curIndex].top) *
                _controller.value;
        children.add(Positioned(
          left: left,
          top: top,
          width: _itemWidth,
          height: _itemWidth,
          child: Offstage(
            offstage: widget.data[i].selected == true,
            child: childWrapper(i),
          ),
        ));
      }
    }
    children.add(Positioned(
      top: (_itemWidth + widget.gap) *
          (widget.data.length ~/ widget.itemRowCount),
      left: (_itemWidth + widget.gap) *
          (widget.data.length % widget.itemRowCount),
      child: DottedBorder(
        color: Color(0xFFDDDDDD),
        strokeWidth: 3,
        borderType: BorderType.RRect,
        radius: Radius.circular(22),
        dashPattern: [12, 12],
        child: GestureDetector(
          onTap: () {},
          child: Container(
            height: _itemWidth,
            width: _itemWidth,
            child: Center(
              child: Text(
                '+ Add',
                style: defaultTextStyle.copyWith(fontSize: 22),
              ),
            ),
          ),
        ),
      ),
    ));
    return Stack(children: children);
  }

  int _checkIndexTop(Rect other) {
    int index = -1;
    double? area;
    for (int i = 0; (i < 3 && i < widget.data.length); i++) {
      Rect rect = _positions[i];
      Rect over = rect.intersect(other);
      double _area = _getRectArea(over);
      if (area == null || _area <= area) {
        area = _area;
        index = i;
      }
    }
    return index;
  }

  int _checkIndexBottom(Rect other) {
    int tagIndex = -1;
    double? area;
    for (int i = 0; (i < 3 && i < widget.data.length); i++) {
      Rect _rect = _positions[i];
      Rect over = _rect.intersect(other);
      double _area = _getRectArea(over);
      if (area == null || _area <= area) {
        area = _area;
        tagIndex = i;
      }
    }
    if (tagIndex != -1) {
      for (int i = widget.data.length - 1; i >= 0; i--) {
        if (((i + 1) / widget.itemRowCount).ceil() >=
                (((_dragIndex + 1) / widget.itemRowCount).ceil()) &&
            (i % widget.itemRowCount == tagIndex)) {
          return i;
        }
      }
    }
    return -1;
  }

  int _getNextIndex(Rect curRect, Rect oriRect) {
    int _itemCount = widget.data.length;
    if (_itemCount == 1) return 0;
    bool outside = true;
    for (int i = 0; i < _itemCount; i++) {
      Rect rect = _positions[i];
      bool overlaps = rect.overlaps(curRect);
      if (overlaps) {
        outside = false;
        Rect over = rect.intersect(curRect);
        Rect ori = oriRect.intersect(curRect);
        if (_getRectArea(over) > _itemWidth * _itemWidth / 2 ||
            _getRectArea(over) > _getRectArea(ori)) {
          return i;
        }
      }
    }
    int index = -1;

    if (outside) {
      int row = ((widget.data.length + 1) / 2).ceil();

      if (curRect.bottom < 0) {
        index = _checkIndexTop(curRect);
      } else if (curRect.top > _itemWidth) {
        index = _checkIndexBottom(curRect);
      }
    }

    return index;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (!_initialized) {
      _init(context, width);
    }
    int row = ((widget.data.length + 1) / 2).ceil();
    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        if (_selectedItems.isNotEmpty) {
          int index = _getDragIndex(details.localPosition);
          setState(() {
            if (_selectedItems.contains(index))
              _selectedItems.remove(index);
            else
              _selectedItems.add(index);
          });
        }
      },
      onLongPressStart: (LongPressStartDetails details) {
        _dragIndex = _getDragIndex(details.localPosition);
        if (_dragIndex == -1) return;
        if (_selectedItems.contains(_dragIndex)) {
          setState(() {
            _selectedItems.remove(_dragIndex);
          });
        } else {
          setState(() {
            _selectedItems.add(_dragIndex);
          });
        }
        _initIndex();
        widget.data[_dragIndex].selected = true;
        _dragBean = widget.data[_dragIndex];
        _downLocalPos = details.localPosition;
        _downLeft = _positions[_dragIndex].left;
        _downTop = _positions[_dragIndex].top;
        _floatLeft = _downLeft;
        _floatTop =
            _downTop + details.globalPosition.dy - details.localPosition.dy;
        Widget overlay = childWrapper(_dragIndex);
        _addOverlay(context, overlay);
        setState(() {});
      },
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
        if (_dragIndex == -1) return;
        _floatLeft = _downLeft + details.localPosition.dx - _downLocalPos.dx;
        double statusBarHeight =
            details.globalPosition.dy - details.localPosition.dy;
        _floatTop = _downTop +
            details.localPosition.dy -
            _downLocalPos.dy +
            statusBarHeight;
        _updateOverlay();

        double left = _floatLeft;
        double top = _floatTop - statusBarHeight;
        Rect cRect = Rect.fromLTWH(left, top, _itemWidth, _itemWidth);
        int index = _getNextIndex(cRect, _positions[_dragIndex]);
        if (index != -1 && _dragIndex != index) {
          _initIndex();
          setState(() {
            _selectedItems.remove(_dragIndex);
            _selectedItems.add(index);
          });
          _dragIndex = index;
          widget.data.remove(_dragBean);
          widget.data.insert(_dragIndex, _dragBean!);
          _controller.reset();
          _controller.forward();
        }
        _updateOverlay();
      },
      onLongPressUp: () {
        _floatController.reset();
        _floatController.forward();
      },
      child: Container(
        width: width,
        height: row * (_itemWidth + widget.gap),
        child: _buildChild(context),
      ),
    );
  }

  double _getRectArea(Rect rect) {
    return rect.width * rect.height;
  }
}
