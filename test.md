- `GET /employees/{id}` retrieves a specific employee.
- `POST /employees` creates a new employee.
- `PUT /employees/{id}` updates an existing employee.
- `DELETE /employees/{id}` deletes an employee.

### Steps to Set Up:

1. **JAX-RS Dependencies**: If you are using Maven, add the following dependencies to your `pom.xml` to use **JAX-RS** (e.g., Jersey as an implementation):

**pom.xml:**

```xml
<dependencies>
    <!-- Jersey JAX-RS Implementation -->
    <dependency>
        <groupId>org.glassfish.jersey.core</groupId>
        <artifactId>jersey-server</artifactId>
        <version>3.0.0</version>
    </dependency>
    <dependency>
        <groupId>org.glassfish.jersey.containers</groupId>
        <artifactId>jersey-container-servlet</artifactId>
        <version>3.0.0</version>
    </dependency>
    <!-- JSON Processing API -->
    <dependency>
        <groupId>org.glassfish.jersey.media</groupId>
        <artifactId>jersey-media-json-binding</artifactId>
        <version>3.0.0</version>
    </dependency>
</dependencies>
```

2. **Create the Employee Class**: This class will represent your employee data.

```java
public class Employee {
    private int id;
    private String name;
    private String department;

    // Constructor
    public Employee(int id, String name, String department) {
        this.id = id;
        this.name = name;
        this.department = department;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
}
```

3. **Create the RESTful API with JAX-RS**: The following code defines REST endpoints for managing employees.

```java
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.HashMap;
import java.util.Map;

@Path("/employees")
public class EmployeeResource {

    private static Map<Integer, Employee> employeeDB = new HashMap<>();

    // Example preloaded employee data
    static {
        employeeDB.put(1, new Employee(1, "John Doe", "Engineering"));
        employeeDB.put(2, new Employee(2, "Jane Smith", "Marketing"));
    }

    // GET an employee by ID
    @GET
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getEmployee(@PathParam("id") int id) {
        Employee employee = employeeDB.get(id);
        if (employee != null) {
            return Response.ok(employee).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity("Employee not found").build();
        }
    }

    // POST to add a new employee
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response createEmployee(Employee employee) {
        if (employeeDB.containsKey(employee.getId())) {
            return Response.status(Response.Status.CONFLICT).entity("Employee already exists").build();
        }
        employeeDB.put(employee.getId(), employee);
        return Response.status(Response.Status.CREATED).entity(employee).build();
    }

    // PUT to update an existing employee
    @PUT
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response updateEmployee(@PathParam("id") int id, Employee employee) {
        if (employeeDB.containsKey(id)) {
            employeeDB.put(id, employee);
            return Response.ok(employee).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity("Employee not found").build();
        }
    }

    // DELETE an employee by ID
    @DELETE
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteEmployee(@PathParam("id") int id) {
        Employee removedEmployee = employeeDB.remove(id);
        if (removedEmployee != null) {
            return Response.ok().entity("Employee deleted").build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity("Employee not found").build();
        }
    }
}
```

### 4. **Create the Application Config**:
You need to configure your JAX-RS application by extending `Application`. This tells the server to serve the JAX-RS resources.

```java
import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

@ApplicationPath("/api")
public class EmployeeApplication extends Application {
    // No need to override any methods
}
```

### 5. **Run the Server**:
- Deploy this JAX-RS application using a servlet container like **Tomcat** or **Jetty**.
- The REST endpoints will be accessible at `http://<server-ip>:<port>/api/employees`.

### 6. **Client-Side Operations**:
Now, from the client-side, you can interact with the REST API using `GET`, `POST`, `PUT`, and `DELETE` requests.

#### Example Client Code Using `HttpURLConnection` for Each Operation:

**1. GET Request (Retrieve Employee):**

```java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class GetEmployeeClient {
    public static void main(String[] args) {
        try {
            URL url = new URL("http://your-friend-ip:8080/api/employees/1");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }

            System.out.println("Employee Data: " + content.toString());
            in.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

**2. POST Request (Create Employee):**

```java
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class PostEmployeeClient {
    public static void main(String[] args) {
        try {
            URL url = new URL("http://your-friend-ip:8080/api/employees");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String newEmployeeJson = "{\"id\": 3, \"name\": \"Alice Green\", \"department\": \"HR\"}";
            OutputStream os = conn.getOutputStream();
            os.write(newEmployeeJson.getBytes());
            os.flush();

            if (conn.getResponseCode() == HttpURLConnection.HTTP_CREATED) {
                System.out.println("Employee created successfully.");
            } else {
                System.out.println("Failed to create employee.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

**3. PUT Request (Update Employee):**

```java
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class PutEmployeeClient {
    public static void main(String[] args) {
        try {
            URL url = new URL("http://your-friend-ip:8080/api/employees/1");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("PUT");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String updatedEmployeeJson = "{\"id\": 1, \"name\": \"John Doe\", \"department\": \"Sales\"}";
            OutputStream os = conn.getOutputStream();
            os.write(updatedEmployeeJson.getBytes());
            os.flush();

            if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                System.out.println("Employee updated successfully.");
            } else {
                System.out.println("Failed to update employee.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

**4. DELETE Request (Delete Employee):**

```java
import java.net.HttpURLConnection;
import java.net.URL;

public class DeleteEmployeeClient {
    public static void main(String[] args) {
        try {
            URL url = new URL("http://your-friend-ip:8080/api/employees/1");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("DELETE");

            if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                System.out.println("Employee deleted successfully.");
            } else {
                System.out.println("Failed to delete employee.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```
