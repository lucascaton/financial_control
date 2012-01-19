class EntryRecordKind < EnumerateIt::Base
  associate_values(
    :unexpected                   => 'unexpected',
    :created_from_the_fixed_entry => 'created_from_the_fixed_entry'
  )
end
