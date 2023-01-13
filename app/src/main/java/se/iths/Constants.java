package se.iths;

public class Constants {
    public final static String JDBC_CONNECTION = "jdbc:mysql://localhost:3306/Chinook";
    public final static String JDBC_USER = "iths";
    public final static String JDBC_PASSWORD = "iths";
    public final static String SQL_ArtistId = "ArtistId";
    public final static String SQL_Name = "Name";
    public final static String SQL_TITLE = "Title";
    public final static String SQL_AlbumId = "AlbumId";

    public final static String SQL_TRACK = "Track";
    public static String SELECT_All_OCH_COUNT_OF_TRACK = "SELECT DISTINCT ArtistId,AlbumId,Artist.Name,Title,COUNT(Track.Name) AS Track FROM Artist JOIN Album USING (ArtistId) JOIN Track USING (AlbumId) GROUP BY AlbumId ORDER BY ArtistId";
}
