// Mining Big Datasets
// Neo4j Graph Database - Assignment 2
// Dimitrios Matsanganis, f2822212
// Foteini Nefeli Nouskali, f2822213

// Queries:

// Q1
// Which are the top 5 authors with the most citations (from other papers).
// Return author names and number of citations.


MATCH (article1:Article)-[:CITES]->(article2:Article)-[:WRITTEN_BY]->(author:Author)
WITH author, count(article2) AS `Number of Citations`
ORDER BY `Number of Citations` DESC
RETURN author.name AS `Author Name`, `Number of Citations`
LIMIT 5


//  Q1 Output:
// ╒════════════════════╤═══════════════════╕
// │Author Name         │Number of Citations│
// ╞════════════════════╪═══════════════════╡
// │"Edward Witten"     │15681              │
// ├────────────────────┼───────────────────┤
// │"Ashoke Sen"        │7120               │
// ├────────────────────┼───────────────────┤
// │"Michael R. Douglas"│5577               │
// ├────────────────────┼───────────────────┤
// │"A.A. Tseytlin"     │5288               │
// ├────────────────────┼───────────────────┤
// │"Joseph Polchinski" │5267               │
// └────────────────────┴───────────────────┘


// Q2
// Which are the top 5 authors with the most collaborations (with different authors). 
// Return author names and number of collaborations.


MATCH (author1:Author)<-[:WRITTEN_BY]- (article:Article) - [:WRITTEN_BY] -> (author2:Author)
WHERE author1.name<>author2.name
RETURN author1.name AS `Author Name`, COUNT(DISTINCT author2) AS `Number of Collaborations`
ORDER BY `Number of Collaborations` DESC 
LIMIT 5


//  Q2 Output:
// ╒════════════╤════════════════════════╕
// │Author Name │Number of Collaborations│
// ╞════════════╪════════════════════════╡
// │"C.N. Pope" │50                      │
// ├────────────┼────────────────────────┤
// │"M. Schweda"│46                      │
// ├────────────┼────────────────────────┤
// │"S. Ferrara"│46                      │
// ├────────────┼────────────────────────┤
// │"H. Lu"     │45                      │
// ├────────────┼────────────────────────┤
// │"C. Vafa"   │45                      │
// └────────────┴────────────────────────┘


// Q3 
// Which is the author who has wrote the most papers without collaborations.
// Return author name and number of papers.


MATCH (article:Article)-[:WRITTEN_BY]->(author1:Author)
MATCH (article:Article)-[:WRITTEN_BY]->(author2:Author)
WITH author1, COUNT(article) AS `Number of Papers Without Collaboration`, COUNT(DISTINCT author2) AS PapersCounter
WHERE PapersCounter = 1
RETURN author1.name AS `Author Name`, `Number of Papers Without Collaboration`
ORDER BY `Number of Papers Without Collaboration` DESC 
LIMIT 1


//  Q3 Output:
// ╒═══════════╤══════════════════════════════════════╕
// │Author Name│Number of Papers Without Collaboration│
// ╞═══════════╪══════════════════════════════════════╡
// │"J. Kluson"│18                                    │
// └───────────┴──────────────────────────────────────┘


// Q4
// Which author published the most papers in 2001? Return author name and
// number of papers.


MATCH (journal:Journal)<-[:PUBLISHED_IN]-(article:Article)-[:WRITTEN_BY]->(author:Author)
WHERE article.year = '2001'
RETURN author.name AS `Author Name`, COUNT(article) AS `Number of Papers Published in 2001`
ORDER BY `Number of Papers Published in 2001` DESC 
LIMIT 1


//  Q4 Output:
// ╒════════════════════╤══════════════════════════════════╕
// │Author Name         │Number of Papers Published in 2001│
// ╞════════════════════╪══════════════════════════════════╡
// │"Sergei D. Odintsov"│13                                │
// └────────────────────┴──────────────────────────────────┘


// Q5 
// Which is the journal with the most papers about “gravity” (derived only from
// the paper title) in 1998. Return name of journal and number of papers.


// Case 1 count only articles containing the word gravity - written this way.
MATCH (journal:Journal)<-[:PUBLISHED_IN]-(article:Article)
WHERE article.year = '1998' AND article.title CONTAINS "gravity"
RETURN journal.journal AS `Journal`, COUNT(article) AS `Number of Papers Published Containing word 'gravity' in 1998`
ORDER BY `Number of Papers Published Containing word 'gravity' in 1998` DESC 
LIMIT 1


