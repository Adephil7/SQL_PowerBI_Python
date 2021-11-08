--Database normalization, or data normalization, is a technique to organize the contents of the tables
--for transactional databases and data warehouses.

--without normalization, database systems can be inaccurate, slow, and inefficient, and they might not produce the data you expect.

--Why Data normalization?
--i. arranging data into logical groupings such that each group describes a small part of the whole
--ii. minimizing the amount of duplicate data stored in a database
--iii. organizing the data such that, when you modify it, you make the change in only one place
--iv. To optimize query performance ==>building a database in which you can access and manipulate the data
                                      --quickly and efficiently without compromising the integrity of the data in storage

--Sometimes database designers refer to these goals in terms such as data integrity, referential integrity, or keyed data access

--Data normalization is primarily important in the transactional, or online transactional processing (OLTP),
----database world, in which data modifications (e.g., inserts, updates, deletes) occur rapidly and randomly
----throughout the stored data.
--In contrast, a data warehouse contains a large amount of denormalized and summarized data—precalculated to
----avoid the performance penalty of ad hoc joins. In a data warehouse, updates happen periodically under
----extremely controlled circumstances. End users' updates to data in data warehouses are uncommon.


--How?

--Database designers use the term atomicity to describe this organization of data into one data item in each cell.
--e.g
-- One item of data, such as a first name, a last name, a phone number, or a street address,
--appears in each box, or cell, at each intersection of a row and column.

--READMORE ON Data normalization
https://www.itprotoday.com/sql-server/sql-design-why-you-need-database-normalization
