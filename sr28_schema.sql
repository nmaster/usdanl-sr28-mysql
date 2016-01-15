DROP DATABASE IF EXISTS usdanlsr28;
CREATE DATABASE IF NOT EXISTS usdanlsr28 CHARSET = utf8;

USE usdanlsr28;

/*
* Source Code File
*
* This table contains codes indicating the type of data (analytical, calculated, 
* assumed zero, and so on) in the Nutrient Data file. To improve the usability 
* of the database and to provide values for the FNDDS, NDL staff imputed nutrient 
* values for a number of proximate components, total dietary fiber, total sugar, 
* and vitamin and mineral values.
*/
CREATE TABLE SRC_CD (
	Src_Cd		CHAR(2)		NOT NULL,	-- a 2-digit code indicating type of data.
	SrcCd_Desc	CHAR(60)	NOT NULL,	-- description of source code that identifies the type of nutrient data.
	CONSTRAINT SRC_CD_PK PRIMARY KEY(Src_Cd)
);

/*
* Data Derivation Code Description File
*
* This table provides information on how the nutrient values were determined. 
* The file contains the derivation codes and their descriptions.
*/
CREATE TABLE DERIV_CD (
	Deriv_Cd	CHAR(4)		NOT NULL,	-- derivation code
	Deriv_Desc	CHAR(120)	NOT NULL,	-- description of derivation code giving specific information on how the value was determined.
	CONSTRAINT DERIV_CD_PK PRIMARY KEY(Deriv_Cd)
);

/*
* Sources of Data File
*
* This table provides a citation to the DataSrc_ID in the Sources of Data Link file.
*/
CREATE TABLE DATA_SRC (
	DataSrc_ID 	CHAR(6)		NOT NULL, 	-- unique ID identifying the reference/source.
	Authors 	CHAR(255),				-- list of authors for a journal article or name of sponsoring organization for other documents.
	Title 		CHAR(255)	NOT NULL,	-- title of article or name of document, such as a report from a company or trade association.
	Year 		CHAR(4),				-- year article or document was published.
	Journal 	CHAR(135),				-- name of the journal in which the article was published.
	Vol_City 	CHAR(16), 				-- volume number for journal articles, books, or reports; city where sponsoring organization is located.
	Issue_State CHAR(5),				-- issue number for journal article; State where the sponsoring organization is located.
	Start_Page 	CHAR(5),				-- starting page number of article/document.
	End_Page 	CHAR(5),				-- ending page number of article/document.
	CONSTRAINT DATA_SRC_PK PRIMARY KEY(DataSrc_ID)
);

