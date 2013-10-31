require 'spec_helper'

describe Message do
  before(:each) do
    Message.delete_all
  end

  it 'occurs error when it was sent to the message room which is not opened yet' do
  end
end
