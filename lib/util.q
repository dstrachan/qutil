////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// UTIL ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////
// PRIVATE //
/////////////

.util.priv.types:`mixedList`boolean`booleanList`guid`guidList`byte`byteList`short`shortList`int`intList`long,
  `longList`real`realList`float`floatList`char`string`symbol`symbolList`timestamp`timestampList`month`monthList`date,
  `dateList`datetime`datetimeList`timespan`timespanList`minute`minuteList`second`secondList`time`timeList

.util.priv.typeDict:.util.priv.types!`short$0,raze flip@[2#enlist 1 2,4+til 16;0;neg]

////////////
// PUBLIC //
////////////

///
// Assert condition is true
// @param cond boolean Condition to check
// @param description string Error description
.util.assert:{[cond;description]
  if[not cond;'"assert failed: ",description];
  }

///
// Checks if a given directory exists
// @param dir symbol Directory
.util.isDir:{[dir]
  .util.assert[.util.isType[`symbol;dir];"expect symbol"];
  res:(not()~k)&not dir~k:key dir;
  res}

///
// Checks if a given file exists
// @param file symbol File
.util.isFile:{[file]
  .util.assert[.util.isType[`symbol;file];"expect symbol"];
  res:file~key file;
  res}

///
// Checks if a given value is of the specified type, type can be provided
// as either a single symbol or a symbol list
// @param typeList symbol/symbolList List of types to be checked against
// @param val any Value to be compared against typeList
.util.isType:{[typeList;val]
  res:any .util.priv.typeDict[typeList]=/:type val;
  res}

///
// Checks if a given list of variable names exists
// @param variableList symbol/symbolList List of variables to be checked
.util.exists:{[variableList]
  if[0<type variableList;:.z.s'[variableList]];
  res:`boolean$count key variableList;
  res}

///
// Checks if a given value is a table
// @param val any Value to be checked
.util.isTable:{[val]
  98=type val}

///
// Checks if a given value is a dictionary
// @param val any Value to be checked
.util.isDict:{[val]
  99=type val}

///
// Recursively stringify any given data
// @param list any List of values to stringify
.util.stringify:{[list]
  res:$[10=type list;list;
    97<type list;"\n",.Q.s list;
    0<=type list;"¬"sv .z.s@'list;
    string list];

  ssr[;"¬";" "]ssr[;"\n";"\n "]ssr[res;"\n¬";"\n"]}

///
// Left-pad string with a character a given number of times
// @param str string String to pad
// @param len long Number of times to repeat padding
// @param char char Character to pad string
.util.padLeft:{[str;len;char]
  if[not 10=type str;
    str:string str];
  $[0<len-:count str;len#char;""],str}

///
// Right-pad string with a character a given number of times
// @param str string String to pad
// @param len long Number of times to repeat padding
// @param char char Character to pad string
.util.padRight:{[str;len;char]
  if[not 10=type str;
    str:string str];
  str,$[0<len-:count str;len#char;""]}

///
// Formats a number to 2 decimal places
// @param num long/float Number to be formatted
.util.formatNumber:{[num]
  sign:$[num<0;"-";""];
  num:(reverse","sv 3 cut reverse first a),".",last a:"."vs .Q.f[2;abs num];
  sign,ssr[num;".00";""]}

///
// Formats a number into the best byte representation (KB/MB/GB)
// @param bytes long/float Bytes to be formatted
.util.formatBytes:{[bytes]
  " "sv@[;0;.util.formatNumber]
  $[1024>abs bytes%:1024;(bytes;"KB");
    1024>abs bytes%:1024;(bytes;"MB");
    (bytes%1024;"GB")]}

///
// Casts a value to a given type
// @param typ symbol/char Type name
// @param val any Value to cast
.util.cast:{[typ;val]
  if[.util.isType[typ;val];:val];
  if[`string=typ;:string val];
  .[$;(typ;val);{'`cast}]}

///
// Gets the name of the q file originally loaded minus the .q suffix
.util.getProcName:{[]
  `$first"."vs last"/"vs string .z.f}

///
// Normalize a list of dictionaries into a table
// @param dictList dictList List of dictionaries to be normalized
.util.normalizeTable:{[dictList]
  // If we have been passed a table our job is done
  if[.util.isTable[dictList];:dictList];

  // Attempt to raze a uniform list of dictionaries into a table
  dictList:raze dictList;
  if[.util.isTable[dictList];:dictList];

  // Build table manually by ensuring each dictionary has the same number of values for the union of all keys
  tableKeys:(union/)key@'dictList;
  table:flip tableKeys!flip dictList@\:tableKeys;
  table}
