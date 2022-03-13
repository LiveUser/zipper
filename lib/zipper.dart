library zipper;

import 'dart:io';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:async_foreach/async_foreach.dart';
import 'dart:convert';

enum ZipperError{
  ///Error parsing the file
  errorParsing,
  ///If file access is allowed the problem may be that you ran out of RAM
  outOfRAM,
}

///Zips the folder into a non-.zip file
Future<void> zip({
  @required File outputFile,
  @required Directory sourceDirectory,
  bool includeRoot = true,
})async{
  Map<String, dynamic> filesystem;
  try{
    filesystem = await _getFolderAsObject(
      folder: sourceDirectory,
    );
  }catch(error){
    return ZipperError.outOfRAM;
  }
  try{
    //Include the root folder if stated on the parameters
    if(includeRoot){
      String rootName = sourceDirectory.path.substring(sourceDirectory.path.lastIndexOf("/") + 1);
      //print(rootName);
      filesystem = {
        rootName : filesystem,
      };
    }
  }catch(error){
    return ZipperError.outOfRAM;
  }
  //Save the resulting object at the outputFile
  await outputFile.create(recursive: true);
  await outputFile.writeAsString(jsonEncode(filesystem));
}
///Reads and converts the folders to Map(What's considered Objects in JavaScript)
Future<Map<String, dynamic>> _getFolderAsObject({
  @required Directory folder,
})async{
  Map<String, dynamic> map = {};
  List<FileSystemEntity> folderContents = await folder.list().toList();
  await folderContents.asyncForEach((item)async{
    String itemName = (item as FileSystemEntity).path;
    //Select just the last part of the path as the name. Slashes difine the path on other platforms, backslashes are used on windows. Have support for both.
    itemName = itemName.substring(itemName.lastIndexOf(Platform.isWindows ? "\\" : "/") + 1);
    if(item is Directory){
      map.addAll({
        itemName : await _getFolderAsObject(
          folder: item,
        ),
      });
    }else{
      map.addAll({
        itemName : await (item as File).readAsBytes(),
      });
    }
  });
  return map;
}

///UnZips the non-.zip file into a folder
Future<void> unzip({
  @required File sourceFile,
  @required Directory outputDirectory,
  ///Overwrite the files and folders at the output directory if file/folder names exist.
  bool overWrite = false,
})async{
  String json = await sourceFile.readAsString();
  Map<String, dynamic> map;
  try{
    map = jsonDecode(json);
  }catch(error){
    return ZipperError.errorParsing;
  }
  //Start the function that will extract the merged files
  await _setFilesFromObject(
    extractionDirectory: outputDirectory, 
    map: map,
    overWrite: overWrite,
  );
}

Future<void> _setFilesFromObject({
  @required Directory extractionDirectory,
  @required Map<String, dynamic> map,
  @required bool overWrite,
})async{
  await map.keys.toList().asyncForEach((keyName)async{
    if(map[keyName] is List){
      //Save the file bytes
      String filePath = await _uniquePathGenerator(path: "${extractionDirectory.path}/$keyName", isDirectory: false);
      //print("Extracting file to $filePath");
      //Create File
      await File(filePath).create(recursive: true);
      //Save data into the file
      await File(filePath).writeAsBytes(map[keyName].cast<int>());
    }else{
      //Call this function again but remember to append the folder name to the path
      String directoryPath = await _uniquePathGenerator(path: "${extractionDirectory.path}/$keyName", isDirectory: true);
      //print("Extracting Directory to $directoryPath");
      Directory newDirectory = Directory(directoryPath);
      //Create the directory
      await newDirectory.create(recursive: true);
      //Call the function
      await _setFilesFromObject(
        extractionDirectory: newDirectory, 
        map:map[keyName],
        overWrite: overWrite,
      );
    }
  });
}

//Unique Path Name Generator
Future<String> _uniquePathGenerator({
  @required String path,
  @required bool isDirectory,
})async{
  String fileName = path.substring(path.lastIndexOf("/") + 1);
  bool pathIsUnique = false;
  int i = 1;
  String uniquePath;
  if(isDirectory){
    if(!(await Directory(path).exists())){
      return path;
    }
    //Generate a unique path for the folder
    do{
      uniquePath = path.substring(0, path.lastIndexOf("/")) + "/$i-" + fileName;
      if(await Directory(uniquePath).exists()){
        i++;
      }else{
        pathIsUnique = true;
      }
    }while(pathIsUnique == false);
  }else{
    if(!(await File(path).exists())){
      return path;
    }
    //Generate a unique path for the file
    do{
      uniquePath = path.substring(0, path.lastIndexOf("/")) + "/$i-" + fileName;
      if(await File(uniquePath).exists()){
        i++;
      }else{
        pathIsUnique = true;
      }
    }while(pathIsUnique == false);
  }
  return uniquePath;
}