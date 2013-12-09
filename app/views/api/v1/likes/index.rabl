object false
node (:status) { |m| 'ok' }
child(@likes => :likes) do
    attribute :chinchin_id => :id
    node(:uid) { |r| r.chinchin.uid }
    node(:name) { |r| r.chinchin.name }
    node(:elapsed_time) { |r| time_ago_in_words(r.updated_at) }
end