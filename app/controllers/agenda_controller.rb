class AgendaController < ApplicationController

  def index
    # create array of all without children
    @mutations = Mutation.all
  end

end
