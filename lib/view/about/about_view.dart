import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../common/app_bar.dart';
import '../../utils/app_colors.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BookAppBar(
          onBackPressed: () {
            Navigator.pop(context);
          },
          title: 'About'),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.containerBackgroundColor,
          // gradient: LinearGradient(
          //   begin: Alignment.centerLeft, // Start from the bottom-left corner
          //   end: Alignment.centerRight,     // End at the top-right corner
          //   colors: [
          //     AppColors.fontColorWhite.withOpacity(0.5),  // Color from the bottom-left side (light yellow)
          //     AppColors.colorPrimary.withOpacity(0.8),   // Color from the bottom-left side (green)
          //   ],
          // ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                  RichText(
                  text: TextSpan(
                      text: 'Book Home\n\n',
                      style: const TextStyle(
                          color: AppColors.fontColorWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      children: [
                        const TextSpan(
                          text:
                              'ත්‍රාසය,භීතිය,කුතුහලය සහ විනෝදය සමඟින් නව කතන්දර පොත් රාශියක්. නව කතා,කෙටි කතා, ආදී නොයෙකුත් ආකාරයේ කතන්දර පොත්'
                              'සමග එක් වූ දුරකථන යෙදවුම. '
                              'උබත් පොත් කියවීමට කැමැත්තක් දක්වනවා ද ?'
                              'සාම්ප්‍රදායික පොත් කියවීමේ රටාවෙන් බැහැරව, නවමු තාක්ෂණය ඔස්සේ සිත්ගන්නාසුළු, '
                              'උද්යෝගිමත් පොත් කියවීමේ අත්දැකීමක් සමගින් ඔබට නිසැක විනෝදයක් '
                              'ලබාගැනීමට සැකසූ Book Home.\n\n',
                          style: TextStyle(
                              color: AppColors.fontColorWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        const TextSpan(
                            text:
                                "1. පළපුරුදු වෘත්තීමය රචක මණ්ඩලයක් විසින් අන්තර්ගතය සැකසීම හා අධීක්ෂණය සිදු කරයි.\n\n"
                                "2. කියවීමට  පහසු හා සරල අයුරින් දුරකථන යෙදවුම නිර්මාණය කර ඇත.\n\n"
                                "3. සාම්ප්‍රධායික පොත් කියවීමේ රටාවට අඩු උනන්දුවක් දක්වන ඔබ සඳහා ඉතා ආකර්ෂණීය ලෙස"
                                    "පෙළගස්වා ඇත.\n\n"
                                "4. සෑම සතියකම නව කොටස් එකතු කිරීම සිදු කරයි.\n\n"
                                "5. Book Home යෙදවුම තුලින් ඔබට  ඔබගේ මානසික පීඩනය දුරු කොට විනෝදය ලබා ගැනීමට "
                                    "අවශ්‍ය මඟ පෙන්වීම සිදු කරයි.\n\n",
                            style: TextStyle(
                                color: AppColors.fontColorWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                        const TextSpan(
                          text:
                              'ඔබ සියලු දෙනාගේ ම රසාස්වාදය වැඩි දියුණු කිරීම'
                              'අපගේ අරමුණයි. වැඩිදුර විස්තර, '
                              'සහය හා විමසීම් සඳහා',
                          style: TextStyle(
                              color: AppColors.fontColorWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        const WidgetSpan(
                            child: SizedBox(
                              width: 10,
                            )),
                        TextSpan(
                            text: 'info@bookhome.lk',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {

                              },
                            style: const TextStyle(
                                color: AppColors.fontColorWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            children: const [
                              TextSpan(
                                text: ' හරහා සම්බන්ධ වන්න.',
                                style: TextStyle(
                                    color: AppColors.fontColorWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
