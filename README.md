# zipper

Package a directory into a single file. Note: Zipper does not .zip.😁

Hecho en 🇵🇷 por Radamés J. Valentín Reyes

## Functionality Purpose

Reads all of the directories and files within a certain folder and saves all of the data into a single .json format file that can later be extracted conserving both the file structure and data. It's similar to the idea behind a zip but does not include compression feature(at leas for now) or  securing with password and the resulting file size is greatly increased. It also uses a lot of RAM. Its meant for applications that require handling a single file rather than a complex file/folder structure. All of the required functions to create and extract such file is provided in this library.

Note: I did not create a .zip creating library because I still don't know how it works. I created my own file structure using .json.

## Examples

Importing the library

~~~dart
import 'package:zipper/zipper.dart' as Zipper;
import 'dart:io';
~~~



Merging everything into a File(zipping to a non-zip file)

~~~dart
String sourceFolder = "C:/Users/valen_z1p5ic1/Pictures/UbisoftConnect";
String outputFile = "C:/Users/valen_z1p5ic1/Downloads/file_system.json";
await Zipper.zip(
    outputFile: File(outputFile), 
    sourceDirectory: Directory(sourceFolder),
);
~~~

Extracting (unzipping a non-zip file)

Note: overwrite = false is the default value.

~~~dart
String sourceFilePath = "C:/Users/valen_z1p5ic1/Downloads/file_system.json";
String outputFolderPath = "C:/Users/valen_z1p5ic1/Downloads";
await Zipper.unzip(
    sourceFile: File(sourceFilePath), 
    outputDirectory: Directory(outputFolderPath),
    overWrite: true, //Optional parameter, true for overwriting conflicting file/folder names
);
~~~



## File Specifications

The file is a normal .json file with some standarized features. 

Such features are:

- JSON property name is the file or folder name
- If the property value is a List of integers(Array in JavaScript) it means that the property name corresponds to a File and each number on the list represents the value of each byte of the file.
- If the property value is a Map(JavaScript Object) it means that the property name corresponds to a Folder/Directory and the properties inside are subdirectories and files contained in it.
- Due to the previously stated reasons this format nests Maps(Objects) because they represent subdirectories and its contents



File example:

~~~json
{
	"filename.extension" : [17,22,36......],
    "folder name" : {},
}
~~~

## Error catching
An enumerator with different error types. It's a simplistic attempt full of errors to identify the type of error. ZipperError.errorParsing is the only enum that represents the error with 100% certainty and may not be another one.

~~~dart
try{
    String sourceFilePath = "C:/Users/valen_z1p5ic1/Downloads/file_system.json";
	String outputFolderPath = "C:/Users/valen_z1p5ic1/Downloads";
	await Zipper.unzip(
    	sourceFile: File(sourceFilePath), 
    	outputDirectory: Directory(outputFolderPath),
    	overWrite: true, //Optional parameter, true for overwriting conflicting file/folder names
	);
}catch(error){
    if(error == ZipperError.errorParsing){
        //Blah blah
    }else if(error == ZipperError.outOfRAM){
        //Blah blah
    }else{
        //Some stuff here
    }
}
~~~

## Random notes

- If the idea catches up the output file is meant to be saved as a File with the extension ".file_system" to denote that its using the specifications stated in this document

------------------------------------------------------------
## Contribute/donate by tapping on the Pay Pal logo/image

<a href="https://www.paypal.com/paypalme/onlinespawn"><img src="https://www.paypalobjects.com/webstatic/mktg/logo/pp_cc_mark_74x46.jpg"/></a>

------------------------------------------------------------