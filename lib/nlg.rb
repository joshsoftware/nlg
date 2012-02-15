require "active_support"
require "verbs"
require "nlg/sentence"
require "nlg/nlg_exception"
require "nlg/version"
require "nlg/paragraph"
require "nlg/sentence"
require "nlg/sentence_object"
require "nlg/entity/base"
require "nlg/entity/place"

module Nlg
  include Entity::Base
  include Entity::Place

  def self.included(base)
    base.extend Nlg::Entity::Base::ClassMethods
  end
end
