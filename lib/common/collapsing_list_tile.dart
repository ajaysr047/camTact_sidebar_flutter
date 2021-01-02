import 'package:flutter/material.dart';
import 'package:side_bar/common/theme.dart';

class CollapsingListTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final isSelected;
  final Function onTap;

  final AnimationController animationController;
  CollapsingListTile(
      {@required this.title,
      @required this.icon,
      @required this.animationController,
      this.isSelected = false,
      this.onTap});
  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
}

class _CollapsingListTileState extends State<CollapsingListTile> {
  Animation<double> _widthAnimation, _sizedBoxAnimation;
  final double maxWidth = 220;
  final double minWidth = 60;
  @override
  void initState() {
    super.initState();
    _widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(widget.animationController);
    _sizedBoxAnimation =
        Tween<double>(begin: 10.0, end: 0).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: widget.isSelected
                ? Colors.transparent.withOpacity(0.3)
                : Colors.transparent),
        width: _widthAnimation.value,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              widget.icon,
              color: widget.isSelected ? selectedColor : Colors.white30,
              size: 35,
            ),
            SizedBox(width: _sizedBoxAnimation.value),
            (_widthAnimation.value >= 200)
                ? Text(widget.title,
                    style: widget.isSelected
                        ? listTitleSelectedTextStyle
                        : listTitleDefaultTextStyle)
                : Container()
          ],
        ),
      ),
    );
  }
}