//  Q5 Output - Case 1:
// ╒════════════╤════════════════════════════════════════════════════════════╕
// │Journal     │Number of Papers Published Containing word 'gravity' in 1998│
// ╞════════════╪════════════════════════════════════════════════════════════╡
// │"Nucl.Phys."│25                                                          │
// └────────────┴────────────────────────────────────────────────────────────┘


// Case 2 all occurencies of gravity - like Gravity or GRAVITY.
MATCH (journal:Journal)<-[:PUBLISHED_IN]-(article:Article)
WHERE article.year = '1998' AND toLower(article.title)CONTAINS"gravity"
RETURN journal.journal AS `Journal`, COUNT(article) AS `Number of Papers Published Containing word 'gravity' in 1998`
ORDER BY `Number of Papers Published Containing word 'gravity' in 1998` DESC 
LIMIT 1


//  Q5 Output - Case 2:
// ╒════════════╤════════════════════════════════════════════════════════════╕
// │Journal     │Number of Papers Published Containing word 'gravity' in 1998│
// ╞════════════╪════════════════════════════════════════════════════════════╡
// │"Nucl.Phys."│34                                                          │
// └────────────┴────────────────────────────────────────────────────────────┘


// Note: 
// The two queries provided differ in the way they handle case sensitivity when checking 
// for the presence of the word "gravity" in the article titles. 
// The Case 2 query, using the toLower() function, converts the article titles to 
// lowercase before performing the check. 
// This means that it will match titles containing "gravity" 
// in any case (e.g., "gravity," "Gravity," "GRAVITY," etc.).
// In contrast, the Case 1 query does not perform any case conversion and directly checks
// if the article title contains the exact string "gravity" in its original case. 
// This means it will only match titles with the exact case-sensitive match of "gravity" (e.g., "gravity" but not "Gravity" or "GRAVITY").
// Therefore, if there are article titles in the database that contain "gravity" but in different case variations, 
// the Case 2 query using toLower() will count those titles as well, leading to potentially different results compared to the Case 1 query.
// However, it is important to note that in both cases the journal 'Nucl.Phys.' has the more 
// publications containing the word 'gravity' no matter the way written.


// Q6
// Which are the top 5 papers with the most citations? Return paper title and
// number of citations.


MATCH (article1:Article)-[cites:CITES]->(article2:Article)
RETURN article2.title AS `Article Title`, COUNT(cites) AS `Number of Citations`
ORDER BY `Number of Citations`
DESC LIMIT 5


//  Q6 Output:
// ╒═════════════════════════════════════════════════════════════════════════╤═══════════════════╕
// │Article Title                                                            │Number of Citations│
// ╞═════════════════════════════════════════════════════════════════════════╪═══════════════════╡
// │"The Large N Limit of Superconformal Field Theories and Supergravity"    │2414               │
// ├─────────────────────────────────────────────────────────────────────────┼───────────────────┤
// │"Anti De Sitter Space And Holography"                                    │1775               │
// ├─────────────────────────────────────────────────────────────────────────┼───────────────────┤
// │"Gauge Theory Correlators from Non-Critical String Theory"               │1641               │
// ├─────────────────────────────────────────────────────────────────────────┼───────────────────┤
// │"Monopole Condensation  And Confinement In N=2 Supersymmetric Yang-Mills"│1299               │
// ├─────────────────────────────────────────────────────────────────────────┼───────────────────┤
// │"M Theory As A Matrix Model: A Conjecture"                               │1199               │
// └─────────────────────────────────────────────────────────────────────────┴───────────────────┘


// Q7
// Which were the papers that use “holography” and “anti de sitter” (derived only
// from the paper abstract). Return authors and title.

MATCH (jr:Journal)<-[:PUBLISHED_IN]-(ar:Article)-[:WRITTEN_BY]->(au:Author)
WHERE ar.abstract CONTAINS "holography" AND  ar.abstract CONTAINS "anti de sitter"
RETURN au.name, ar.title
// No results since not having all lowercase matches.


