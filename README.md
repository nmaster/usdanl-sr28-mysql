# usdanl-sr28-mysql

This repo provides a simple shell script to import the ASCII file version of the USDA National Nutrient Database (Release SR-28) [1] into a local MySQL database. A database schema strictly following the USDA reference documentation is included. The script has been developed on Ubuntu 15.10 using MySQL 5.6.

## Use Instructions

Simply run the script, including parameters for mysql username and password (see below). The repective MySQL user should hold sufficient permissions to execute the database management operations stated in `sr28_schema.sql` (in particular to create new databases) and to import data into the created database.
```
./sr28_import.sh mysqluser mysqlpass
```

After successful execution, you should find a new database `usdanlsr28` on your MySQL server, and the official reference documentation for the USDA National Nutrient Database `sr28_doc.pdf` in the current directory.

## References

[1] US Department of Agriculture, Agricultural Research Service, Nutrient Data Laboratory. USDA National Nutrient Database for Standard Reference, Release 28. Version Current:  September 2015.  Internet:  http://www.ars.usda.gov/nea/bhnrc/ndl
