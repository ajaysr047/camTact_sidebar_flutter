import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_bar/common/NavigationBloc.dart';
import 'package:side_bar/common/collapsing_list_tile.dart';
import 'package:side_bar/model/navigation_model.dart';
import 'package:side_bar/common/theme.dart';

class CollapsibleNavigationDrawer extends StatefulWidget {
  @override
  _CollapsibleNavigationDrawerState createState() => _CollapsibleNavigationDrawerState();
}

class _CollapsibleNavigationDrawerState extends State<CollapsibleNavigationDrawer> with SingleTickerProviderStateMixin {

  double maxWidth = 220;
  double minWidth = 60;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = 0;

  @override
  void initState()
  {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth).animate(_animationController);
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: _animationController, builder: (context, widget) => getWidget(context, widget));
  }

  getWidget(BuildContext context, Widget widget) {
    return Container(
      width: widthAnimation.value,
      color: drawerBackgroundColor,
      child: Column(
        children: <Widget>[
          SizedBox(height: 50.0,),
          CollapsingListTile(
              title: 'CamTact',
              icon: Icons.people,
              animationController: _animationController
          ),
        Divider(color: Colors.grey, height: 25.0,),
          Expanded(
            child:ListView.separated(
              separatorBuilder: (context, counter){
                return Divider(height: 12.0,);
              },
              itemBuilder: (context, counter){
              return CollapsingListTile(
                onTap: (){
                    setState(() {
                        currentSelectedIndex = counter;
                        BlocProvider.of<NavigationBloc>(context).add(navigationItems[counter].eventName);
                    });
                },
                  isSelected: currentSelectedIndex == counter,
                  title: navigationItems[counter].title,
                  icon: navigationItems[counter].icon,
                  animationController: _animationController
              );
            },
              itemCount: navigationItems.length,),
          ),
          InkWell(
              onTap: (){
                setState(() {
                  isCollapsed = !isCollapsed;
                  isCollapsed ? _animationController.forward() : _animationController.reverse();
                });
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.close_menu, color: Colors.white, size: 50,
              progress: _animationController,)),
          SizedBox(height: 50.0,),
        ],
      ),
    );
  }
}
