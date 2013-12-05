object false
node (:status) { 'ok' }
child(@messages => :messages) do
    attributes :id, :created_at, :content
    node(:uid, :if => lambda { |f| f.writer_id != @current_user.id }) do |f|
        f.writer.uid
    end
end