/*
 * This Java source file was generated by the Gradle 'init' task.
 */
package se.iths;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;
import static se.iths.Constants.*;

public class App {

    public static void main(String[] args) {
        App app = new App();
        try {
            app.load();
        } catch (SQLException e) {
            System.err.println(String.format("Något gick fel vid inläsning av databas! (%s)", e.toString()));
        }
    }

    private void load() throws SQLException {
        Collection<Artist> artists = loadArtists();
        for (Artist artist : artists) {
            System.out.println(artist);
        }
    }

    private Collection<Artist> loadArtists() throws SQLException {
        Collection<Artist> artists = new ArrayList<>();
        Connection con = DriverManager.getConnection(JDBC_CONNECTION, JDBC_USER, JDBC_PASSWORD);
        ResultSet rs = con.createStatement().executeQuery(SELECT_All_OCH_COUNT_OF_TRACK);
        while (rs.next()) {
            long id = rs.getLong(SQL_ArtistId);
            String name = rs.getString(SQL_Name);
            Artist artist = new Artist(id, name);
            artists.add(artist);
            loadAlbum(rs, artist);
            loadTrack(rs, artist);

        }
        rs.close();
        con.close();
        return artists;
    }

    private static void loadAlbum(ResultSet rs, Artist artist) throws SQLException {
        Collection<Album> albums = new ArrayList<>();
        long albumId = rs.getLong(SQL_AlbumId);
        String title = rs.getString(SQL_TITLE);
        Album album = new Album(albumId, title);
        albums.add(album);
        for (Album album1 : albums) {
            artist.add(album1);

        }
    }

    private static void loadTrack(ResultSet rs, Artist artist) throws SQLException {
        Collection<Track> tracks = new ArrayList<>();
        String trackName = rs.getString(SQL_TRACK);
        Track track = new Track(trackName);
        tracks.add(track);
        for (Track track1: tracks
        ) {
            artist.addTrack(track1);

        }
    }

}