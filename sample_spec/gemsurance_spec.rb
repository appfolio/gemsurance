require 'rails_helper'

describe 'Check for vulnerabilities in Ruby gems' do
  specify 'Return value of gemsurance call should be zero' do
    `bundle exec gemsurance`
    expect($?.to_i.zero?).to be_truthy,
      'One or more of your Ruby gems has a known security vulnerability. '\
      "Check #{Rails.root}/gemsurance_report.html for more info."
  end
end
