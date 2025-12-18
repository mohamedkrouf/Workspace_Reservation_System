package model;

public class Room {
    private int id;
    private String name;
    private int capacity;
    private String location;
    private int available;
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public int getAvailable() { return available; }
    public void setAvailable(int available) { this.available = available; }

    @Override
    public String toString() {
        return "Room{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", capacity=" + capacity +
                ",available=" + available +
                ", location=" + location +
                '}';
    }

}
