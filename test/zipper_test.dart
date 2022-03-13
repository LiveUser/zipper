import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:zipper/zipper.dart' as Zipper;

void main() {
  test("Put everything into a single file", ()async{
    String sourceFolder = "C:/Users/valen_z1p5ic1/Pictures/UbisoftConnect";
    String outputFile = "C:/Users/valen_z1p5ic1/Downloads/file_system.json";
    await Zipper.zip(
      outputFile: File(outputFile), 
      sourceDirectory: Directory(sourceFolder),
    );
  });
  test("Extract the file and save it back conserving the previous file/folder structure", ()async{
    String sourceFilePath = "C:/Users/valen_z1p5ic1/Downloads/file_system.json";
    String outputFolderPath = "C:/Users/valen_z1p5ic1/Downloads";
    await Zipper.unzip(
      sourceFile: File(sourceFilePath), 
      outputDirectory: Directory(outputFolderPath),
      overWrite: true,
    );
  });
}