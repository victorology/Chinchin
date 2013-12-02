object false
node (:status) { 'ok' }
child(@message_rooms => :message_rooms) do
    attribute :id, :status
    node(:uid, :if => lambda { |r| r.user1 == @current_user }) do |r|
        r.user2.uid
    end
    node(:uid, :if => lambda { |r| r.user2 == @current_user }) do |r|
        r.user1.uid
    end
    node(:last_message, :if => lambda { |r| r.messages.count > 0}) do |r|
        r.messages.last.content
    end
    node(:elapsed_time) { |r| time_ago_in_words(r.updated_at) }
end
