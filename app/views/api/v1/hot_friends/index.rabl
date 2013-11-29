object false
node (:status) { 'ok' }
node (:leaders) do
  @leaders.map do |leader|
    {:name => leader[:chinchin].name, :uid => leader[:chinchin].uid, :likes => leader[:likes] }
  end
end