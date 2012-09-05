#! /usr/bin/ruby

DMAX = 3
FNAME_HOLIDAY_RECOVERY = "JetBlue   The Holiday Recovery Sale.html"
REGX_HOLIDAY_RECOVERY = /Now\([^,],(\d*),&quot;(\w*)&quot;,&quot;(\w*)/
FNAME_SUMMER_SALE = "JetBlue   The So Long Summer Sale.html"
REGX_SUMMER_SALE = /data-od\="([^,]*),([^"]*)[^\$]*\$([\d]*)/

def show flights, depth=0, ttrip=nil
  round_trips = []
  if depth == 0
    n = flights.map{|f|f if f[1]==ARGV[0]}.compact.count
    puts "#{n} flights leaving #{ARGV[0]}"
    i = 0
  end
  flights.each do |flight|
    if (depth<DMAX && depth>0) || (depth==0 && ARGV[0]==flight[1])
      if depth == 0
        print "\b\b\b\b#{(100.0*i/n).round}%"
        i += 1
      end
      ttrip = [flight[1]] unless depth > 0
      trip = ttrip.dup
      trip << flight [0] << flight[2] if (flight[1]==trip[-1] && (!trip.include?(flight[2]) || flight[2]==trip[0]))
      if trip[0] == trip[-1]
        round_trips << trip.join("-")
        break if depth > 0
      else
        round_trips << show(flights.map{|f|f if f[2]!=flight[2] && trip[-3]!=f[1] }.compact, depth+1, trip)
      end
    end
  end
  round_trips
end

def main
  flights = show(File.open(FNAME_HOLIDAY_RECOVERY, "rb").read.scan(REGX_HOLIDAY_RECOVERY).compact).flatten.compact.uniq.sort
  #flights = show(File.open(FNAME_SUMMER_SALE, "rb").read.scan(REGX_SUMMER_SALE).compact).flatten.compact.uniq.sort
  print "\b"*4
  puts "#{flights.count > 0 ? '*** ' : nil}#{flights.count} roundtrip flights with maximum of #{DMAX} legs"
  puts flights
end;main
