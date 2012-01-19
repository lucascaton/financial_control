require 'spec_helper'

describe EntryRecordKind do
  it_should_be_an_enumeration_for(
    :unexpected                   => ['unexpected', :unexpected],
    :created_from_a_fixed_entry => ['created_from_a_fixed_entry', :created_from_a_fixed_entry]
  )
end