/*
* Footnote File
*
* This table contains additional information about the food item, household weight, 
* and nutrient value.
*/
CREATE TABLE FOOTNOTE (
	NDB_No		CHAR(5)		NOT NULL,	-- 5-digit Nutrient Databank number that uniquely identifies a food item
	FootNt_No	CHAR(4)		NOT NULL,	-- sequence number. If a given footnote applies to more than one nutrient number, the same footnote number is used.
	Footnt_Typ	CHAR(1)		NOT NULL,	-- type of footnote (D = footnote adding information to the food description; M = footnote adding information to measure description; N = footnote providing additional information on a nutrient value. If the Footnt_Typ = N, the Nutr_No will also be filled in.
	Nutr_No		CHAR(3),				-- unique 3-digit identifier code for a nutrient to which footnote applies.
	Footnt_Txt	CHAR(200)	NOT NULL	-- footnote text.
);

/*
* LanguaL Factors Description File
*
* This table is a support file to the LanguaL Factor file and contains 
* the descriptions for only those factors used in coding the selected 
* food items codes in this release of SR.
*/
CREATE TABLE LANGDESC (
	Factor_Code	CHAR(5)		NOT NULL,	-- the LanguaL factor from the Thesaurus.
	Description	CHAR(140)	NOT NULL,	-- the description of the LanguaL Factor Code from the thesaurus.
	CONSTRAINT LANGDESC_PK PRIMARY KEY (Factor_Code)
);

/*
* Nutrient Definition File
*
* This table is a support file to the Nutrient Data file. 
* It provides the 3-digit nutrient code, unit of measure, INFOODS
* tagname, and description. 
*/
CREATE TABLE NUTR_DEF (
	Nutr_No		CHAR(3)			NOT NULL,	-- unique 3-digit identifier code for a nutrient.
	Units		CHAR(7)			NOT NULL,	-- units of measure (mg, g, µg, and so on).
	Tagname		CHAR(20),					-- International Network of Food Data Systems (INFOODS) tagnames.
	NutrDesc	CHAR(60)		NOT NULL,	-- name of nutrient/food component.
	Num_Dec		DECIMAL(6,0)	NOT NULL,	-- number of decimal places to which a nutrient value is rounded
	SR_Order	DECIMAL(6,0)	NOT NULL,
	CONSTRAINT NUTR_DEF_PK PRIMARY KEY (Nutr_No)
);

/*
* Food Group Description File
* 
* This table is a support file to the Food Description file and contains
* a list of food groups and their descriptions.
*/
CREATE TABLE FD_GROUP (
	FdGrp_Cd	CHAR(4)		NOT NULL,	-- 4-digit code identifying a food group.
	FdGrp_Desc	CHAR(60)	NOT NULL,	-- name of food group
	CONSTRAINT FD_GROUP_PK PRIMARY KEY (FdGrp_Cd)
);

/*
* Food Description File
*
* This table contains long and short descriptions and food group 
* designators for all food items, along with common names, manufacturer 
* name, scientific name, percentage and description of refuse, and 
* factors used for calculating protein and kilocalories, if applicable. 
* Items used in the FNDDS are also identified by value of “Y” in the 
* Survey field.
*/
CREATE TABLE FOOD_DES (
	NDB_No 		CHAR(5) 	NOT NULL, 	-- 5-digit Nutrient Databank number that uniquely identifies a food item.
	FdGrp_Cd	CHAR(4) 	NOT NULL, 	-- 4-digit code indicating food group to which a food item belongs.
	Long_Desc	CHAR(200)	NOT NULL, 	-- 200-character description of food item.
	Shrt_Desc	CHAR(60)	NOT NULL, 	-- 60-character abbreviated description of food item.
	ComName		CHAR(100),				-- other names commonly used to describe a food, including local or regional names.
	ManufacName	CHAR(65),				-- indicates the company that manufactured the product, when appropriate.
	Survey		CHAR(1),				-- indicates if the food has a complete nutrient profile including all 65 FNDDS nutrients.
	Ref_desc	CHAR(135),				-- description of inedible parts of a food item (refuse), such as seeds or bone.
	Refuse		DECIMAL(2),				-- percentage of refuse
	SciName		CHAR(65),				-- scientific name of the food item.
	N_Factor	DECIMAL(4,2),			-- factor for converting nitrogen to protein.
	Pro_Factor	DECIMAL(4,2),			-- factor for calculating calories from protein.
	Fat_Factor	DECIMAL(4,2),			-- factor for calculating calories from fat.
	CHO_Factor	DECIMAL(4,2),			-- factor for calculating calories from carbohydrate.
	CONSTRAINT FOOD_DES_PK PRIMARY KEY (NDB_No),
	CONSTRAINT FOOD_DES_UK UNIQUE (NDB_No,FdGrp_Cd),
	CONSTRAINT FOOD_DES_FK FOREIGN KEY(FdGrp_Cd) REFERENCES FD_GROUP(FdGrp_Cd)
);

/*
* Nutrient Data File
*
* This table contains the nutrient values and information about the values, 
* including expanded statistical information.
*/
CREATE TABLE NUT_DATA (
	NDB_No 			CHAR(5) 		NOT NULL, 	-- 5-digit Nutrient Databank number that uniquely identifies a food item.
	Nutr_No			CHAR(3)			NOT NULL,	-- unique 3-digit identifier code for a nutrient.
	Nutr_Val		DECIMAL(10,3)	NOT NULL,	-- amount in 100 grams, edible portion.
	Num_Data_Pts	DECIMAL(5,0)	NOT NULL,	-- number of data points/analyses used to calculate the nutrient value.
	Std_Error		DECIMAL(8,3),				-- standard error of the mean. null, if cannot be calculated. The standard error is also not given, if the number of data points is less than three.
	Src_Cd			CHAR(2)			NOT NULL,	-- code indicating type of data.
	Deriv_Cd		CHAR(4),					-- data derivation code giving specific information on how value is determined.
	Ref_NDB_No		CHAR(5),					-- NDB number of the item used to calculate a missing value.
	Add_Nutr_Mark	CHAR(1),					-- indicates a vitamin or mineral added for fortification or enrichment.
	Num_Studies		DECIMAL(2,0),				-- number of studies.
	Min				DECIMAL(10,3),				-- minimum value.
	Max				DECIMAL(10,3),				-- maximum value.
	DF				DECIMAL(4,0),				-- degrees of freedom.
    Low_EB			DECIMAL(10,3),				-- Lower 95% error bound.
	Up_EB			DECIMAL(10,3),				-- Upper 95% error bound.
	Stat_cmt		CHAR(10),					-- Statistical comments (see documentation for definitions)
	AddMod_Date		CHAR(10),					-- indicates when a value was either added to the database or last modified
	CC				CHAR(1),					-- confidence code indicating data quality, based on evaluation (NYI)
	CONSTRAINT NUT_DATA_PK PRIMARY KEY (NDB_No, Nutr_No),
	CONSTRAINT NUT_DATA_NDBNO_FK FOREIGN KEY(NDB_No) REFERENCES FOOD_DES(NDB_No),
	CONSTRAINT NUT_DATA_NUTDEF_FK FOREIGN KEY(Nutr_No) REFERENCES NUTR_DEF(Nutr_No)
);

/*
* Weight File
*
* This table contains the weight in grams of a number of common measures 
* for each food item.
*/
CREATE TABLE WEIGHT (
	NDB_No			CHAR(5)			NOT NULL,	-- 5-digit Nutrient Databank number that uniquely identifies a food item
	Seq				CHAR(2)			NOT NULL,	-- sequence number
	Amount			DECIMAL(5,3)	NOT NULL,	-- unit modifier (e.g. 1 in "1 cup")
	Msre_Desc		CHAR(84)		NOT NULL,	-- description (e.g. cup, diced, 1" pieces)
	Gm_Wgt			DECIMAL(7,1)	NOT NULL,	-- gram weight
	Num_Data_Pts	Decimal(3,0),				-- number of data points
	Std_Dev			Decimal(7,3),				-- standard deviation
	CONSTRAINT WEIGHT_PK PRIMARY KEY(NDB_No,Seq),
	CONSTRAINT WEIGHT_NDBNO_FK FOREIGN KEY(NDB_No) REFERENCES FOOD_DES(NDB_No)
);

/*
* LanguaL Factor File
*
* This table is a support file to the Food Description file and contains 
* the factors from the LanguaL Thesaurus used to code a particular food.
*/
CREATE TABLE LANGUAL (
	NDB_No		CHAR(5)		NOT NULL,	-- 5-digit Nutrient Databank number that uniquely identifies a food item.
	Factor_Code	CHAR(5)		NOT NULL,	-- the LanguaL factor from the Thesaurus.
	CONSTRAINT LANGUAL_PK PRIMARY KEY(NDB_No, Factor_Code),
	CONSTRAINT LANGUAL_FOOD_DES_FK FOREIGN KEY (NDB_No) REFERENCES FOOD_DES(NDB_No),
	CONSTRAINT LANGUAL_LANGDESC_FK FOREIGN KEY (Factor_Code) REFERENCES LANGDESC(Factor_Code)
);

/*
* Sources of Data Link File
*
* This table is used to link the Nutrient Data file with the Sources of Data table. 
* It is needed to resolve the many-to-many relationship between the two tables.
*/
CREATE TABLE DATSRCLN (
	NDB_No 		CHAR(5) 	NOT NULL, 	-- 5-digit Nutrient Databank number that uniquely identifies a food item.
	Nutr_No		CHAR(3)		NOT NULL,	-- unique 3-digit identifier code for a nutrient.
	DataSrc_ID	CHAR(6)		NOT NULL,	-- unique ID identifying the reference/source.
	CONSTRAINT DATSRCLN_PK PRIMARY KEY(NDB_No,Nutr_No,DataSrc_ID),
	CONSTRAINT DATSRCLN_NDB_FK FOREIGN KEY(NDB_No) REFERENCES FOOD_DES(NDB_No),
	CONSTRAINT DATSRCLN_NUT_FK FOREIGN KEY(Nutr_No) REFERENCES NUTR_DEF(Nutr_No),
	CONSTRAINT DATSRCLN_SRC_FK FOREIGN KEY(DataSrc_ID) REFERENCES DATA_SRC(DataSrc_ID)
);
