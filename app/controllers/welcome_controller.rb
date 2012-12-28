class WelcomeController < ApplicationController
  def index
    neo = Neography::Rest.new("http://91efc7e55:3f4e5a567@e19027147.hosted.neo4j.org:7661")
    @artists = neo.execute_query("start n=node(*) where ID(n) > 0 and n._type = 'Artist' return ID(n), n.name")["data"]
  end

  def suggested
    neo = Neography::Rest.new("http://91efc7e55:3f4e5a567@e19027147.hosted.neo4j.org:7661")
    unless params[:id] .nil?
      @suggested_artists = neo.execute_query("start artist=node(" + params[:id] + ")
                                              match artist-[:favors]-people-[:favors]-suggested_artists
                                              with suggested_artists, count(suggested_artists) as hotness
                                              where not ID(suggested_artists) = " + params[:id] + "
                                              return ID(suggested_artists), suggested_artists.name, hotness order by hotness desc;")["data"];
    end
    @artists = neo.execute_query("start n=node(*) where ID(n) > 0 and n._type = 'Artist' return ID(n), n.name")["data"]
  end
end
