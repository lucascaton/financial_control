# encoding: utf-8

require 'spec_helper'

describe EntryKind do
  it_should_be_an_enumeration_for(
    :credit => ['credit', :credit],
    :debit  => ['debit', :debit]
  )
end
