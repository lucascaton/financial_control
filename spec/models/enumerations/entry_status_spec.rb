require 'spec_helper'

describe EntryStatus do
  it_should_be_an_enumeration_for(
    :done    => ['done', :done],
    :late    => ['late', :late],
    :warning => ['warning', :warning],
    :pending => ['pending', :pending]
  )
end
