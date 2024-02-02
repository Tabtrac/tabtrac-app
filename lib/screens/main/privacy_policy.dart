import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';
import '../../helpers/app_fonts.dart';
import '../../helpers/functions.dart';
import '../../providers/providers.dart';

class PrivacyPolicy extends ConsumerStatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends ConsumerState<PrivacyPolicy> {
  @override
  void initState() {
    changeBottomBarColor(ref.read(isDarkModeProvider));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final transH = AppLocalizations.of(context)!;
    Color? bodyColor = Theme.of(context).textTheme.bodyMedium!.color;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: FittedBox(
          child: Text(
            transH.privacyPolicy.capitalizeAll(),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontFamily: AppFonts.actionFont,
            ),
          ),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        padding:  EdgeInsets.symmetric(horizontal: isTablet() ? 40.w : 20),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: width * .01 + 12,
                    color: bodyColor,
                    fontFamily: AppFonts.primaryFont2,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "${transH.effectiveDate}: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: bodyColor,
                        fontSize: width * .01 + 12,
                      ),
                    ),
                    const TextSpan(text: '2023-11-30'),
                  ],
                ),
              ),
              SizedBox(height: height * .03),
              // Introduction
              introductionSection(width, bodyColor, transH, height),
              // Information We Collect
              informationWeCollect(height, width, bodyColor, transH),
              // How we use your information
              howWeUseYourInformation(height, width, bodyColor, transH),
              // How We Share Your Information
              howWeShareYourInformation(height, width, bodyColor, transH),
              // Your Choices
              yourChoices(height, width, bodyColor, transH),
              // Data Security
              dataSecurity(height, width, bodyColor, transH),
              // Changes to this Privacy Policy
              changesToThisPrivacypolicy(height, width, bodyColor, transH),
              // Contact Us
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: height * .04),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: width * .01 + 12,
                        color: bodyColor,
                        fontFamily: AppFonts.primaryFont2,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "8. ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: bodyColor,
                            fontSize: width * .01 + 12,
                          ),
                        ),
                        TextSpan(
                          text: "${transH.contactUs}: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: bodyColor,
                            fontSize: width * .01 + 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * .01),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: width * .01 + 12,
                        color: bodyColor,
                        fontFamily: AppFonts.primaryFont2,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "${transH.contactUsDes} ",
                          style: TextStyle(
                            color: bodyColor,
                            fontSize: width * .01 + 10,
                          ),
                        ),
                        TextSpan(
                          text: 'tabtrac@gmail.com',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchEmail(
                                  'tabtrac@gmail.com', 'Contact Us', '');
                            },
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Column changesToThisPrivacypolicy(
      double height, double width, Color? bodyColor, AppLocalizations transH) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: height * .04),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: width * .01 + 12,
              color: bodyColor,
              fontFamily: AppFonts.primaryFont2,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "7. ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
              TextSpan(
                text: "${transH.changesToThisPrivacyPolicy}: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
        Text(
          transH.changesToThisPrivacyPolicyDes,
          style: TextStyle(
            fontSize: width * .01 + 12,
            color: bodyColor,
            fontFamily: AppFonts.primaryFont2,
          ),
        ),
      ],
    );
  }

  Column dataSecurity(
      double height, double width, Color? bodyColor, AppLocalizations transH) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: height * .04),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: width * .01 + 12,
              color: bodyColor,
              fontFamily: AppFonts.primaryFont2,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "6. ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
              TextSpan(
                text: "${transH.dataSecurity}: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
        Text(
          transH.dataSecurityDes,
          style: TextStyle(
            fontSize: width * .01 + 12,
            color: bodyColor,
            fontFamily: AppFonts.primaryFont2,
          ),
        ),
        SizedBox(height: height * .01),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              // Encryption
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.encryption,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.encryptionDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Access controls
              SizedBox(height: height * .01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.accessControls,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.accessControlsDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Data Storage
              SizedBox(height: height * .01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.dataStorage,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.dataStorageDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
      ],
    );
  }

  Column yourChoices(
      double height, double width, Color? bodyColor, AppLocalizations transH) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: height * .04),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: width * .01 + 12,
              color: bodyColor,
              fontFamily: AppFonts.primaryFont2,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "5. ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
              TextSpan(
                text: "${transH.yourChoices}: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
        Text(
          transH.yourChoicesDes,
          style: TextStyle(
            fontSize: width * .01 + 12,
            color: bodyColor,
            fontFamily: AppFonts.primaryFont2,
          ),
        ),
        SizedBox(height: height * .01),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              // Review your settings
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.reviewYourSettings,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.reviewYourSettingsDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Delete your information
              SizedBox(height: height * .01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.deleteYourInformation,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.deleteYourInformationDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
      ],
    );
  }

  Column howWeShareYourInformation(
      double height, double width, Color? bodyColor, AppLocalizations transH) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: height * .04),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: width * .01 + 12,
              color: bodyColor,
              fontFamily: AppFonts.primaryFont2,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "4. ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
              TextSpan(
                text: "${transH.howWeShareYourInformation}: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
        Text(
          transH.howWeShareYourInformationDes,
          style: TextStyle(
            fontSize: width * .01 + 12,
            color: bodyColor,
            fontFamily: AppFonts.primaryFont2,
          ),
        ),
        SizedBox(height: height * .01),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              // With your consent
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.withYourConsent,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.withYourConsentDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // To comply with law
              SizedBox(height: height * .01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.toComplyWithLaw,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.toComplyWithLawDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // To protect our rights
              SizedBox(height: height * .01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.toProtectOurRights,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.toProtectOurRightsDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
      ],
    );
  }

  Column howWeUseYourInformation(
      double height, double width, Color? bodyColor, AppLocalizations transH) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: height * .04),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: width * .01 + 12,
              color: bodyColor,
              fontFamily: AppFonts.primaryFont2,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "3. ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
              TextSpan(
                text: "${transH.howWeUseYourInformation}: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
        Text(
          transH.howWeUseYourInformationDes,
          style: TextStyle(
            fontSize: width * .01 + 12,
            color: bodyColor,
            fontFamily: AppFonts.primaryFont2,
          ),
        ),
        SizedBox(height: height * .01),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              // Track your debts and owed money
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.trackYourDebtsAndOwedMoney,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.trackYourDebtsAndOwedMoneyDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Send you reminders
              SizedBox(height: height * .01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.sendYouReminders,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.sendYouRemindersDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Contact You
              SizedBox(height: height * .01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.contactYou,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.contactYouDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
        Text(
          transH.howWeUseYourInformationDesTwo,
          style: TextStyle(
            fontSize: width * .01 + 12,
            color: bodyColor,
            fontFamily: AppFonts.primaryFont2,
          ),
        ),
        SizedBox(height: height * .01),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              // Improve our app
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.improveOurApp,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.improveOurAppDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Protect Our Rights
              SizedBox(height: height * .01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.protectOurRights,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.protectOurRightsDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column informationWeCollect(
      double height, double width, Color? bodyColor, AppLocalizations transH) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: height * .04),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: width * .01 + 12,
              color: bodyColor,
              fontFamily: AppFonts.primaryFont2,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "2. ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
              TextSpan(
                text: "${transH.informationWeCollect}: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
        Text(
          transH.informationWeCollectDes,
          style: TextStyle(
            fontSize: width * .01 + 12,
            color: bodyColor,
            fontFamily: AppFonts.primaryFont2,
          ),
        ),
        SizedBox(height: height * .01),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              // Personal information
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.personalInformation,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.personalInformationDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Financial Information
              SizedBox(height: height * .01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: width * .01 + 12,
                          color: bodyColor,
                          fontFamily: AppFonts.primaryFont2,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: transH.financialInformation,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bodyColor,
                              fontSize: width * .01 + 11,
                            ),
                          ),
                          TextSpan(
                            text: transH.financialInformationDes,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: width * .01 + 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
        Text(
          transH.informationWeCollectDesTwo,
          style: TextStyle(
            fontSize: width * .01 + 12,
            color: bodyColor,
            fontFamily: AppFonts.primaryFont2,
          ),
        ),
      ],
    );
  }

  Column introductionSection(
      double width, Color? bodyColor, AppLocalizations transH, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: width * .01 + 12,
              color: bodyColor,
              fontFamily: AppFonts.primaryFont2,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "1. ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
              TextSpan(
                text: "${transH.introduction}: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bodyColor,
                  fontSize: width * .01 + 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * .01),
        Text(
          transH.introductionMessage,
          style: TextStyle(
            fontSize: width * .01 + 12,
            color: bodyColor,
            fontFamily: AppFonts.primaryFont2,
          ),
        ),
      ],
    );
  }
}