MATCH (journal:Journal)<-[:PUBLISHED_IN]-(article:Article)-[:WRITTEN_BY]->(author:Author)
WHERE toLower(article.abstract) CONTAINS "holography" AND toLower(article.abstract) CONTAINS "anti de sitter"
RETURN COLLECT(author.name) AS `Authors Names`, article.title AS `Article Title`
// Matching 2 articles and output all authors.


//  Q7 Output:
// ╒═══════════════════════════════════════════╤══════════════════════════════════════════════════════════════════╕
// │Authors Names                              │Article Title                                                     │
// ╞═══════════════════════════════════════════╪══════════════════════════════════════════════════════════════════╡
// │["Seungjoon Hyun", "Youngjai Kiem"]        │"Background geometry of DLCQ M theory on a p-torus and holography"│
// ├───────────────────────────────────────────┼──────────────────────────────────────────────────────────────────┤
// │["Ru-Keng Su", "Bin Wang", "Elcio Abdalla"]│"Relating Friedmann equation to Cardy formula in universes with"  │
// └───────────────────────────────────────────┴──────────────────────────────────────────────────────────────────┘


// Q8
// Find the shortest path between ‘C.N. Pope’ and ‘M. Schweda’ authors (use any
// type of edges). Return the path and the length of the path. Comment about
// the type of nodes and edges of the path.


MATCH path = shortestPath((au1:Author)-[*]-(au2:Author))
WHERE au1.name = "C.N. Pope" AND au2.name = "M. Schweda"
RETURN [n in nodes(path)] AS Path, length(path) AS `Path Length`


//  Q8 Output:
// ╒══════════════════════════════════════════════════════════════════════╤═══════════╕
// │Path                                                                  │Path Length│
// ╞══════════════════════════════════════════════════════════════════════╪═══════════╡
// │[(:Author {name: "C.N. Pope",id: 9910252}), (:Article {year: "2000",id│4          │
// │: 1002,abstract: "  We point out that massive gauged supergravity pote│           │
// │ntials- for example thosearising due to the massive breathing mode of │           │
// │sphere reductions in M-theory orstring theory- allow for supersymmetri│           │
// │c (static) domain wall solutions whichare a hybrid of a Randall-Sundru│           │
// │m domain wall on one side- and a dilatonicdomain wall with a run-away │           │
// │dilaton on the other side. On the anti-de Sitter(AdS) side- these wall│           │
// │s have a repulsive gravity with an asymptotic regioncorresponding to t│           │
// │he Cauchy horizon- while on the other side the runawaydilaton approach│           │
// │es the weak coupling regime and a non-singular attractivegravity- with│           │
// │ the asymptotic region corresponding to the boundary of spacetime.We c│           │
// │ontrast these results with the situation for gauged supergravity poten│           │
// │tialsfor massless scalar modes- whose supersymmetric AdS extrema are g│           │
// │enericallymaxima- and there the asymptotic regime transverse to the wa│           │
// │ll corresponds tothe boundary of the AdS spacetime. We also comment on│           │
// │ the possibility that themassive breathing mode may- in the case of fu│           │
// │ndamental domain-wall sources-stabilize such walls via a Goldberger-Wi│           │
// │se mechanism.",title: "Domain Walls and Massive Gauged Supergravity Po│           │
// │tentials"}), (:Journal {journal: "Class.Quant.Grav.",id: 9912200}), (:│           │
// │Article {year: "1994",id: 9408030,abstract: "  The BRST transformation│           │
// │s for the Yang-Mills gauge fields in the presence ofgravity with torsi│           │
// │on are discussed by using the so-called Maurer-Cartanhorizontality con│           │
// │ditions. With the help of an operator $\d$ which allows todecompose th│           │
// │e exterior spacetime derivative as a BRST commutator we solve theWess-│           │
// │Zumino consistency condition corresponding to invariant Chern-Simons t│           │
// │ermsand gauge anomalies.",title: "Yang-Mills gauge anomalies in the pr│           │
// │esence of gravity with torsion"}), (:Author {name: "M. Schweda",id: 99│           │
// │11127})]                                                              │           │
// └──────────────────────────────────────────────────────────────────────┴───────────┘


// Q9 
// Run again the previous query (8) but now use only edges between authors
// and papers. Comment about the type of nodes and edges of the path.
// Compare the results with query 8.


MATCH path = shortestPath((au1:Author)-[:WRITTEN_BY*]-(au2:Author))
WHERE au1.name = "C.N. Pope" AND au2.name = "M. Schweda"
RETURN [n in nodes(path)] AS Path, length(path) AS `Path Length`


