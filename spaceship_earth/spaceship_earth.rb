#!/usr/bin/env ruby

# spiffy program to find out how far you travel in a given amount of time
# until i create an input parser, import the SOB into irb & work on it in there
# or dont, i'm just saying...
#
# btw, this is not incredibly accurate as we're traveling at a little over 29km/sec
# through space, and i haven't taken into account things like a stellar day
# (the length of a day with the stars being in the same place is  ~4 mins shy of a 24hr day)
# ones altitude, the eccentricity of earths orbit around the sun, it's axial tilt, and other
# such factors, so i highly recommend *AGAINST* using this for precice measurements, i.e.
# astrology, the predicting of omens, finding your "one true love", or finding the safest place
# to be when quetzacoatyl comes back (btw, that's Time.new(2012, 12, 22) if you want to figure out
# how far you are going to travel before the world ends...)

# for the shoes version: https://github.com/ivanoblomov/google_maps_geocoder
# and for to package as a gem: http://guides.rubygems.org/make-your-own-gem/

require 'mathn'
require 'google_maps_geocoder'
require 'green_shoes'
require 'pry'

class SpaceshipEarth

  V_EARTH_AROUND_SUN = 2 * Math::PI * 149_597_890 / ( 365 * 24 * 60 * 60 ) # velocity in km/sec
  V_EARTHS_SPIN = 40_075.036 / ( 24 * 60 * 60 ) # velocity at equator in km/sec

  # Creates the new object.  you have 3 options here, one of which is required:
  # :latitude => # in radians.  is your current latitude if you dont know it you can
  #   go to maps.google.com, find where you are at, and then right-click the map.
  #   click "what's here" and in the search bar will be your latitude & longitude.
  #   by default this computes it from 0.0 - the equator
  # :here => Time. is the 'now' you are basing this off of (by default it IS now)
  # :there => Time.  the only required argument.  what time are we getting there?
  def initialize( args={} )
    @here = args[:here]
    @latitude = args[:latitude] || 0.0
    if args[:there]
      @there = args[:there]
    else
      raise ArgumentError, "There is no place we are going to!"
    end
  end

  # does all the cool maths to figure out how far we are going!
  def lets_go!
    here = @here || Time.now # if @here is defined, use it. otherwise use now!
    round_the_sun = (@there - here) * V_EARTH_AROUND_SUN
    round_ourselves = (@there - here) * Math.cos(@latitude) * V_EARTHS_SPIN
    return round_the_sun + round_ourselves
  end
end

Shoes.app :width => 640, :height => 480 do
  flow do
    stack :width => 0.5 do
      para "here"
      @here_line = edit_line do
        @here = @here_line.text
      end

      para "here time"
      @here_time = edit_line

      para "just to make sure..."
      @h_street = para "street: "
      @h_city = para "city: "
      @h_state = para "state: "
      @h_country = para "country: "
    end

    stack :width => 0.5 do
      para "there"
      @there_line = edit_line do |t|
        @there = @there_line.text
      end

      para "there time"
      @there_time = edit_line

      para "just to make sure..."
      @t_street = para "street: "
      @t_city = para "city: "
      @t_state = para "state: "
      @t_country = para "country: "
    end
  end


  button "GO!" do
    begin
      @here_loc = GoogleMapsGeocoder.new @here
    rescue => e
      alert "here evil exception of DHOOM!!! " + e.message
    end
    if @here_loc
      @h_street.text = "street: #{@here_loc.formatted_street_address}"
      @h_city.text = "city: #{@here_loc.city}"
      @h_state.text = "state: #{@here_loc.state_long_name}"
      @h_country.text = "country: #{@here_loc.country_long_name}"
    end
    begin
      @there_loc = GoogleMapsGeocoder.new @there
    rescue => e
      alert "there evil exception of DHOOM!!! " + e.message
    end
    if @there_loc
      @t_street.text = "street: #{@there_loc.formatted_street_address}"
      @t_city.text = "city: #{@there_loc.city}"
      @t_state.text = "state: #{@there_loc.state_long_name}"
      @t_country.text = "country: #{@there_loc.country_long_name}"
    end
  end

  stack do
    para 'stuff'
  end

end

# see? simple!!