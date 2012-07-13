# encoding: utf-8
class EntryStatus < EnumerateIt::Base
  associate_values(
    done:    'done',
    late:    'late',
    warning: 'warning',
    pending: 'pending'
  )
end
