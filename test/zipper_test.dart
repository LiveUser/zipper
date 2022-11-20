import 'package:test/test.dart';
import 'dart:io';
import 'package:zipper/zipper.dart' as Zipper;

void main() {
  test("Put everything into a single file", ()async{
    String sourceFolder = "./test_db/test_folder";
    String outputFile = "./test_db/file_system.json";
    await Zipper.zip(
      outputFile: File(outputFile), 
      sourceDirectory: Directory(sourceFolder),
    );
  });
  test("Extract the file and save it back conserving the previous file/folder structure", ()async{
    String sourceFilePath = "./test_db/file_system.json";
    String outputFolderPath = "./test_db";
    await Zipper.unzip(
      sourceFile: File(sourceFilePath), 
      outputDirectory: Directory(outputFolderPath),
      overWrite: true,
    );
  });
}