//  Q9 Output:
// ╒═════════════════════════════════════════════════════════════════════════════════════════════╤═══════════╕
// │Path                                                                                         │Path Length│
// ╞═════════════════════════════════════════════════════════════════════════════════════════════╪═══════════╡
// │[(:Author {name: "C.N. Pope",id: 9910252}), (:Article {year: "1999",id: 9909099,abstract: "  │8          │
// │It is well known that the toroidal dimensional reduction of supergravitiesgives rise in three│           │
// │ dimensions to theories whose bosonic sectors are describedpurely in terms of scalar degrees │           │
// │of freedom- which parameterise sigma-modelcoset spaces. For example- the reduction of eleven-│           │
// │dimensional supergravitygives rise to an E_8/SO(16) coset Lagrangian. In this paper- we dispe│           │
// │nse withthe restrictions of supersymmetry- and study all the three-dimensional scalarsigma mo│           │
// │dels G/H where G is a maximally-non-compact simple group- with H itsmaximal compact subgroup-│           │
// │ and find the highest dimensions from which they canbe obtained by Kaluza-Klein reduction. A │           │
// │magic triangle emerges with a dualitybetween rank and dimension. Interesting also are the cas│           │
// │es of Hermiteansymmetric spaces and quaternionic spaces.",title: "Higher-dimensional Origin o│           │
// │f D=3 Coset Symmetries"}), (:Author {name: "B. Julia",id: 9911035}), (:Article {year: "1999",│           │
// │id: 9904003,abstract: "  Straightforward application of the standard Noether method in superg│           │
// │ravitytheories yields an incorrect superpotential for local supersymmetrytransformations- whi│           │
// │ch gives only half of the correct supercharge. We show howto derive the correct superpotentia│           │
// │l through Lagrangian methods- by applying acriterion proposed recently by one of us. We verif│           │
// │y the equivalence with theHamiltonian formalism. It is also indicated why the first-order and│           │
// │second-order formalisms lead to the same superpotential. We rederive inparticular the central│           │
// │ extension by the magnetic charge of the ${\cal N}_4 =2$algebra of SUGRA asymptotic charges."│           │
// │,title: "Noether superpotentials in supergravities"}), (:Author {name: "M. Henneaux",id: 9906│           │
// │121}), (:Article {year: "1997",id: 9707129,abstract: "  We prove that there is no power-count│           │
// │ing renormalizable nonabeliangeneralization of the abelian topological mass mechanism in four│           │
// │ dimensions.The argument is based on the technique of consistent deformations of the mastereq│           │
// │uation developed by G. Barnich and one of the authors. Recent attemptsinvolving extra fields │           │
// │are also commented upon.",title: "A No-Go Theorem for the Nonabelian Topological Mass Mechani│           │
// │sm in Four"}), (:Author {name: "S.P. Sorella",id: 9907073}), (:Article {year: "1992",id: 9212│           │
// │112,abstract: "  The topological supersymmetry of the pure Chern-Simons model in threedimensi│           │
// │ons is established in the case where the theory is defined in the axialgauge.",title: "A shor│           │
// │t comment on the supersymmetric structure of Chern-Simons theory"}), (:Author {name: "M. Schw│           │
// │eda",id: 9911127})]                                                                          │           │
// └─────────────────────────────────────────────────────────────────────────────────────────────┴───────────┘


// Q10
// Find all authors with shortest path lengths > 25 from author ‘Edward Witten’.
// The shortest paths will be calculated only on edges between authors and
// articles. Return author name, the length and the paper titles for each path.


MATCH path = ShortestPath((author1:Author)-[:WRITTEN_BY*]-(author2:Author))
WHERE author1.name = 'Edward Witten' AND author1<>author2
WITH author2.name AS `Author Name`, length(path) AS `Path Length`, [n in nodes(path) WHERE n.title IS NOT NULL| n.title] AS `Article Title`
WHERE `Path Length` > 25
RETURN `Author Name`, `Path Length`, `Article Title`


