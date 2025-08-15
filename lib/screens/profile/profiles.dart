import 'package:expire_check/screens/dashboard/dashboard_controller/controller.dart';
import 'package:expire_check/screens/profile/controller/notifiction_controller.dart';
import 'package:expire_check/screens/profile/loginsignup/signupscreen/signup_controller.dart';
import 'package:expire_check/screens/profile/widgets/accounts_card.dart';
import 'package:expire_check/screens/profile/widgets/card.dart';
import 'package:expire_check/screens/profile/widgets/settings_card.dart';
import 'package:expire_check/screens/profile/widgets/signout_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DashboardController controller = Get.find<DashboardController>();
  final SignUpController signUpController = Get.find<SignUpController>();
  final NotificationController notificationController =
      Get.find<NotificationController>();

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// HEADER
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.only(top: 50, left: 10),
            child: Row(
              children: [
                CircleAvatar(radius: 30, child: Icon(Icons.person)),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      signUpController.userName.value,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      signUpController.email.value,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// BODY SCROLL
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// GRID SECTION
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 8,
                      children: [
                        ProfileCard(
                          icon: Icons.people,
                          color: Colors.blue[100]!,
                          iconColor: Colors.blue[700]!,
                          number: controller.totalEmployees.toString(),
                          label: 'Total Employees',
                        ),
                        ProfileCard(
                          icon: Icons.school,
                          color: Colors.purple[100]!,
                          iconColor: Colors.purple[700]!,
                          number: controller.totalTrainings.toString(),
                          label: 'Total Trainings',
                        ),
                      ],
                    ),
                  ),

                  /// ACCOUNTS SECTION
                  _buildSectionTitle("Accounts"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        AccountsCard(
                          icon: Icons.person,
                          title: signUpController.userName.value,
                          subtitle: "Admin",
                          tilecolor: Colors.white,
                        ),
                        SizedBox(height: 8),
                        AccountsCard(
                          icon: Icons.mail,
                          title: signUpController.email.value,
                          subtitle: "Email",
                          tilecolor: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  /// SETTINGS SECTION
                  _buildSectionTitle("Settings"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SettingsCard(
                          icon: Icons.notifications,
                          label: "Enable Notifications",
                          type: SettingsCardType.toggle,
                          initialValue:
                              notificationController.isNotificationOn.value,
                          onToggle: (value) {
                            notificationController.toggleNotification(value);
                          },
                        ),
                        SizedBox(height: 8),
                        SettingsCard(
                          icon: Icons.lock,
                          label: "Notify before (4 days)",
                          type: SettingsCardType.textWithIcon,
                          text: "On",
                          trailingIcon: Icons.arrow_forward_ios,
                        ),
                      ],
                    ),
                  ),

                  /// LOGOUT SECTION
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: SignOutCard(
                      label: "Sign out",
                      icon: Icons.logout,
                      onSignOut: () async {
                        await signUpController.signOut();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
