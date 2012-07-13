# encoding: utf-8
class EntryRecordKind < EnumerateIt::Base
  associate_values(
    unexpected:                 'unexpected',
    created_from_a_fixed_entry: 'created_from_a_fixed_entry'
  )
end
