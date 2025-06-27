# Configuration Management API

This Spring Boot application provides a RESTful API for managing configurations across a multi-tenant, multi-application banking platform. It allows for granular control over features, pages, forms, and fields, including dynamic UI theme management and user role-based feature enablement.

## Features

* **Multi-Tenant Support:** Manage configurations for different banking tenants.
* **Multi-Application Support:** Define configurations specific to different applications (e.g., Online Banking, Mobile Banking).
* **Hierarchical Structure:** Organize configurations in a logical hierarchy: Features -> Pages -> Forms -> Fields.
* **Field Properties Management:** Configure field enablement/disablement, custom labels, and custom validation rules per tenant and application.
* **UI Theme Management:** Apply UI themes (e.g., dark, classic) at the tenant-level, tenant-application-level, and tenant-application-feature-level.
* **Role-Based Feature Enablement:** Control feature visibility and access based on user roles within specific applications for each tenant.
* **Audit Logging:** Automatically tracks `created_at`, `updated_at`, `created_by`, and `updated_by` for all entities.
* **RESTful API:** Exposes a well-defined REST API for CRUD operations.
* **Swagger UI (OpenAPI):** Interactive API documentation for easy exploration and testing.
* **Database Portability:** Designed with database type considerations (e.g., `DATETIME` instead of `TIMESTAMP` for SQL Server compatibility) and uses generic `BIGINT` for IDs.

## Technologies Used

* **Spring Boot 3.2.5:** Framework for building robust, stand-alone, production-grade Spring applications.
* **Spring Data JPA:** Simplifies data access layer development.
* **Hibernate 6:** JPA implementation.
* **H2 Database:** In-memory database for rapid development and testing.
* **Lombok:** Reduces boilerplate code (getters, setters, constructors).
* **SpringDoc OpenAPI:** Automates generation of OpenAPI 3 specification and Swagger UI.
* **Jackson:** JSON processing library.
* **Hibernate Types (Vlad Mihalcea):** Provides advanced type mappings for JPA, including `JSONB` support.
* **Maven:** Build automation tool.
* **Java 17:** Programming language.

## Getting Started

### Prerequisites

* Java Development Kit (JDK) 17 or higher
* Apache Maven 3.6.3 or higher
* An IDE (IntelliJ IDEA, VS Code with Java extensions, Eclipse) with Lombok plugin installed and annotation processing enabled.
* Python 3.x (to run the `generate_readme.py` script if direct copy-paste fails)

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd configuration-management
```

### 2. Configure Lombok in your IDE

For Lombok annotations to be processed correctly by your IDE, ensure the following:

* **IntelliJ IDEA:**
    1.  Go to `File > Settings > Plugins`.
    2.  Search for "Lombok Plugin" and install it.
    3.  Go to `File > Settings > Build, Execution, Deployment > Compiler > Annotation Processors`.
    4.  Check "Enable annotation processing".
    5.  Restart IntelliJ IDEA.
* **VS Code (with Java extensions):**
    1.  Ensure you have the "Extension Pack for Java" installed. Lombok support is usually bundled.
    2.  You might need to restart VS Code or run "Java: Clean Java Language Server Workspace" from the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`).
* **Eclipse:**
    1.  Locate the `lombok.jar` file in your local Maven repository (e.g., `~/.m2/repository/org/projectlombok/lombok/{version}/lombok-{version}.jar`).
    2.  Run `java -jar lombok-{version}.jar` from your terminal. This will open an installer GUI.
    3.  Select your Eclipse installation directory and click "Install/Update".
    4.  Restart Eclipse.

### 3. Build the Project

Navigate to the project's root directory (where `pom.xml` is located) in your terminal and run:

```bash
mvn clean install
```

This command will download all dependencies, compile the code (including Lombok processing), run tests, and package the application into a runnable JAR file in the `target/` directory.

### 4. Run the Application

After a successful build, you can run the Spring Boot application from the command line:

```bash
java -jar target/configuration-management-0.0.1-SNAPSHOT.jar
```

The application will start on port `8080` by default. You should see logs indicating that Tomcat has started.

## Database Configuration (H2 - In-Memory)

By default, the application is configured to use an H2 in-memory database for easy development and testing. The schema will be automatically created/updated on application startup.

