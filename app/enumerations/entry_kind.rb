# encoding: utf-8
class EntryKind < EnumerateIt::Base
  associate_values(
    credit: 'credit',
    debit:  'debit'
  )
end
