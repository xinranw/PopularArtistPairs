# encoding: utf-8

# Write a program that, using this file as input, produces a list of pairs of artists which appear TOGETHER in at least fifty different lists. For example, in the above sample, Radiohead and Morrissey appear together twice, but every other pair appears only once. Your program should output the pair list to stdout in the same form as the input (eg Artist Name 1, Artist Name 2\n).

# You MAY return an approximate solution, i.e. lists which appear at least 50 times with high probability, as long as you explain why this tradeoff improves the performance of the algorithm.

require 'pry'
require 'set'

class User
  attr_reader :artists

  def initialize artists
    @artists = Set.new(artists)
  end

  def number_of_artists
    return @artists.size
  end
end


class Knewton
  attr_accessor :users
  attr_reader :artists_dict, :popular_pairs, :file_name, :num_of_shared_users

  def initialize file_name, num_of_shared_users
    @users = []
    @artists_dict = {}
    @popular_pairs = {}
    @file_name = file_name
    @num_of_shared_users = num_of_shared_users
  end

  # Imports a file with user and favorite artists information. 
  # A new user object is created for each line of the file
  def importFile file_name
    File.open(file_name, "r") do |file|
      while (line = file.gets)
        @users << User.new(line.chomp.split(','))
      end
    end
  end

  # Iterates through the users list to generate a map of artists 
  # to how many times they appear in the list. Removes all artists that 
  # don't appear at least 50 times.
  def fillArtistsDict
    for user in @users
      for artist in user.artists
        if @artists_dict[artist]
          @artists_dict[artist] += 1
        else
          @artists_dict[artist] = 1
        end
      end
    end
    Knewton.trimDict @artists_dict, @num_of_shared_users
    return @artists_dict
  end

  # Removes all key-value pairs in a dictionary where the value is 
  # less than the minVal
  def self.trimDict dictionary, minVal
    for key, val in dictionary
      if val < minVal
        dictionary.delete(key)
      end
    end
  end

  # Generates a dictionary of artist pairs to how many times they occur
  # by iterating through the users list. Pairs of artists are only generated 
  # if each artist appears in the users list at least 50 times. Also, any user # with a list of less than 2 artists is skipped.
  def getPairs
    pair = Set.new
    pop_artists = Set.new @artists_dict.keys
    for user in @users
      common_artists = pop_artists.intersection(user.artists).to_a
      if common_artists.length < 2 then next end
      common_artists.combination(2) do |artist_pair|
        pair.merge(artist_pair)
        if @popular_pairs[pair]
          @popular_pairs[pair] += 1
        else
          @popular_pairs[Set.new artist_pair] = 1
        end
        pair.clear
      end
    end
    Knewton.trimDict @popular_pairs, @num_of_shared_users
  end

  # Outputs popular_pairs of artists to stdout in the correct format
  def outputPopularPairs
    for key, _ in @popular_pairs
      temp = key.to_a
      puts "#{temp[0]}, #{temp[1]}\r\n"
    end
  end

  def generateTopArtistPairs
    importFile @file_name
    fillArtistsDict
    getPairs
    outputPopularPairs
  end
end

knewton = Knewton.new "Artist_lists_small.txt", 50
knewton.generateTopArtistPairs
