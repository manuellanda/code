# save this as shell.nix
{ pkgs ? import <nixpkgs> {}}:

let
  python-packages = p: with p; [
    # Enter python library names here:
    pandas
    scipy
    numpy
    scikit-learn
    sympy
    pymoo
  ];
  # Python interpreter with python-packages.
  python-with-packages = pkgs.python3.withPackages python-packages;
  # Common tools and dependencies.
  common-utils = with pkgs; [ curl wget gcc ];
  # Make shell with common tools/dependencies and python environment.

  # small script to create a database with sqlite3
  createdb = pkgs.writeShellScriptBin "createdb" ''
    echo "Database will be created in current directory"
    
    echo "Enter database name: "
    read dbname
    while [[ ! $dbname =~ ^[a-zA-Z0-9_]+$ ]]; do
      echo "Invalid database name. Database name must not contain spaces or special characters."
      echo "Enter database name: "
      read dbname
    done
    while [[ -d $dbname ]]; do
      echo "A folder with the same name already exists in current directory. Do you want to overwrite it? (y/n)"
      read overwrite
      if [[ $overwrite == "y" ]]; then
        rm -rf $dbname
        mkdir $dbname
        break
      elif [[ $overwrite == "n" ]]; then
        echo "Enter database name: "
        read dbname
        while [[ ! $dbname =~ ^[a-zA-Z0-9_]+$ ]]; do
          echo "Invalid database name. Database name must not contain spaces or special characters."
          echo "Enter database name: "
          read dbname
        done
      else
        echo "Invalid input. Please enter y or n."
      fi
    done
    if [[ ! -d $dbname ]]; then
      mkdir $dbname
    fi
    
    pushd $dbname > /dev/null

    echo "Enter number of tables: "
    read numtables
    while [[ ! $numtables =~ ^[0-9]+$ ]]; do
      echo "Invalid input. Please enter a positive integer."
      echo "Enter number of tables: "
      read numtables
    done

    for ((i=1; i<=$numtables; i++)); do
      echo "Enter table name [$i]: "
      read tablename
      while [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; do
        echo "Invalid table name. Table name must not contain spaces or special characters."
        echo "Enter table name [$i]: "
        read tablename
      done
      while [[ -f $tablename ]]; do
        echo "A table with the same name already exists in current directory. Please enter a different table name."
        echo "Enter table name [$i]: "
        read tablename
        while [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; do
          echo "Invalid table name. Table name must not contain spaces or special characters."
          echo "Enter table name [$i]: "
          read tablename
        done
      done
      touch $tablename
      echo "Enter number of columns: "
      read numcolumns
      while [[ ! $numcolumns =~ ^[0-9]+$ ]]; do
        echo "Invalid input. Please enter a positive integer."
        echo "Enter number of columns: "
        read numcolumns
      done
      for ((j=1; j<=$numcolumns; j++)); do
        echo "Enter column name [$tablename[$j]]: "
        read columnname
        while [[ ! $columnname =~ ^[a-zA-Z0-9_]+$ ]]; do
          echo "Invalid column name. Column name must not contain spaces or special characters."
          echo "Enter column name [$tablename[$j]]: "
          read columnname
        done
        echo "Enter data type [$tablename[$j]]: "
        read datatype
        while [[ ! $datatype =~ ^(NULL|INTEGER|REAL|TEXT|BLOB)$ ]]; do
          echo "Invalid data type. Please enter one of the following data types:"
          echo "NULL, INTEGER, REAL, TEXT, BLOB (case sensitive)"
          echo "Enter data type [$tablename[$j]]: "
          read datatype
        done

        echo "$columnname $datatype" >> $tablename
      done
      echo "CREATE TABLE $tablename (" >> $create.sql
      while read -r line; do
        echo "$line," >> $create.sql
      done < $tablename
      # remove last comma
      sed -i '$ s/.$//' $create.sql
      echo ");" >> $create.sql
    done

    sqlite3 $dbname.db < $create.sql

    popd > /dev/null
  '';

in pkgs.mkShell {
  packages = common-utils ++ 
             [ python-with-packages ] ++
             # Put other packages here: e.g:
             (with pkgs; [ 
             sqlite-interactive
             ]);
  buildInputs = [ createdb ];
}