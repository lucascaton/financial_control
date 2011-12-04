class EntryKind < EnumerateIt::Base
  associate_values(
    :credit => 'credit',
    :debit  => 'debit'
  )
end