* **H2 Console:** You can access the H2 console at `http://localhost:8080/h2-console`
    * **JDBC URL:** `jdbc:h2:mem:configdb`
    * **Username:** `sa`
    * **Password:** (leave blank)

### Switching to PostgreSQL

To switch to PostgreSQL, you'll need to:

1.  **Add PostgreSQL Driver:** Uncomment the PostgreSQL dependency in `pom.xml` and comment out the H2 dependency.
2.  **Update `application.properties`:** Modify the database connection properties to point to your PostgreSQL instance:

    ```properties
    # PostgreSQL Database configuration
    spring.datasource.url=jdbc:postgresql://localhost:5432/your_database_name
    spring.datasource.username=your_username
    spring.datasource.password=your_password
    spring.datasource.driver-class-name=org.postgresql.Driver
    spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
    ```
3.  **Ensure PostgreSQL is running** and your database (`your_database_name`) exists.

## API Documentation (Swagger UI)

Once the application is running, you can access the interactive API documentation (Swagger UI) in your web browser:

* **Swagger UI:** `http://localhost:8080/swagger-ui.html`
* **OpenAPI JSON:** `http://localhost:8080/v3/api-docs`

The API endpoints are grouped by logical entities (Tenants, Applications, Features, etc.) for easy navigation, as defined by the `@Tag` annotations in the controllers and the `@OpenAPIDefinition` in the main application class.

## Key API Endpoints (Quick Reference)

Here are some of the main API endpoints you can interact with:

* **Tenants:**
    * `GET /config/v1/tenants`
    * `POST /config/v1/tenants`
    * `GET /config/v1/tenants/{tenantId}`
* **Applications:**
    * `GET /config/v1/applications`
    * `POST /config/v1/applications`
* **Features:**
    * `GET /config/v1/features`
    * `POST /config/v1/features`
* **User Roles:**
    * `GET /config/v1/user-roles`
    * `POST /config/v1/user-roles`
* **Pages (nested under Features):**
    * `GET /config/v1/features/{featureId}/pages`
    * `POST /config/v1/features/{featureId}/pages`
    * `PUT /config/v1/features/{featureId}/pages/{pageId}` (for nested updates of forms/fields)
* **Forms (nested under Pages):**
    * `GET /config/v1/pages/{pageId}/forms`
    * `POST /config/v1/pages/{pageId}/forms`
* **Fields (nested under Forms):**
    * `GET /config/v1/forms/{formId}/fields`
    * `POST /config/v1/fields` (flat endpoint for creation)
* **Themes:**
    * `GET /config/v1/themes`
    * `POST /config/v1/themes`
* **Orchestrated Field Configuration:**
    * `GET /tenants/{tenantId}/applications/{applicationId}/forms/{formId}/effective-fields` (Combines field list with resolved configurations)
    * `PUT /tenants/{tenantId}/applications/{applicationId}/forms/{formId}/field-configs` (Bulk update of field configurations for a form)

## Project Structure (Key Packages)

* `com.yourcompany.config`: Main application class (`ConfigurationManagementApplication.java`) and `AuditorAwareImpl.java`.
* `com.yourcompany.config.model`: JPA Entities (e.g., `Tenant`, `Application`, `Field`).
* `com.yourcompany.config.repository`: Spring Data JPA Repository interfaces for data access.
* `com.yourcompany.config.service`: Service interfaces and their implementations (business logic). Also contains DTOs.
* `com.yourcompany.config.controller`: REST API Controllers.
* `com.yourcompany.config.exception`: Custom exception classes and global exception handler.

## Future Enhancements

* **Comprehensive Nested Updates:** Fully implement the complex nested update logic for `PageUpdateRequest` and `FormNestedUpdateRequest` in the service layer.
* **Security:** Implement robust Spring Security with JWT validation and RBAC for API access control.
* **Database Migrations:** Integrate Flyway or Liquibase for version-controlled database schema management.
* **Advanced Filtering/Sorting:** Expand query parameters for collection endpoints (e.g., sorting, more complex filtering).
* **Caching:** Implement caching strategies for frequently accessed configuration data.
* **Logging & Monitoring:** Integrate with logging frameworks (e.g., SLF4J, Logback) and monitoring tools.
* **Client-Side Application:** Develop the frontend UI to consume this API.
