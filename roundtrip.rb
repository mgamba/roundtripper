#! /usr/bin/env ruby

#FNAME = "JetBlue   The Holiday Recovery Sale.html"
#REGX = /Now\([^,],(\d*),&quot;(\w*)&quot;,&quot;(\w*)/

#FNAME = "JetBlue   The So Long Summer Sale.html"
#REGX = /data-od\="([^,]*),([^"]*)[^\$]*\$([\d]*)/

FNAME = "JetBlue   The Fly Somewhere New Sale.html"
REGX = /data-od\="([^,]*),([^"]*)[^\$]*\$([\d]*)/

def flights_from(airport)
  @flights.select{|f|f[0]==airport}
end

def flights_to(airport)
  @flights.select{|f|f[1]==airport}
end

def connections(from, to)
  @flights.select{|f|f[0]==from[1] && f[1]==to[0]}
end

def connections_to_any_of(from, to)
  to.select{|f|f[0]==from[1]}
end

def trips_with_2_legs
  departing_flights = flights_from(@origin)
  returning_flights = flights_to(@origin)
  flights = departing_flights.map{|f|connections_to_any_of(f,returning_flights)}
  trips = departing_flights.map.zip(flights.map(&:first)).reject{|e|e.last.nil?}
  flight_count = trips.count

  print "\b"*20
  puts "\n*** #{flight_count} roundtrip flights with 2 legs ***"
  trips.each do |trip|
    puts "#{@origin} - #{trip.last.first} - #{@origin}   $#{trip.last.last.to_i+trip.first.last.to_i}"
  end
  round_trips
end

def main
  if ARGV.empty?
    puts "need to specify final destination.  ex: ruby rountrip.rb JFK"
  else
    @flights = File.open(FNAME, "rb").read.scan(REGX).compact
    @origin = ARGV[0]
    flights = trips_with_2_legs
  end
end;main
