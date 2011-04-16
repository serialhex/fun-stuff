#!/usr/bin/env ruby

# spiffy program to find out how far you travel in a given amount of time

require 'mathn'

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

# see? simple!!