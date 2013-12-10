object false
node (:status) { 'ok' }
child(@friends => :friends) do
    attribute :id, :status, :uid, :picture, :name
end