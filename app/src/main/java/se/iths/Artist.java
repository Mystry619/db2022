package se.iths;

import java.util.ArrayList;
import java.util.Collection;

public class Artist {
    private final long id;
    private String name;
    private Collection<Album> albums = new ArrayList<>();
    private Collection<Track> tracks = new ArrayList<>();

    public Artist(long id, String name) {
        this.id = id;
        this.name = name;
    }

    public long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void add(Album album) {
        albums.add(album);
    }
    public void addTrack(Track track){
        tracks.add(track);
    }

    public String toString() {
        StringBuilder builder = new StringBuilder(String.valueOf(id));
        builder.append(" ");
        builder.append("Artist: "+ name);
        System.out.println();
        builder.append("\nAlbum: ");
        for (Album album : albums) {
            builder.append( album );
            builder.append("\n");
            builder.append("Number of track in this Album " +tracks);
        }
        return builder.toString();
    }
}
