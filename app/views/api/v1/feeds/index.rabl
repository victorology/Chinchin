object false
node (:status) { 'ok' }
child(@feeds => :feeds) do
    attributes :feed_type, :message
    node(:uid, :if => lambda { |f| f.target_user.present? }) do |f|
        f.target_user.uid
    end
    node(:elapsed_time) { |f| time_ago_in_words(f.created_at) }
end
