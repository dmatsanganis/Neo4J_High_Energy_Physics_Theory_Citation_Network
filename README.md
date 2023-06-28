## High Energy Physics Theory Citation Network

This GitHub repository contains the implementation of a property graph model and a Neo4j database for the High Energy Physics Theory Citation Network. 
The dataset consists of articles, authors, journals, and citations between articles.

### Dataset

The dataset used for this project can be downloaded from the provided zip file. It includes the following files:

- `ArticleNodes.csv`: Contains information about article nodes, including their ID, title, year, journal, and abstract.
- `AuthorNodes.csv`: Contains the article ID and the name of the author(s).
- `Citations.csv`: Contains information about citations between articles, including the source article ID, the citation relationship, and the target article ID.

### Property Graph Model

To represent the dataset as a property graph, the following entities, labels, types, and properties are used:

1. **Nodes**:
   - **Article**: Represents an article node with properties such as ID, title, year, journal, and abstract.
   - **Author**: Represents an author node with properties such as the author's name.
   - **Journal**: Represents a journal node with properties such as the journal's name.

2. **Edges**:
   - **CITES**: Represents a citation relationship between two article nodes.

The property graph model captures the relationships and attributes present in the High Energy Physics Theory Citation Network dataset.

### Importing the Dataset into Neo4j - Instructions

To load the dataset into a Neo4j database, you can use either the Neo4j Browser or the Neo4j import tool. The following steps outline the process:

1. Start the Neo4j database server.
2. Open the Neo4j Browser or use the Neo4j import tool.
3. Create a new database or connect to an existing one.
4. Use the appropriate command or tool to import the dataset from the CSV files (`ArticleNodes.csv`, `AuthorNodes.csv`, and `Citations.csv`) into the database.
5. Ensure that the imported data is mapped correctly to the nodes, edges, and properties defined in the property graph model.
6. Optionally, create indexes on relevant properties to optimize query performance.

![Neo4J](https://img.shields.io/badge/Neo4j-008CC1?style=for-the-badge&logo=neo4j&logoColor=white)
