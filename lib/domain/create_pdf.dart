import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart' as Cupertino;
import 'package:flutter/material.dart' as Material;
import 'package:kochbuch/domain/file_handler.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:kochbuch/base/Ext.dart';

import '../common.dart';
import '../data/recipe.dart';

String b =
    "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
    "Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat."
    "Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi."
    "Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat."
    "Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis."
    "At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur";

class CreatePDF {
  void createOnMobile(Recipe recipe, Cupertino.BuildContext context) async {
    final document = Document();

    // document.addPage(Page(
    //   pageFormat: PdfPageFormat.a4,
    //   clip: true,
    //   build: (Context context) {
    //     return Column
    //   }
    // ));
    document.addPage(
      MultiPage(
        header: (pdfContext) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                recipe.abteilung.getInternational(context),
              ),
            ],
          ),
        ),
        footer: (context) => Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(recipe.title),
        ),
        pageFormat: PdfPageFormat.a4,
        build: (Context pdfContext) {
          return [
            Center(
              child: Headline(recipe.title),
            ),
            MyDivider(context: context),
            BodyText(recipe.description ?? ""),
            if (recipe.image != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image(
                        MemoryImage(
                          base64Decode(recipe.image!.base64String),
                        ),
                        height: 150),
                  ),
                  MyDivider(context: context)
                ],
              ),
            if (recipe.description != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubHeadline(
                    AppLocalizations.of(context)!.rezept_beschreibung_headline,
                  ),
                  BodyText(
                    recipe.description!,
                  ),
                  MyDivider(context: context),
                ],
              ),
            SubHeadline(
              AppLocalizations.of(context)!.zutaten_page_title,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.ingredients
                      ?.map(
                        (e) => BodyText(
                          "${e.menge ?? ""} ${e.einheit.showName} ${e.zutat}",
                        ),
                      )
                      .toList() ??
                  [
                    BodyText(
                      AppLocalizations.of(context)!.keine_zutaten_info_text,
                    ),
                  ],
            ),
            MyDivider(context: context),
            SubHeadline(
              AppLocalizations.of(context)!.zubereitungsschritte_page_title,
            ),
            if (recipe.abteilung.isBackable())
              BodyText(
                "${recipe.backanweisung?.backzeit} "
                "${AppLocalizations.of(context)!.rezept_backzeit_minuten_bei_text} "
                "${recipe.backanweisung?.temperatur} "
                "${recipe.backanweisung?.temperatureinheit.showName} "
                "${AppLocalizations.of(context)!.rezept_backzeit_verb}",
              ),
            if (recipe.instructions != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.instructions
                        ?.map(
                          (instruction) => Column(
                            children: [
                              BodyText(
                                instruction.instruction,
                              ),
                              if (instruction.instructionImage != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Image(
                                      MemoryImage(
                                        base64Decode(instruction
                                            .instructionImage!.base64String),
                                      ),
                                      height: 150),
                                ),
                            ],
                          ),
                        )
                        .toList() ??
                    [
                      BodyText(
                        AppLocalizations.of(context)!
                            .keine_zubereitungsschritte_info_text,
                      ),
                    ],
              ),
            MyDivider(context: context),
            if (recipe.link != null)
              BodyText("Link zum Rezept: ${recipe.link!}")
          ];
        },
      ),
    );

    List<int> bytes = await document.save();
    FileHandler().shareRecipeAsPDF(
        title: recipe.title, id: recipe.id, recipeBytes: bytes);
  }

  TextStyle get headlineStyle => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: PdfColors.black,
      );

  TextStyle get subHeadlineStyle => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.underline,
        color: PdfColors.black,
      );

  TextStyle get bodyStyle => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: PdfColors.black,
      );

  Widget Headline(String text) => Text(text, style: headlineStyle);

  Widget SubHeadline(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: subHeadlineStyle));

  Widget BodyText(String text) => Text(text, style: bodyStyle);

  Widget MyDivider({required Cupertino.BuildContext context}) => Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Divider(
          thickness: 2,
          color: materialToPdfColor(
              Material.Theme.of(context).colorScheme.primary),
        ),
      );

  PdfColor materialToPdfColor(Material.Color color) {
    return PdfColor(color.red / 255, color.green / 255, color.blue / 255);
  }
}