//  Q10 Output:
// ╒════════════════════╤═══════════╤══════════════════════════════════════════════════════════════════════╕
// │Author Name         │Path Length│Article Title                                                         │
// ╞════════════════════╪═══════════╪══════════════════════════════════════════════════════════════════════╡
// │"Katsunori Kawamura"│26         │["Black Hole Entropy in M-Theory", "N=2 Extremal Black Holes", "Twelve│
// │                    │           │-Dimensional Aspects of Four-Dimensional N=1 Type I Vacua", "Explicit │
// │                    │           │Construction of Yang-Mills Instantons on ALE Spaces", "Non Local Obser│
// │                    │           │vables and Confinement in BF Formulation of Yang-Mills", "Quantized Te│
// │                    │           │mperatures Spectra in Curved Spacetimes", "Correspondence between Mink│
// │                    │           │owski and de Sitter Quantum Field Theory", "Towards a General Theory o│
// │                    │           │f Quantized Fields on the Anti-de Sitter", "Towards a Relativistic KMS│
// │                    │           │ Condition", "Spontaneous Collapse of Supersymmetry", "Notes on Unfair│
// │                    │           │ Papers by Mebarki et al. on ``Quantum Nonsymmetric", "D=26 and Exact │
// │                    │           │Solution to the Conformal-Gauge Two-Dimensional Quantum", "Pseudo Cunt│
// │                    │           │z Algebra and Recursive FP Ghost System in String Theory"]            │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"S.N.Solodukhin"    │26         │["Supersymmetric Yang-Mills Systems And Integrable Systems", "Non-Pert│
// │                    │           │urbative Vacua and Particle Physics in M-Theory", "Wrapped fivebranes │
// │                    │           │and N=2 super Yang-Mills theory", "Holographic Renormalization and War│
// │                    │           │d Identities with the Hamilton-Jacobi", "Conformal Field Theory Correl│
// │                    │           │ators from Classical Scalar Field Theory on", "On Black Hole Creation │
// │                    │           │in Planckian Energy Scattering", "Interaction of d=2 c=1 Discrete Stat│
// │                    │           │es from String Field Theory", "Elliptic Ruijsenaars-Schneider model vi│
// │                    │           │a the Poisson reduction of the", "On the SO(N) symmetry of the chiral │
// │                    │           │SU(N) Yang--Mills model", "Universal invariant renormalization for sup│
// │                    │           │ersymmetric theories", "Projective Invariance and One-Loop Effective A│
// │                    │           │ction in Affine-Metric", "The Background-Field Method and Noninvariant│
// │                    │           │ Renormalization", "On Quantum Deformation of the Schwarzschild Soluti│
// │                    │           │on"]                                                                  │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"D.V.Fursaev"       │28         │["Supersymmetric Yang-Mills Systems And Integrable Systems", "Non-Pert│
// │                    │           │urbative Vacua and Particle Physics in M-Theory", "Wrapped fivebranes │
// │                    │           │and N=2 super Yang-Mills theory", "Holographic Renormalization and War│
// │                    │           │d Identities with the Hamilton-Jacobi", "Conformal Field Theory Correl│
// │                    │           │ators from Classical Scalar Field Theory on", "On Black Hole Creation │
// │                    │           │in Planckian Energy Scattering", "Interaction of d=2 c=1 Discrete Stat│
// │                    │           │es from String Field Theory", "Elliptic Ruijsenaars-Schneider model vi│
// │                    │           │a the Poisson reduction of the", "On the SO(N) symmetry of the chiral │
// │                    │           │SU(N) Yang--Mills model", "Universal invariant renormalization for sup│
// │                    │           │ersymmetric theories", "Projective Invariance and One-Loop Effective A│
// │                    │           │ction in Affine-Metric", "The Background-Field Method and Noninvariant│
// │                    │           │ Renormalization", "On Quantum Deformation of the Schwarzschild Soluti│
// │                    │           │on", "On the Description of the Riemannian Geometry in the Presence of│
// │                    │           │ Conical"]                                                            │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"G.Miele"           │30         │["Supersymmetric Yang-Mills Systems And Integrable Systems", "Non-Pert│
// │                    │           │urbative Vacua and Particle Physics in M-Theory", "Wrapped fivebranes │
// │                    │           │and N=2 super Yang-Mills theory", "Holographic Renormalization and War│
// │                    │           │d Identities with the Hamilton-Jacobi", "Conformal Field Theory Correl│
// │                    │           │ators from Classical Scalar Field Theory on", "On Black Hole Creation │
// │                    │           │in Planckian Energy Scattering", "Interaction of d=2 c=1 Discrete Stat│
// │                    │           │es from String Field Theory", "Elliptic Ruijsenaars-Schneider model vi│
// │                    │           │a the Poisson reduction of the", "On the SO(N) symmetry of the chiral │
// │                    │           │SU(N) Yang--Mills model", "Universal invariant renormalization for sup│
// │                    │           │ersymmetric theories", "Projective Invariance and One-Loop Effective A│
// │                    │           │ction in Affine-Metric", "The Background-Field Method and Noninvariant│
// │                    │           │ Renormalization", "On Quantum Deformation of the Schwarzschild Soluti│
// │                    │           │on", "On the Description of the Riemannian Geometry in the Presence of│
// │                    │           │ Conical", "Finite-Temperature Scalar Field Theory in Static de Sitter│
// │                    │           │ Space"]                                                              │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"I.N.Kondrashuk"    │26         │["Supersymmetric Yang-Mills Systems And Integrable Systems", "Non-Pert│
// │                    │           │urbative Vacua and Particle Physics in M-Theory", "Wrapped fivebranes │
// │                    │           │and N=2 super Yang-Mills theory", "Holographic Renormalization and War│
// │                    │           │d Identities with the Hamilton-Jacobi", "Conformal Field Theory Correl│
// │                    │           │ators from Classical Scalar Field Theory on", "On Black Hole Creation │
// │                    │           │in Planckian Energy Scattering", "Interaction of d=2 c=1 Discrete Stat│
// │                    │           │es from String Field Theory", "Elliptic Ruijsenaars-Schneider model vi│
// │                    │           │a the Poisson reduction of the", "On the SO(N) symmetry of the chiral │
// │                    │           │SU(N) Yang--Mills model", "Universal invariant renormalization for sup│
// │                    │           │ersymmetric theories", "Projective Invariance and One-Loop Effective A│
// │                    │           │ction in Affine-Metric", "The Background-Field Method and Noninvariant│
// │                    │           │ Renormalization", "Difficulties of an Infrared Extension of Different│
// │                    │           │ial Renormalization"]                                                 │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"M.V.Chizhov"       │26         │["Supersymmetric Yang-Mills Systems And Integrable Systems", "Non-Pert│
// │                    │           │urbative Vacua and Particle Physics in M-Theory", "Wrapped fivebranes │
// │                    │           │and N=2 super Yang-Mills theory", "Holographic Renormalization and War│
// │                    │           │d Identities with the Hamilton-Jacobi", "Conformal Field Theory Correl│
// │                    │           │ators from Classical Scalar Field Theory on", "On Black Hole Creation │
// │                    │           │in Planckian Energy Scattering", "$N$-point amplitudes for d=2 c=1 Dis│
// │                    │           │crete States from String Field", "Elliptic Ruijsenaars-Schneider model│
// │                    │           │ from the cotangent bundle over the", "Canonical quantization of the d│
// │                    │           │egenerate WZ action including chiral", "Universal invariant renormaliz│
// │                    │           │ation for supersymmetric theories", "Projective Invariance and One-Loo│
// │                    │           │p Effective Action in Affine-Metric", "The Background-Field Method and│
// │                    │           │ Noninvariant Renormalization", "Antisymmetric tensor matter fields: a│
// │                    │           │n abelian model"]                                                     │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"R. Casalbuoni"     │26         │["Evidence for Heterotic/Heterotic Duality", "Quantum discontinuity be│
// │                    │           │tween zero and infinitesimal graviton mass with", "A New Approach to A│
// │                    │           │xial Vector Model Calculations II", "Photon Splitting in a Strong Magn│
// │                    │           │etic Field: Recalculation and", "Microcanonical Ensemble and Algebra o│
// │                    │           │f Conserved Generators for", "Quarks in the Skyrme- t Hooft-Witten Mod│
// │                    │           │el", "The Dirac-Coulomb Problem for the $\kappa$-Poincare Quantum Grou│
// │                    │           │p", "Italian workshop on quantum groups", "Exponential mapping for non│
// │                    │           │ semisimple quantum groups", "Heisenberg XXZ Model and Quantum Galilei│
// │                    │           │ Group", "Quantum Galilei Group as Symmetry of Magnons", "Scalar and s│
// │                    │           │pinning particles in a plane wave field", "Thermodynamics of the Massi│
// │                    │           │ve Gross-Neveu Model"]                                                │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"R. Gatto"          │26         │["Evidence for Heterotic/Heterotic Duality", "Quantum discontinuity be│
// │                    │           │tween zero and infinitesimal graviton mass with", "A New Approach to A│
// │                    │           │xial Vector Model Calculations II", "Photon Splitting in a Strong Magn│
// │                    │           │etic Field: Recalculation and", "Microcanonical Ensemble and Algebra o│
// │                    │           │f Conserved Generators for", "Quarks in the Skyrme- t Hooft-Witten Mod│
// │                    │           │el", "The Dirac-Coulomb Problem for the $\kappa$-Poincare Quantum Grou│
// │                    │           │p", "Italian workshop on quantum groups", "Exponential mapping for non│
// │                    │           │ semisimple quantum groups", "Heisenberg XXZ Model and Quantum Galilei│
// │                    │           │ Group", "Quantum Galilei Group as Symmetry of Magnons", "Scalar and s│
// │                    │           │pinning particles in a plane wave field", "Thermodynamics of the Massi│
// │                    │           │ve Gross-Neveu Model"]                                                │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"G. Pettini"        │26         │["Evidence for Heterotic/Heterotic Duality", "Quantum discontinuity be│
// │                    │           │tween zero and infinitesimal graviton mass with", "A New Approach to A│
// │                    │           │xial Vector Model Calculations II", "Photon Splitting in a Strong Magn│
// │                    │           │etic Field: Recalculation and", "Microcanonical Ensemble and Algebra o│
// │                    │           │f Conserved Generators for", "Quarks in the Skyrme- t Hooft-Witten Mod│
// │                    │           │el", "The Dirac-Coulomb Problem for the $\kappa$-Poincare Quantum Grou│
// │                    │           │p", "Italian workshop on quantum groups", "Exponential mapping for non│
// │                    │           │ semisimple quantum groups", "Heisenberg XXZ Model and Quantum Galilei│
// │                    │           │ Group", "Quantum Galilei Group as Symmetry of Magnons", "Scalar and s│
// │                    │           │pinning particles in a plane wave field", "Thermodynamics of the Massi│
// │                    │           │ve Gross-Neveu Model"]                                                │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"M. Modugno"        │26         │["Evidence for Heterotic/Heterotic Duality", "Quantum discontinuity be│
// │                    │           │tween zero and infinitesimal graviton mass with", "A New Approach to A│
// │                    │           │xial Vector Model Calculations II", "Photon Splitting in a Strong Magn│
// │                    │           │etic Field: Recalculation and", "Microcanonical Ensemble and Algebra o│
// │                    │           │f Conserved Generators for", "Quarks in the Skyrme- t Hooft-Witten Mod│
// │                    │           │el", "The Dirac-Coulomb Problem for the $\kappa$-Poincare Quantum Grou│
// │                    │           │p", "Italian workshop on quantum groups", "Exponential mapping for non│
// │                    │           │ semisimple quantum groups", "Heisenberg XXZ Model and Quantum Galilei│
// │                    │           │ Group", "Quantum Galilei Group as Symmetry of Magnons", "Scalar and s│
// │                    │           │pinning particles in a plane wave field", "Thermodynamics of the Massi│
// │                    │           │ve Gross-Neveu Model"]                                                │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"L.V. Avdeev"       │28         │["Supersymmetric Yang-Mills Systems And Integrable Systems", "Non-Pert│
// │                    │           │urbative Vacua and Particle Physics in M-Theory", "Wrapped fivebranes │
// │                    │           │and N=2 super Yang-Mills theory", "Holographic Renormalization and War│
// │                    │           │d Identities with the Hamilton-Jacobi", "Conformal Field Theory Correl│
// │                    │           │ators from Classical Scalar Field Theory on", "On Black Hole Creation │
// │                    │           │in Planckian Energy Scattering", "$N$-point amplitudes for d=2 c=1 Dis│
// │                    │           │crete States from String Field", "Elliptic Ruijsenaars-Schneider model│
// │                    │           │ from the cotangent bundle over the", "Canonical quantization of the d│
// │                    │           │egenerate WZ action including chiral", "Universal invariant renormaliz│
// │                    │           │ation for supersymmetric theories", "Projective Invariance and One-Loo│
// │                    │           │p Effective Action in Affine-Metric", "The Background-Field Method and│
// │                    │           │ Noninvariant Renormalization", "Antisymmetric tensor matter fields: a│
// │                    │           │n abelian model", "A queer reduction of degrees of freedom"]          │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"A.I.Zelnikov"      │30         │["Supersymmetric Yang-Mills Systems And Integrable Systems", "Non-Pert│
// │                    │           │urbative Vacua and Particle Physics in M-Theory", "Wrapped fivebranes │
// │                    │           │and N=2 super Yang-Mills theory", "Holographic Renormalization and War│
// │                    │           │d Identities with the Hamilton-Jacobi", "Conformal Field Theory Correl│
// │                    │           │ators from Classical Scalar Field Theory on", "On Black Hole Creation │
// │                    │           │in Planckian Energy Scattering", "$N$-point amplitudes for d=2 c=1 Dis│
// │                    │           │crete States from String Field", "Elliptic Ruijsenaars-Schneider model│
// │                    │           │ from the cotangent bundle over the", "Canonical quantization of the d│
// │                    │           │egenerate WZ action including chiral", "Universal invariant renormaliz│
// │                    │           │ation for supersymmetric theories", "Projective Invariance and One-Loo│
// │                    │           │p Effective Action in Affine-Metric", "The Background-Field Method and│
// │                    │           │ Noninvariant Renormalization", "On Quantum Deformation of the Schwarz│
// │                    │           │schild Solution", "On One-loop Quantum Corrections to the Thermodynami│
// │                    │           │cs of Charged Black", "Black Hole Entropy: Off-Shell vs On-Shell"]    │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"V.P.Frolov"        │28         │["Supersymmetric Yang-Mills Systems And Integrable Systems", "Non-Pert│
// │                    │           │urbative Vacua and Particle Physics in M-Theory", "Wrapped fivebranes │
// │                    │           │and N=2 super Yang-Mills theory", "Holographic Renormalization and War│
// │                    │           │d Identities with the Hamilton-Jacobi", "Conformal Field Theory Correl│
// │                    │           │ators from Classical Scalar Field Theory on", "On Black Hole Creation │
// │                    │           │in Planckian Energy Scattering", "$N$-point amplitudes for d=2 c=1 Dis│
// │                    │           │crete States from String Field", "Elliptic Ruijsenaars-Schneider model│
// │                    │           │ from the cotangent bundle over the", "Canonical quantization of the d│
// │                    │           │egenerate WZ action including chiral", "Universal invariant renormaliz│
// │                    │           │ation for supersymmetric theories", "Projective Invariance and One-Loo│
// │                    │           │p Effective Action in Affine-Metric", "The Background-Field Method and│
// │                    │           │ Noninvariant Renormalization", "On Quantum Deformation of the Schwarz│
// │                    │           │schild Solution", "On One-loop Quantum Corrections to the Thermodynami│
// │                    │           │cs of Charged Black"]                                                 │
// ├────────────────────┼───────────┼──────────────────────────────────────────────────────────────────────┤
// │"W. Israel"         │28         │["Supersymmetric Yang-Mills Systems And Integrable Systems", "Non-Pert│
// │                    │           │urbative Vacua and Particle Physics in M-Theory", "Wrapped fivebranes │
// │                    │           │and N=2 super Yang-Mills theory", "Holographic Renormalization and War│
// │                    │           │d Identities with the Hamilton-Jacobi", "Conformal Field Theory Correl│
// │                    │           │ators from Classical Scalar Field Theory on", "On Black Hole Creation │
// │                    │           │in Planckian Energy Scattering", "$N$-point amplitudes for d=2 c=1 Dis│
// │                    │           │crete States from String Field", "Elliptic Ruijsenaars-Schneider model│
// │                    │           │ from the cotangent bundle over the", "Canonical quantization of the d│
// │                    │           │egenerate WZ action including chiral", "Universal invariant renormaliz│
// │                    │           │ation for supersymmetric theories", "Projective Invariance and One-Loo│
// │                    │           │p Effective Action in Affine-Metric", "The Background-Field Method and│
// │                    │           │ Noninvariant Renormalization", "On Quantum Deformation of the Schwarz│
// │                    │           │schild Solution", "On One-loop Quantum Corrections to the Thermodynami│
// │                    │           │cs of Charged Black"]                                                 │
// └────────────────────┴───────────┴──────────────────────────────────────────────────────────────────────┘
