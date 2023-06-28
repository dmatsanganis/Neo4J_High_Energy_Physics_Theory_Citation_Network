// Mining Big Datasets
// Neo4j Graph Database - Assignment 2
// Dimitrios Matsanganis, f2822212
// Foteini Nefeli Nouskali, f2822213


// Create Constraints and Nodes for Article.

CREATE CONSTRAINT FOR (article:Article) REQUIRE article.id IS UNIQUE;

LOAD CSV 
FROM "file:///ArticleNodes.csv" AS Articles 
FIELDTERMINATOR ',' 
CREATE (article:Article{id:toInteger(Articles[0]), title:Articles[1], year:Articles[2], abstract:Articles[4]});


// Create Constraints and Nodes for Journal.

CREATE CONSTRAINT FOR (j:Journal) REQUIRE j.journal IS UNIQUE;

LOAD CSV 
FROM "file:///ArticleNodes.csv" AS journals
WITH journals
WHERE journals[3] IS NOT NULL
MERGE (j:Journal {journal: journals[3]})
ON MATCH SET j.id = toInteger(journals[0]);


// Relationship PUBLISHED_IN.

LOAD CSV FROM "file:///ArticleNodes.csv" AS row
MATCH (article:Article), (j:Journal)
WHERE article.id = toInteger(row[0]) AND j.journal = row[3]
CREATE (article) - [:PUBLISHED_IN] -> (j);


// Relationship CITES.

LOAD CSV 
FROM "file:///Citations.csv" AS citations 
FIELDTERMINATOR '\t'
MATCH (article1:Article {id: toInteger(citations[0])}) 
MATCH (article2:Article {id: toInteger(citations[1])}) 
MERGE (article1)-[:CITES]->(article2);


// Create Constraints and Nodes for Author.

CREATE CONSTRAINT FOR (author:Author) REQUIRE author.name IS UNIQUE;

LOAD CSV 
FROM "file:///AuthorNodes.csv" AS row
WITH row
WHERE row[1] IS NOT NULL
MERGE (n:Author {name: row[1]})
ON MATCH SET n.id = toInteger(row[0]);


// Relationship WRITTEN_BY.

LOAD CSV FROM "file:///AuthorNodes.csv" AS row
MATCH (article:Article), (author:Author)
WHERE article.id = toInteger(row[0]) AND author.name = row[1]
CREATE (article) - [:WRITTEN_BY] -> (author);


// Visualize the Graph Model.
call db.schema.visualization()