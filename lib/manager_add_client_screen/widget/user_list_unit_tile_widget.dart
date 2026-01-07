import 'package:algarve_house_hunters_system/manager_add_client_screen/controller/manager_add_client_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class UserListUnitTileWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  final UserState state;
  final bool isImported;
  const UserListUnitTileWidget({
    super.key,
    required this.userData,
    required this.state,
    this.isImported = false,
  });

  @override
  State<UserListUnitTileWidget> createState() => _UserListUnitTileWidgetState();
}

class _UserListUnitTileWidgetState extends State<UserListUnitTileWidget> {
  // NOTE Method for generating the random color and initials from the full name
  (({String first, String second}), ({Color bgColor, Color textColor}))
      getLettersAndColors(String fullName) {
    String cleaned = fullName.trim().replaceAll(" ", "");
    String first = cleaned.isNotEmpty ? cleaned[0].toUpperCase() : "";
    String second = cleaned.length > 1 ? cleaned[1].toUpperCase() : "";

    // Generate soft background color
    final random = Random();
    final bgColor = Color.fromARGB(
      255,
      200 + random.nextInt(56), // Light range 200–255
      200 + random.nextInt(56),
      200 + random.nextInt(56),
    );

    // Choose text color based on luminance
    final textColor =
        bgColor.computeLuminance() > 0.6 ? Colors.black : Colors.white;

    return (
      (first: first, second: second),
      (bgColor: bgColor, textColor: textColor)
    );
  }

  // NOTE Method for getting the circular widget
  Widget getInitialWidget(String fullName) {
    final (letters, colors) = getLettersAndColors(fullName);
    return CircleAvatar(
      backgroundColor: colors.bgColor,
      child: Text(
        "${letters.first} ${letters.second}",
        style: ThemeController.normalTextStyle(color: colors.textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // NOTE Name initial Holder
          getInitialWidget(
            widget.userData["client_name"],
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userData["client_name"],
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.userData["client_email_address"],
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (widget.isImported)
                const SizedBox(
                  height: 2,
                ),
              if (widget.isImported)
                Text(
                  "Completed",
                  style: ThemeController.normalTextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                  ),
                ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: ManagerAddClientScreenController.getUseStateTextColor(
                  widget.state,
                ),
              ),
              color: ManagerAddClientScreenController.getUseStateBgColor(
                widget.state,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              ManagerAddClientScreenController.getUserStateLabel(widget.state),
              style: ThemeController.normalTextStyle(
                color: ManagerAddClientScreenController.getUseStateTextColor(
                  widget.state,
                ),
                size: 10,
              ),
            ),
          )
        ],
      ),
    );
  }
}
