class ColumnNameParse {
  static String parseColName(String colName) {
    var buffer = StringBuffer();
    for (int i = 0; i < colName.length; i++) {
      if (i == 0)
      // first letter uppercase
      {
        buffer.write(colName[i].toUpperCase());
      }
      // underscore means space
      else if (colName[i] == '_') {
        buffer.write(' ');
      }
      // after space uppercase
      else if (colName[i - 1] == '_') {
        buffer.write(colName[i].toUpperCase());
      } else {
        buffer.write(colName[i]);
      }
    }

    return buffer.toString();
  }
}
