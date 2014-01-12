require 'spec_helper'

describe 'Check for vulnerabilities in Ruby gems' do
  specify 'Return value of gemsurance call should be zero' do
    `bundle exec gemsurance`
    $?.to_i.zero?.should be_true, "One or more of your Ruby gems has a known security vulnerability. Check #{Rails.root}/gemsurance_report.html for more info."
  end
end
