# Autonomous Vehicle Fleet Management
Student starter project using Java 17, Jakarta Servlets, JDBC and MySQL. Vehicle data is simulated; this app does not control real vehicles.

## Requirements
JDK 17+, Maven, MySQL 8+, Tomcat 10.1+.

## Setup
1. Run `database/schema.sql` in MySQL.
2. Set `DB_URL=jdbc:mysql://localhost:3306/autonomous_fleet`, `DB_USER`, and `DB_PASSWORD` environment variables.
3. Run `mvn clean package`; deploy `target/autonomous-fleet.war` to Tomcat 10.1+.
4. Open `/autonomous-fleet/dashboard`.

Dashboard currently uses sample data; connect the DAO and test the database before claiming JDBC integration is complete. Authentication, route optimization, and maintenance CRUD are future work.