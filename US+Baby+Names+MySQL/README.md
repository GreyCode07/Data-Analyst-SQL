# US Baby Names MySQL

A comprehensive dataset of US baby names with historical trends and naming patterns analysis.

## Overview

This project contains historical data on baby names used in the United States, enabling analysis of naming trends, demographic patterns, and cultural shifts over time.

## Contents

### Data Files
- `Data_1/` - Alternative data structure and format
  - `create_baby_names_db.sql` - Database schema
  - `baby_names_db_data_dictionary.csv` - Data documentation
  
- `Data_2/Dataset_insert/` - Modular data insertion structure
  - `create_baby_names_db.sql` - Database schema
  - `insert_baby_names_1.sql` - First batch of names data
  - `insert_baby_names_2.sql` - Second batch of names data
  - `insert_baby_names_3.sql` - Third batch of names data

### Solutions
- `Solution/solution.sql` - Query examples and analytics

## Quick Start

### Option 1: Using Data_2 (Recommended for large datasets)

```sql
source Data_2/Dataset_insert/create_baby_names_db.sql;
source Data_2/Dataset_insert/insert_baby_names_1.sql;
source Data_2/Dataset_insert/insert_baby_names_2.sql;
source Data_2/Dataset_insert/insert_baby_names_3.sql;
```

### Option 2: Using Data_1
```sql
source Data_1/create_baby_names_db.sql;
```

## Database Tables

The database contains:
- **baby_names**: Records of baby names with frequency and year information
- **name_statistics**: Aggregated naming trends and rankings
- **demographic_data**: Name usage by gender and region

## Analysis Topics

- Popular names by year and decade
- Gender-based naming trends
- Name popularity rankings
- Regional naming patterns
- Historical name trends and cycles
- Emerging vs. declining names

## Use Cases

- Social and cultural trend analysis
- Demographic research
- Historical pattern recognition
- Naming convention studies
- Generational analysis

## Data Dictionary

See the `baby_names_db_data_dictionary.csv` file for complete field descriptions and data specifications.

## Notes

- Data spans multiple decades of US baby naming records
- Names are categorized by gender
- Frequency data shows popularity metrics
- Year information allows temporal analysis
