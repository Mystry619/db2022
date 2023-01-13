package se.iths;


import org.junit.jupiter.api.*;

import java.sql.*;

import static org.junit.jupiter.api.Assertions.*;
import static se.iths.ConstantsTest.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class AppTest {

    private static long actualIdAfterInsert;

    private static Connection con = null;

    @BeforeAll
    public static void setUp() throws Exception {
        con = DriverManager.getConnection(JDBC_CONNECTION, JDBC_USER, JDBC_PASSWORD);
        con.createStatement().execute("DROP TABLE IF EXISTS Employees ");
        con.createStatement().execute("CREATE TABLE Employees (Id INT  NOT NULL AUTO_INCREMENT, Name VARCHAR(255), Job VARCHAR(255), PRIMARY KEY (Id))");
    }

    @AfterAll
    public static void tearDown() throws Exception {
        con.close();
    }

    @Order(1)
    @Test
    void shouldCreateRowInDatabase() throws Exception {
        PreparedStatement stmt = con.prepareStatement("INSERT INTO Employees (Name, Job) VALUES (?,?)",Statement.RETURN_GENERATED_KEYS);
        stmt.setString(1, TEST_EMPLOY);
        stmt.setString(2, TEST_JOB);
        stmt.execute();
        stmt.setString(1, TEST_SECOND_EMPLOY);
        stmt.setString(2, TEST_JOB);
        stmt.execute();
        ResultSet rs = stmt.getGeneratedKeys();
        assertTrue(rs.next(), "Should have two row with generated id and choice the second row!");
        final long expectedIdAfterInsert = 2L;
        actualIdAfterInsert = rs.getLong(1);
        assertEquals(expectedIdAfterInsert, actualIdAfterInsert, "Should have correct id after insert!");
    }

    @Order(2)
    @Test
    void shouldFindRowInDatabase() throws Exception {
        PreparedStatement stmt = con.prepareStatement("SELECT Id, Name, Job FROM Employees WHERE Id = ?");
        stmt.setLong(1, actualIdAfterInsert);
        ResultSet rs = stmt.executeQuery();
        assertTrue(rs.next(), "Should find the row!");
        assertEquals(actualIdAfterInsert, rs.getLong("Id"), "Selected Id should match");
        assertTrue(TEST_SECOND_EMPLOY.equalsIgnoreCase(rs.getString("Name")), "Selected Name should match");
        assertTrue(TEST_JOB.equalsIgnoreCase(rs.getString("Job")), "Selected Job should match");
        rs.close();
        stmt.close();
    }

    @Order(3)
    @Test
    void shouldUpdateRowInDatabase() throws Exception {
        PreparedStatement stmt = con.prepareStatement("UPDATE Employees Set Job = ? WHERE Id = ?");
        stmt.setString(1, TEST_NEW_JOB);
        stmt.setLong(2, actualIdAfterInsert);
        stmt.execute();

        stmt = con.prepareStatement("SELECT Job FROM Employees WHERE Id = ?");
        stmt.setLong(1, actualIdAfterInsert);
        ResultSet rs = stmt.executeQuery();
        assertTrue(rs.next(), "Should find the row!");
        assertTrue(TEST_NEW_JOB.equalsIgnoreCase(rs.getString("Job")), "Updated Job should match");
    }

    @Order(4)
    @Test
    void shouldDeleteRowInDatabase() throws Exception {
        con.createStatement().execute("DELETE FROM Employees");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT count(*) FROM Employees");
        assertTrue(rs.next(), "Should find one row with count!");
        assertEquals(0, rs.getInt(1), "Table should be empty");
    }
}